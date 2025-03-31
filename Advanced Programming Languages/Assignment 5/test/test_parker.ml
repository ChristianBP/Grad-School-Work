open Parker
open Parker.Simpl
open Parker.Simpltypes

let exec_simpl prog args =
  let argval = (function "true" -> 1 | "false" -> 0 | x -> int_of_string x) in
  let argtyp = (function "true" | "false" -> TypBool | _ -> TypInt) in
  let c = (Simplparser.parse_cmd Simpllexer.token 
             (Lexing.from_channel (open_in ("sims/"^prog^".sim")))) in
  let s = init_store (Array.to_list (Array.mapi
            (fun i a -> ("arg"^(string_of_int i),
                         if i>=0 then (argval a) else 0))
            (Array.of_list args))) in
  let tc = init_typctx (Array.to_list (Array.mapi
            (fun i a -> ("arg"^(string_of_int i), VTyp (argtyp a,true)))
            (Array.of_list args))) in
  (match (typchk_cmd tc c) with
     CTypErr s -> ("Typing error: "^s^"\n")
   | TypCtx tc' ->
       (match (tc' "ret") with
          Undeclared -> "Typing error: return value undeclared"
        | VTyp(_,false) -> "Typing error: return value uninitialized"
        | VTyp(rtyp,true) -> let n = exec_cmd s c "ret" in
            if rtyp=TypInt then (string_of_int n)
            else if n=0 then "false" else "true");
    );;

let test_simpl prog expected n () =
  Alcotest.(check string) "same string" expected (exec_simpl prog n)

let () =
  let open Alcotest in
  run "APL - Assignment 5" [
      "division", [
        "6 3",       `Quick, test_simpl "division" "2"   ["6";"3"];
        "3 6",       `Quick, test_simpl "division" "0"   ["3";"6"];
        "50 10",     `Quick, test_simpl "division" "5"   ["50";"10"];
        "50 12",     `Quick, test_simpl "division" "4"   ["50";"12"];
        "121 11",    `Quick, test_simpl "division" "11"  ["121";"11"];
        "43541 455", `Quick, test_simpl "division" "95"  ["43541";"455"];
        "22 2",      `Quick, test_simpl "division" "11"  ["22";"2"];
        "999 6",     `Quick, test_simpl "division" "166" ["999";"6"];
        "10000 100", `Quick, test_simpl "division" "100" ["10000";"100"];
      ];
      "factorial", [
        "5",       `Quick, test_simpl "factorial" "120"       ["5"];
        "10",      `Quick, test_simpl "factorial" "3628800"   ["10"];
        "-1454",   `Quick, test_simpl "factorial" "1"         ["-1454"];
        "2",       `Quick, test_simpl "factorial" "2"         ["2"];
        "5 5 5 5", `Quick, test_simpl "factorial" "120"       ["5";"5";"5";"5"];
        "12",      `Quick, test_simpl "factorial" "479001600" ["12"];
      ];
      "fibonacci", [
        "-1",    `Quick, test_simpl "fibonacci" "0"           ["-1"];
        "0",     `Quick, test_simpl "fibonacci" "0"           ["0"];
        "1",     `Quick, test_simpl "fibonacci" "1"           ["1"];
        "2",     `Quick, test_simpl "fibonacci" "1"           ["2"];
        "10 20", `Quick, test_simpl "fibonacci" "55"          ["10";"20"];
        "17",    `Quick, test_simpl "fibonacci" "1597"        ["17"];
        "23",    `Quick, test_simpl "fibonacci" "28657"       ["23"];
        "50",    `Quick, test_simpl "fibonacci" "12586269025" ["50"];
      ];
      "gcd", [
        "3 6",      `Quick, test_simpl "gcd" "3"   ["3";"6"];
        "6 3",      `Quick, test_simpl "gcd" "3"   ["6";"3"];
        "6 3 53 4", `Quick, test_simpl "gcd" "3"   ["6";"3";"53";"4"];
        "15 25",    `Quick, test_simpl "gcd" "5"   ["15";"25"];
        "169 26",   `Quick, test_simpl "gcd" "13"  ["169";"26"];
        "48 18",    `Quick, test_simpl "gcd" "6"   ["48";"18"];
        "56 98",    `Quick, test_simpl "gcd" "14"  ["56";"98"];
        "101 103",  `Quick, test_simpl "gcd" "1"   ["101";"103"];
        "270 192",  `Quick, test_simpl "gcd" "6"   ["270";"192"];
        "81 27",    `Quick, test_simpl "gcd" "27"  ["81";"27"];
        "119 17",   `Quick, test_simpl "gcd" "17"  ["119";"17"];
        "144 89",   `Quick, test_simpl "gcd" "1"   ["144";"89"];
        "252 105",  `Quick, test_simpl "gcd" "21"  ["252";"105"];
        "84 36",    `Quick, test_simpl "gcd" "12"  ["84";"36"];
        "999 345",  `Quick, test_simpl "gcd" "3"   ["999";"345"];
        "-12 -13",  `Quick, test_simpl "gcd" "-13" ["-12";"-13"];
      ];
      "isprime", [
        "5 121 3", `Quick, test_simpl "isprime" "true" ["5";"121";"3"];
        "277",     `Quick, test_simpl "isprime" "true" ["277"];
        "173",     `Quick, test_simpl "isprime" "true" ["173"];
        "43",      `Quick, test_simpl "isprime" "true" ["43"];
        "223",     `Quick, test_simpl "isprime" "true" ["223"];
        "2",       `Quick, test_simpl "isprime" "true" ["2"];
        "-1",      `Quick, test_simpl "isprime" "false" ["-1"];
        "0",       `Quick, test_simpl "isprime" "false" ["0"];
        "1",       `Quick, test_simpl "isprime" "false" ["1"];
        "279",     `Quick, test_simpl "isprime" "false" ["279"];
        "175",     `Quick, test_simpl "isprime" "false" ["175"];
        "44",      `Quick, test_simpl "isprime" "false" ["44"];
        "231",     `Quick, test_simpl "isprime" "false" ["231"];
      ];
      "power", [
        "2 3",   `Quick, test_simpl "power" "8"           ["2";"3"];
        "3 2",   `Quick, test_simpl "power" "9"           ["3";"2"];
        "10 10", `Quick, test_simpl "power" "10000000000" ["10";"10"];
        "2 8",   `Quick, test_simpl "power" "256"         ["2";"8"];
        "8 2",   `Quick, test_simpl "power" "64"          ["8";"2"];
        "121 3", `Quick, test_simpl "power" "1771561"     ["121";"3"];
        "333 3", `Quick, test_simpl "power" "36926037"    ["333";"3"];
        "-2 5",  `Quick, test_simpl "power" "-32"         ["-2";"5"];
        "5 -2",  `Quick, test_simpl "power" "1"           ["5";"-2"];
      ];
      "Type errors", [
        "duplicate_declaration",      `Quick, test_simpl "duplicate_declaration" "Typing error: line 2 col 1 to 8: Variable 'var' already declared\n" [];
        "initialization_mismatch",    `Quick, test_simpl "initialization_mismatch" "Typing error: line 2 col 1 to 20: Expression does not match declared type for 'ret'\n" [];
        "int_conditional",            `Quick, test_simpl "int_conditional" "Typing error: line 4 col 1 to line 6 col 19: if/else conditional must be type bool\n" [];
        "invalid_type_plus",          `Quick, test_simpl "invalid_type_plus" "Typing error: line 2 col 8 to 16: Expression types don't match\n" [];
        "undeclared_ret",             `Quick, test_simpl "undeclared_ret" "Typing error: line 1 col 1 to 8: Variable 'ret' is undeclared\n" [];
        "undeclared_var_assignment",  `Quick, test_simpl "undeclared_var_assignment" "Typing error: line 1 col 1 to 9: Variable 'a' is undeclared\n" [];
        "undeclared_var_conditional", `Quick, test_simpl "undeclared_var_conditional" "Typing error: line 2 col 4 to 6: Variable 'ret' has not been declared\n" [];
        "unexpected_types",           `Quick, test_simpl "unexpected_types" "Typing error: line 2 col 8 to 19: Expression types do not match expected type\n" [];
        "uninitialized_var",          `Quick, test_simpl "uninitialized_var" "Typing error: line 2 col 4 to 6: Variable 'var' has not been initialized\n" [];
        "while_conditional",          `Quick, test_simpl "while_conditional" "Typing error: line 4 col 1 to line 6 col 1: while loop conditional must be type bool\n" [];
      ];
    ]