open Simpltypes;;

(* A SIMPL variable's type is either Undeclared (it is an error to use it in
 * this case) or it has a declared type of "ityp" (see imptypes.ml for a
 * definition of ityp). The bool part should be true if the variable has been
 * initialized (i.e., it has been assigned a value) or false if it is still
 * uninitialized. *)
type vartyp =
        Undeclared
      | VTyp of (ityp * bool)

(* A typing context maps variable names to variable types *)
type typctx = varname -> vartyp

(* A SIMPL command's "type" is the typing context that results after it is
 * executed (or CTypErr if it is not well-typed). *)
type cmdtyp = TypCtx of typctx | CTypErr of string

(* A SIMPL expression's type is an ityp (or ETypErr if it is not well-typed). *)
type exprtyp = ExpTyp of ityp | ETypErr of string

let update s v i = (fun x -> if x=v then i else (s x));;

let init_typctx (l : (varname*vartyp) list) : typctx =
  (fun v ->
    match (try Some (List.assoc v l) with Not_found -> None) with
    | None -> Undeclared
    | Some vtyp -> vtyp);;

let lineerror (li : lineinfo) : string =
  match li with ((l1, c1), (l2, c2)) ->
    "line "^ string_of_int l1 ^" col "^ string_of_int c1 ^" to "^
    (if l1 != l2 then "line "^ string_of_int l2 ^" col " else "") ^
    string_of_int c2 ^": "
;;


let rec typchk_expr (tc:typctx) (e:iexpr) : exprtyp =
  let typchk_op (a:ityp) (r:ityp) (e1:iexpr) (e2:iexpr) (li:lineinfo) : exprtyp =
    (match typchk_expr tc e1 with
    | ExpTyp t1 -> (match typchk_expr tc e2 with
                  | ExpTyp t2 -> if t1 = t2 then
                                    (if t1 = a
                                    then ExpTyp r
                                    else ETypErr (lineerror li ^"Expression types do not match expected type"))
                                 else ETypErr (lineerror li ^"Expression types don't match")
                  | ETypErr e -> ETypErr e)
    | ETypErr e -> ETypErr e) in
  (match e with
  | Const _ -> ExpTyp TypInt
  | Var (v, li) -> (match tc (v) with
                  | Undeclared -> ETypErr (lineerror li ^"Variable '"^v^"' has not been declared")
                  | VTyp (_, false) -> ETypErr (lineerror li ^"Variable '"^v^"' has not been initialized")
                  | VTyp (t, true) -> ExpTyp t)
  | Plus (e1, e2, li) -> typchk_op TypInt TypInt e1 e2 li
  | Minus (e1, e2, li) -> typchk_op TypInt TypInt e1 e2 li
  | Times (e1, e2, li) -> typchk_op TypInt TypInt e1 e2 li
  | True _ -> ExpTyp TypBool
  | False _ -> ExpTyp TypBool
  | Leq (e1, e2, li) -> typchk_op TypInt TypBool e1 e2 li
  | Conj (e1, e2, li) -> typchk_op TypBool TypBool e1 e2 li
  | Disj (e1, e2, li) -> typchk_op TypBool TypBool e1 e2 li
  | Neg (e, li) -> typchk_op TypBool TypBool e e li)
  ;;

let rec typchk_cmd (tc:typctx) (c:icmd) : cmdtyp =
  match c with
  | Skip (_) -> TypCtx tc
  | Seq (c1, c2, _) -> (match typchk_cmd tc c1 with
                      | TypCtx tc2 -> typchk_cmd tc2 c2
                      | CTypErr e -> CTypErr e)
  | Assign (v, e, li) -> (match typchk_expr tc e with
                      | ExpTyp t1 -> (match tc v with
                                    | Undeclared -> CTypErr (lineerror li ^"Variable '"^v^"' is undeclared")
                                    | VTyp (t2, _) -> if t1 = t2
                                                      then TypCtx (update tc v (VTyp (t1, true)))
                                                      else CTypErr (lineerror li ^"Expression does not match declared type for '"^v^"'"))
                      | ETypErr e -> CTypErr e)
  | Cond (e, c1, c2, li) -> (match typchk_expr tc e with
                      | ExpTyp t -> if t = TypBool then
                                      (match typchk_cmd tc c1 with
                                      | TypCtx _ -> (match typchk_cmd tc c2 with
                                                    | TypCtx _ -> TypCtx tc
                                                    | CTypErr e -> CTypErr e)
                                      | CTypErr e -> CTypErr e)
                                    else (CTypErr (lineerror li ^"if/else conditional must be type bool"))
                      | ETypErr e -> CTypErr e)
  | While (e, c, li) -> (match typchk_expr tc e with
                      | ETypErr e -> CTypErr e
                      | ExpTyp t -> if t = TypBool then
                                      (match typchk_cmd tc c with
                                      | TypCtx _ -> TypCtx tc
                                      | CTypErr e -> CTypErr e)
                                    else CTypErr (lineerror li ^"while loop conditional must be type bool"))
  | Decl (t, v, li) -> match tc v with
                      | Undeclared -> TypCtx (update tc v (VTyp (t, false)))
                      | VTyp _ -> CTypErr (lineerror li ^"Variable '"^v^"' already declared")
;;

(* NO CHANGES REQUIRED AFTER THIS POINT
 * The following code is essentially the same as the interpreter you wrote
 * for assignment 2, except modified to interpret typed programs instead of
 * untyped programs. *)

type store = varname -> int

let init_store (l : (varname*int) list) : store =
  fun x -> List.assoc x l;;

let rec eval_expr (s:store) (e:iexpr) : int =
  (match e with
     Const (n,_) -> n
   | Var (x,_) -> (s x)
   | Plus (e1,e2,_)  | Disj (e1,e2,_) -> (eval_expr s e1) + (eval_expr s e2)
   | Minus (e1,e2,_) -> (eval_expr s e1) - (eval_expr s e2)
   | Times (e1,e2,_) | Conj (e1,e2,_) -> (eval_expr s e1) * (eval_expr s e2)
   | True _ -> 1
   | False _ -> 0
   | Leq (e1,e2,_) -> if (eval_expr s e1) <= (eval_expr s e2) then 1 else 0
   | Neg (e1,_) -> if (eval_expr s e1)=0 then 1 else 0
  );;

let rec exec_cmd (s:store) (c:icmd) : store =
  (match c with
     Skip _ | Decl _ -> s
   | Seq (c1,c2,_) -> exec_cmd (exec_cmd s c1) c2
   | Assign (v,e,_) -> update s v (eval_expr s e)
   | Cond (e,c1,c2,_) -> exec_cmd s (if (eval_expr s e)=0 then c2 else c1)
   | While (e,c1,li) -> exec_cmd s (Cond (e,Seq (c1,c,li),Skip li,li))
  );;

