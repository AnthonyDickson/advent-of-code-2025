open Alcotest

let example_input =
  [ "123 328  51 64 "; " 45 64  387 23 "; "  6 98  215 314"; "*   +   *   +  " ]
;;

let expected_matrix =
  [ [ '1'; '2'; '3'; ' '; '3'; '2'; '8'; ' '; ' '; '5'; '1'; ' '; '6'; '4'; ' ' ]
  ; [ ' '; '4'; '5'; ' '; '6'; '4'; ' '; ' '; '3'; '8'; '7'; ' '; '2'; '3'; ' ' ]
  ; [ ' '; ' '; '6'; ' '; '9'; '8'; ' '; ' '; '2'; '1'; '5'; ' '; '3'; '1'; '4' ]
  ; [ '*'; ' '; ' '; ' '; '+'; ' '; ' '; ' '; '*'; ' '; ' '; ' '; '+'; ' '; ' ' ]
  ]
;;

let char_matrix_testable = list (list char)

let test_parse_as_matrix () =
  let actual = Aoc.parse_matrix example_input in
  check char_matrix_testable "parses input as matrix of strings" expected_matrix actual
;;

let expected_transposed_matrix =
  [ [ '1'; ' '; ' '; '*' ]
  ; [ '2'; '4'; ' '; ' ' ]
  ; [ '3'; '5'; '6'; ' ' ]
  ; [ ' '; ' '; ' '; ' ' ]
  ; [ '3'; '6'; '9'; '+' ]
  ; [ '2'; '4'; '8'; ' ' ]
  ; [ '8'; ' '; ' '; ' ' ]
  ; [ ' '; ' '; ' '; ' ' ]
  ; [ ' '; '3'; '2'; '*' ]
  ; [ '5'; '8'; '1'; ' ' ]
  ; [ '1'; '7'; '5'; ' ' ]
  ; [ ' '; ' '; ' '; ' ' ]
  ; [ '6'; '2'; '3'; '+' ]
  ; [ '4'; '3'; '1'; ' ' ]
  ; [ ' '; ' '; '4'; ' ' ]
  ]
;;

let test_transpose_matrix () =
  let actual = Aoc.transpose_matrix expected_matrix in
  check char_matrix_testable "example input" expected_transposed_matrix actual
;;

let test_transpose_matrix_twice () =
  let actual = Aoc.transpose_matrix (Aoc.transpose_matrix expected_matrix) in
  check char_matrix_testable "example input" expected_matrix actual
;;

let expected_split_matrices : Aoc.char_matrix list =
  [ [ [ '1'; '2'; '3' ]; [ ' '; '4'; '5' ]; [ ' '; ' '; '6' ]; [ '*'; ' '; ' ' ] ]
  ; [ [ '3'; '2'; '8' ]; [ '6'; '4'; ' ' ]; [ '9'; '8'; ' ' ]; [ '+'; ' '; ' ' ] ]
  ; [ [ ' '; '5'; '1' ]; [ '3'; '8'; '7' ]; [ '2'; '1'; '5' ]; [ '*'; ' '; ' ' ] ]
  ; [ [ '6'; '4'; ' ' ]; [ '2'; '3'; ' ' ]; [ '3'; '1'; '4' ]; [ '+'; ' '; ' ' ] ]
  ]
;;

let test_split_at_empty_column () =
  let actual = Aoc.split_at_empty_column expected_matrix in
  check (list char_matrix_testable) "example input" expected_split_matrices actual
;;

let matrix_variable_width =
  [ [ '1'; '2'; ' '; '1'; '2'; '3' ]
  ; [ '3'; '4'; ' '; ' '; '4'; '5' ]
  ; [ '*'; ' '; ' '; '+'; ' '; ' ' ]
  ]
;;

let expected_split_variable_width =
  [ [ [ '1'; '2' ]; [ '3'; '4' ]; [ '*'; ' ' ] ]
  ; [ [ '1'; '2'; '3' ]; [ ' '; '4'; '5' ]; [ '+'; ' '; ' ' ] ]
  ]
;;

let test_split_variable_width () =
  let actual = Aoc.split_at_empty_column matrix_variable_width in
  check
    (list char_matrix_testable)
    "variable width columns"
    expected_split_variable_width
    actual
;;

let expected_parsed_problems : Aoc.problem list =
  [ [ 123; 45; 6 ], Aoc.Multiply
  ; [ 328; 64; 98 ], Aoc.Add
  ; [ 51; 387; 215 ], Aoc.Multiply
  ; [ 64; 23; 314 ], Aoc.Add
  ]
;;

let problem_testable =
  testable
    (fun fmt (nums, action) ->
       Format.fprintf
         fmt
         "([%s], %a)"
         (String.concat "; " (List.map string_of_int nums))
         (fun fmt -> function
            | Aoc.Multiply -> Format.fprintf fmt "Multiply"
            | Aoc.Add -> Format.fprintf fmt "Add")
         action)
    (fun (nums1, act1) (nums2, act2) -> nums1 = nums2 && act1 = act2)
;;

let test_parse_problems () =
  let actual = Aoc.parse_problems expected_matrix in
  check
    (list problem_testable)
    "parses problems with horizontal numbers"
    expected_parsed_problems
    actual
;;

let test_part_one () =
  check int "example input" 4_277_556 (Aoc.solve_part_one example_input)
;;

let test_part_two () = check int "solves part two" 0 (Aoc.solve_part_two "")

let () =
  run
    "AoC"
    [ ( "Parsing"
      , [ test_case "Parse raw input as matrix" `Quick test_parse_as_matrix
        ; test_case "Transpose matrix" `Quick test_transpose_matrix
        ; test_case "Transpose matrix twice" `Quick test_transpose_matrix_twice
        ; test_case "Split matrix at empty columns" `Quick test_split_at_empty_column
        ; test_case
            "Split matrix with variable width columns"
            `Quick
            test_split_variable_width
        ; test_case "Parse inputs" `Quick test_parse_problems
        ] )
    ; "Part One", [ test_case "Solves example" `Quick test_part_one ]
    ; "Part Two", [ test_case "Example 1" `Quick test_part_two ]
    ]
;;
