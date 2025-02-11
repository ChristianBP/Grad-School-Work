open Parker

let true_example =
  Forall ("x", Exists ("y", Or (Var "x", Var "y")))

let false_example =
  Forall ("x", Var "x")

let freevars_test =
  Or (Forall ("x", Var "x"), Var "x");;

let freevars_test2 =
  Or (Var "y", Var "abc");;

let test_sentence =
  Forall ("x", Or (Or (True, False), Not (Var "x")));;

let test_sentence2 =
  Exists ("x", Or (Or (True, False), Not (Var "x")));;

let test_freevars expected sentence () =
  Alcotest.(check (list string)) "same (list string)" expected (freevars sentence)

let test_tautology expected sentence () =
  Alcotest.(check bool) "same bool" expected (tautology sentence)

let test_string_of_fos expected sentence () =
  Alcotest.(check string) "same string" expected (string_of_fos sentence)

let test_update expected f a b c () =
  Alcotest.(check string) "same string" expected ((update f a b) c)

let test_update_int expected f a b c () =
  Alcotest.(check int) "same int" expected ((update f a b) c)

let test_compose_n expected f n m () =
  Alcotest.(check int) "same int" expected (compose_n f n m)

let test_compose_n_string expected f n m () =
  Alcotest.(check string) "same string" expected (compose_n f n m)

let test_selectall expected f l () =
  Alcotest.(check (list string)) "same (list string)" expected (selectall f l)

let mysentence_string = (Printf.sprintf "mysentence %s" (string_of_fos mysentence));;
let true_example_string = (Printf.sprintf "true_example %s" (string_of_fos true_example));;
let false_example_string = (Printf.sprintf "false_example %s" (string_of_fos false_example));;
let freevars_test_string = (Printf.sprintf "freevars_test %s" (string_of_fos freevars_test));;
let freevars_test2_string = (Printf.sprintf "freevars_test2 %s" (string_of_fos freevars_test2));;
let test_sentence_string = (Printf.sprintf "test_sentence %s" (string_of_fos test_sentence));;
let test_sentence2_string = (Printf.sprintf "test_sentence2 %s" (string_of_fos test_sentence2));;

let () =
  let open Alcotest in
  run "APL - Assignment 1" [
      "1.c) freevars", [
        mysentence_string,     `Quick, test_freevars [] mysentence;
        true_example_string,   `Quick, test_freevars [] true_example;
        false_example_string,  `Quick, test_freevars [] false_example;
        freevars_test_string,  `Quick, test_freevars ["x"] freevars_test;
        freevars_test2_string, `Quick, test_freevars ["y"; "abc"] freevars_test2;
        test_sentence_string,  `Quick, test_freevars [] test_sentence;
        test_sentence2_string, `Quick, test_freevars [] test_sentence2;
      ];
      "1.d) tautology", [
        mysentence_string,     `Quick, test_tautology false mysentence;
        true_example_string,   `Quick, test_tautology true true_example;
        false_example_string,  `Quick, test_tautology false false_example;
        freevars_test_string,  `Quick, test_tautology false freevars_test;
        freevars_test2_string, `Quick, test_tautology false freevars_test2;
        test_sentence_string,  `Quick, test_tautology true test_sentence;
        test_sentence2_string, `Quick, test_tautology true test_sentence2;
      ];
      "1.e) string_of_fos", [
        mysentence_string,     `Quick, test_string_of_fos "Ax.(Ax.(x)\\/~x)" mysentence;
        true_example_string,   `Quick, test_string_of_fos "Ax.(Ey.(x\\/y))" true_example;
        false_example_string,  `Quick, test_string_of_fos "Ax.(x)" false_example;
        freevars_test_string,  `Quick, test_string_of_fos "Ax.(x)\\/x" freevars_test;
        freevars_test2_string, `Quick, test_string_of_fos "y\\/abc" freevars_test2;
        test_sentence_string,  `Quick, test_string_of_fos "Ax.(T\\/F\\/~x)" test_sentence;
        test_sentence2_string, `Quick, test_string_of_fos "Ex.(T\\/F\\/~x)" test_sentence2;
      ];
      "2) f s = s ^ \"abc\"", [
        "update f \"X\" \"Y\" \"A\"", `Quick, test_update "Aabc" (fun s -> s ^ "abc") "X" "Y" "A";
        "update f \"X\" \"Y\" \"X\"", `Quick, test_update "Y" (fun s -> s ^ "abc") "X" "Y" "X";
      ];
      "2) f n = n / 3", [
        "update f 1234 1111 9", `Quick, test_update_int 3 (fun n -> n / 3) 1234 1111 9;
        "update f 1234 1111 9", `Quick, test_update_int 1111 (fun n -> n / 3) 1234 1111 1234;
      ];
      "3) f n = n + 2", [
        "compose_n f 5 0",    `Quick, test_compose_n 10 (fun n -> n + 2) 5 0;
        "compose_n f (-5) 0", `Quick, test_compose_n 0 (fun n -> n + 2) (-5) 0;
      ];
      "3) f s = s ^ \"AAA \"", [
        "compose_n f 5 \"B\"",    `Quick, test_compose_n_string "BAAA AAA AAA AAA AAA " (fun s -> s ^ "AAA ") 5 "B";
        "compose_n f (-5) \"B\"", `Quick, test_compose_n_string "B" (fun s -> s ^ "AAA ") (-5) "B";
      ];
      "4) selectall", [
        "(fun n -> n mod 2 = 0) [\"a\"; \"b\"; \"c\"; \"d\"]", `Quick, test_selectall ["b"; "d"] (fun n -> n mod 2 = 0) ["a"; "b"; "c"; "d"];
        "(fun n -> n mod 3 = 0) [\"a\"; \"b\"; \"c\"; \"d\"]", `Quick, test_selectall ["c"] (fun n -> n mod 3 = 0) ["a"; "b"; "c"; "d"];
      ];
    ]