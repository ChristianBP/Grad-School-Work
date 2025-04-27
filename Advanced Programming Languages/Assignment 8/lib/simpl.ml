open Simpltypes;;

type vartyp =
        Undeclared
      | VTyp of (ityp * bool)

type typctx = varname -> vartyp

type cmdtyp = TypCtx of typctx | CTypErr of string

type exprtyp = ExpTyp of ityp | ETypErr of string

let update s v i = (fun x -> if x=v then i else (s x));;

let init_typctx (l : (varname*vartyp) list) : typctx =
  fun x -> (try (List.assoc x l) with Not_found -> Undeclared);;

let lineerror ((l1, c1), (l2, c2)) =
    "line "^ string_of_int l1 ^" col "^ string_of_int c1 ^" to "^
    (if l1 != l2 then "line "^ string_of_int l2 ^" col " else "") ^
    string_of_int c2 ^": "
;;

let rec typchk_expr (tc:typctx) (e:iexpr) : exprtyp =
  let typchk_op (a:ityp) (r:ityp) (e1, e2, li) : exprtyp =
    (match (typchk_expr tc e1, typchk_expr tc e2) with
    | (ETypErr e, _) | (_, ETypErr e) -> ETypErr e
    | (ExpTyp t1, ExpTyp t2) -> if t1 = t2
                                then (
                                    if t1 = a
                                    then ExpTyp r
                                    else ETypErr (lineerror li ^"Expression types do not match expected type"))
                                else ETypErr (lineerror li ^"Expression types don't match")) in

  (match e with
  | Const _ -> ExpTyp TypInt
  | Var (v, li) -> (match tc v with
                  | VTyp (t, true) -> ExpTyp t
                  | VTyp (_, false) -> ETypErr (lineerror li ^"Variable '"^v^"' has not been initialized")
                  | Undeclared -> ETypErr (lineerror li ^"Variable '"^v^"' has not been declared"))
  | Plus x | Minus x | Times x -> typchk_op TypInt TypInt x
  | True _ | False _ -> ExpTyp TypBool
  | Leq x -> typchk_op TypInt TypBool x
  | Conj x | Disj x -> typchk_op TypBool TypBool x
  | Neg (e, li) -> typchk_op TypBool TypBool (e, True li, li)
  | Abstraction (al,c,li) ->
      if List.length (List.filter (fun (v,_,_) -> tc v <> Undeclared) al) > 0
      then ETypErr (lineerror li ^"Function parameters don't match or were previously declared")
      else (match typchk_cmd (List.fold_left (fun tca (v, t1, _) -> update tca v (VTyp (t1, true))) tc al) c with
        | CTypErr e -> ETypErr e
        | TypCtx tc' -> match tc' "ret" with
                      | Undeclared -> ETypErr (lineerror li ^"ret was not declared within function")
                      | VTyp (_, false) -> ETypErr (lineerror li ^"ret was not initialized within function")
                      | VTyp (t, true) -> ExpTyp (TypFunc (List.map (fun (_, t1, _) -> t1) al, t)))
  | Apply (e1,el,li) -> (match (typchk_expr tc e1, List.map (fun e -> typchk_expr tc e) el) with
                      | (ExpTyp (TypFunc (tl1, t1)), tl2) ->
                          (try
                            (match List.filter (function
                                                  (tx, ExpTyp ty) ->  tx <> ty
                                                | (_, ETypErr _) -> true) (List.combine tl1 tl2) with
                            | _::_ -> ETypErr (lineerror li ^"Function type signature does not match input types")
                            | [] -> ExpTyp t1)
                          with Invalid_argument _ -> ETypErr (lineerror li ^"Function expects "^string_of_int (List.length tl1)^" paramaters but got "^string_of_int (List.length tl2)))
                      | (ETypErr e, _) -> ETypErr e
                      | (ExpTyp _, _) -> ETypErr (lineerror li ^"Cannot apply non-function expressions")))

