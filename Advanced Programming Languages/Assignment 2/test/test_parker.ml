open Parker
open Parker.Simpl

let exec_simpl prog args =
  let c = (Simplparser.parse_cmd Simpllexer.token 
                (Lexing.from_channel (open_in ("sims/"^prog^".sim")))) in
      let s = init_store (Array.to_list (Array.mapi
                (fun i a -> ("arg"^(string_of_int i),
                  (try a
                   with Failure _ -> raise (Failure "args must be ints"))))
                (Array.of_list args))) in
      let s2 = exec_cmd s c in
        (match (try Some (s2 "ret") with Not_found -> None) with
                       | None -> "<no value returned>"
                       | Some n -> string_of_int n);
                  ;;

let test_simpl prog expected n () =
  Alcotest.(check string) "same string" expected (exec_simpl prog n)

let () =
  let open Alcotest in
  run "APL - Assignment 2" [
      "factorial", [
        "5",       `Quick, test_simpl "factorial" "120"       [5];
        "10",      `Quick, test_simpl "factorial" "3628800"   [10];
        "-1454",   `Quick, test_simpl "factorial" "1"         [-1454];
        "2",       `Quick, test_simpl "factorial" "2"         [2];
        "5 5 5 5", `Quick, test_simpl "factorial" "120"       [5;5;5;5];
        "12",      `Quick, test_simpl "factorial" "479001600" [12];
      ];
      "isprime", [
        "5 121 3", `Quick, test_simpl "isprime" "1" [5;121;3];
        "277",     `Quick, test_simpl "isprime" "1" [277];
        "173",     `Quick, test_simpl "isprime" "1" [173];
        "43",      `Quick, test_simpl "isprime" "1" [43];
        "223",     `Quick, test_simpl "isprime" "1" [223];
        "2",       `Quick, test_simpl "isprime" "1" [2];
        "-1",      `Quick, test_simpl "isprime" "0" [-1];
        "0",       `Quick, test_simpl "isprime" "0" [0];
        "1",       `Quick, test_simpl "isprime" "0" [1];
        "279",     `Quick, test_simpl "isprime" "0" [279];
        "175",     `Quick, test_simpl "isprime" "0" [175];
        "44",      `Quick, test_simpl "isprime" "0" [44];
        "231",     `Quick, test_simpl "isprime" "0" [231];
      ];
      "gcd", [
        "3 6",      `Quick, test_simpl "gcd" "3"   [3;6];
        "6 3",      `Quick, test_simpl "gcd" "3"   [6;3];
        "6 3 53 4", `Quick, test_simpl "gcd" "3"   [6;3;53;4];
        "15 25",    `Quick, test_simpl "gcd" "5"   [15;25];
        "169 26",   `Quick, test_simpl "gcd" "13"  [169;26];
        "48 18",    `Quick, test_simpl "gcd" "6"   [48;18];
        "56 98",    `Quick, test_simpl "gcd" "14"  [56;98];
        "101 103",  `Quick, test_simpl "gcd" "1"   [101;103];
        "270 192",  `Quick, test_simpl "gcd" "6"   [270;192];
        "81 27",    `Quick, test_simpl "gcd" "27"  [81;27];
        "119 17",   `Quick, test_simpl "gcd" "17"  [119;17];
        "144 89",   `Quick, test_simpl "gcd" "1"   [144;89];
        "252 105",  `Quick, test_simpl "gcd" "21"  [252;105];
        "84 36",    `Quick, test_simpl "gcd" "12"  [84;36];
        "999 345",  `Quick, test_simpl "gcd" "3"   [999;345];
        "-12 -13",  `Quick, test_simpl "gcd" "-13" [-12;-13];
      ];
      "division", [
        "6 3",       `Quick, test_simpl "division" "2"   [6;3];
        "3 6",       `Quick, test_simpl "division" "0"   [3;6];
        "50 10",     `Quick, test_simpl "division" "5"   [50;10];
        "50 12",     `Quick, test_simpl "division" "4"   [50;12];
        "121 11",    `Quick, test_simpl "division" "11"  [121;11];
        "43541 455", `Quick, test_simpl "division" "95"  [43541;455];
        "22 2",      `Quick, test_simpl "division" "11"  [22;2];
        "999 6",     `Quick, test_simpl "division" "166" [999;6];
        "10000 100", `Quick, test_simpl "division" "100" [10000;100];
      ];
      "power", [
        "2 3",   `Quick, test_simpl "power" "8"           [2;3];
        "3 2",   `Quick, test_simpl "power" "9"           [3;2];
        "10 10", `Quick, test_simpl "power" "10000000000" [10;10];
        "2 8",   `Quick, test_simpl "power" "256"         [2;8];
        "8 2",   `Quick, test_simpl "power" "64"          [8;2];
        "121 3", `Quick, test_simpl "power" "1771561"     [121;3];
        "333 3", `Quick, test_simpl "power" "36926037"    [333;3];
        "-2 5",  `Quick, test_simpl "power" "-32"         [-2;5];
        "5 -2",  `Quick, test_simpl "power" "1"           [5;-2];
      ];
      "fibonacci", [
        "-1",    `Quick, test_simpl "fibonacci" "0"           [-1];
        "0",     `Quick, test_simpl "fibonacci" "0"           [0];
        "1",     `Quick, test_simpl "fibonacci" "1"           [1];
        "2",     `Quick, test_simpl "fibonacci" "1"           [2];
        "10 20", `Quick, test_simpl "fibonacci" "55"          [10;20];
        "17",    `Quick, test_simpl "fibonacci" "1597"        [17];
        "23",    `Quick, test_simpl "fibonacci" "28657"       [23];
        "50",    `Quick, test_simpl "fibonacci" "12586269025" [50];
      ];
    ]