and typchk_cmd (tc:typctx) (c:icmd) : cmdtyp =
  match c with
  | Skip _ -> TypCtx tc
  | Seq (c1, c2, _) -> (match typchk_cmd tc c1 with
                      | CTypErr e -> CTypErr e
                      | TypCtx tc2 -> typchk_cmd tc2 c2)
  | Assign (v, e, li) -> (match (tc v, typchk_expr tc e) with
                      | (_, ETypErr e) -> CTypErr e
                      | (VTyp (t1, _), ExpTyp t2) ->
                          if t1 = t2
                          then TypCtx (update tc v (VTyp (t1, true)))
                          else CTypErr (lineerror li ^"Expression does not match declared type for '"^v^"'")
                      | (Undeclared, _) -> CTypErr (lineerror li ^"Variable '"^v^"' is undeclared"))
  | Cond (e, c1, c2, li) -> (match (typchk_expr tc e, typchk_cmd tc c1, typchk_cmd tc c2) with
                            | (ETypErr e, _, _) | (_, CTypErr e, _) | (_, _, CTypErr e) -> CTypErr e
                            | (ExpTyp TypBool, TypCtx _, TypCtx _) -> TypCtx tc
                            | (ExpTyp _, TypCtx _, TypCtx _) -> CTypErr (lineerror li ^"if/else conditional must be type bool"))
  | While (e, c, li) -> (match (typchk_expr tc e, typchk_cmd tc c) with
                      | (ETypErr e, _) | (_, CTypErr e) -> CTypErr e
                      | (ExpTyp TypBool, TypCtx _) -> TypCtx tc
                      | (ExpTyp _, TypCtx _) -> CTypErr (lineerror li ^"while loop conditional must be type bool"))
  | Decl (t, v, li) -> match tc v with
                      | Undeclared -> TypCtx (update tc v (VTyp (t, false)))
                      | VTyp _ -> CTypErr (lineerror li ^"Variable '"^v^"' already declared")
;;

exception SegFault

type heapval = Data of int | Code of (varname list * icmd)
type store = varname -> heapval

let init_store (l : (varname*heapval) list) : store =
  fun x -> List.assoc x l;;

let rec eval_expr (s:store) (e:iexpr) : heapval =

  let eval_intop f (e1,e2,_) =
    (match (eval_expr s e1, eval_expr s e2) with
        (Data n1, Data n2) -> Data (f n1 n2)
      | _ -> raise SegFault) in

  let eval_boolop f =
    eval_intop (fun x y -> if (f (x<>0) (y<>0)) then 1 else 0) in

  let update_list =
    List.fold_left (fun s1 (v, e) -> update s1 v (eval_expr s e)) s in

  (match e with
      Const (n,_) -> Data n
    | Var (x,_) -> (s x)
    | Plus z -> eval_intop (+) z
    | Minus z -> eval_intop (-) z
    | Times z -> eval_intop ( * ) z
    | True _ -> Data 1
    | False _ -> Data 0
    | Leq z -> eval_intop (fun x y -> if x<=y then 1 else 0) z
    | Conj z -> eval_boolop (&&) z
    | Disj z -> eval_boolop (||) z
    | Neg (e1,li) -> eval_boolop (fun x _ -> not x) (e1,True li,li)
    | Abstraction (al,c,_) -> Code (List.map (fun (v, _, _) -> v) al, c)
    | Apply (e1,el,_) -> match (eval_expr s e1) with
                        | Code (vl, c) -> (try (exec_cmd (update_list (List.combine vl el)) c) "ret" with Invalid_argument _ -> raise SegFault)
                        | Data _ -> raise SegFault)

and exec_cmd (s:store) (c:icmd) : store =
  (match c with
      Skip _ | Decl _ -> s
    | Seq (c1,c2,_) -> exec_cmd (exec_cmd s c1) c2
    | Assign (v,e,_) -> update s v (eval_expr s e)
    | Cond (e,c1,c2,_) ->
        exec_cmd s (if (eval_expr s e)=(Data 0) then c2 else c1)
    | While (e,c1,li) -> exec_cmd s (Cond (e,Seq (c1,c,li),Skip li,li))
  );;
