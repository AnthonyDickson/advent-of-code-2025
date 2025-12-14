let load_input filename =
  let ic = In_channel.open_text filename in
  let content = In_channel.input_lines ic in
  In_channel.close ic;
  content
;;

type char_matrix = char list list

(** Takes the multiline string, trims the empty line created by the trailing
    empty line, and then converts the string into a matrix of chars. *)
let parse_matrix (lines : string list) : char_matrix =
  let explode_string s = List.init (String.length s) (String.get s) in
  lines |> List.map explode_string
;;

let rec transpose_matrix = function
  | [] -> []
  | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose_matrix (List.map List.tl rows)
;;

(** Split a matrix on empty columns into many matrices.
Assumes empty columns do not appear at first or last columns *)
let split_at_empty_column (m : char_matrix) : char_matrix list =
  let is_empty_row = List.for_all (fun c -> c = ' ') in
  let rec split (matrix : char_matrix) (matrices : char_matrix list) mm =
    match mm with
    | [] -> matrix :: matrices
    | row :: other_rows ->
      if is_empty_row row
      then split [] (matrix :: matrices) other_rows
      else split (row :: matrix) matrices other_rows
  in
  m
  |> transpose_matrix
  |> split [] []
  |> List.map List.rev
  |> List.map transpose_matrix
  |> List.rev
;;

type operation =
  | Multiply
  | Add

type problem = int list * operation

let parse_operation (m : char list) =
  let operation_of_char c =
    match c with
    | '*' -> Multiply
    | '+' -> Add
    | _ ->
      raise (Invalid_argument ("Got an invalid operator char '" ^ String.make 1 c ^ "'"))
  in
  match m with
  | [] -> raise (Invalid_argument "cannot parse operation on an empty list")
  | [ c ] -> operation_of_char c
  | c :: _ -> operation_of_char c
;;

type orientation =
  | Row
  | Column

(** Parses numbers in the [m]atrix from left to right if [o] is [Row] or top to
bottom if [o] is [Column]. Expects [m] to be the result of [parse_matrix]
without transposing. *)
let parse_problems (o : orientation) (m : char_matrix) : problem list =
  let split_end l =
    match List.rev l with
    | [] -> raise (Invalid_argument "Cannot get last element of an empty list")
    | h :: t -> List.rev t, h
  in
  let parse_number chars =
    chars
    |> List.filter (fun c -> c != ' ')
    |> List.to_seq
    |> String.of_seq
    |> int_of_string
  in
  let parse_problem matrix =
    let number_rows, operation_row = split_end matrix in
    match o with
    | Row -> List.map parse_number number_rows, parse_operation operation_row
    | Column ->
      List.map parse_number (transpose_matrix number_rows), parse_operation operation_row
  and matrices = split_at_empty_column m in
  List.map parse_problem matrices
;;

let solve_problem (p : problem) : int =
  match p with
  | numbers, Multiply -> List.fold_left ( * ) 1 numbers
  | numbers, Add -> List.fold_left ( + ) 0 numbers
;;

let solve_part_one s =
  s
  |> parse_matrix
  |> parse_problems Row
  |> List.map solve_problem
  |> List.fold_left ( + ) 0
;;

let solve_part_two s =
  s
  |> parse_matrix
  |> parse_problems Column
  |> List.map solve_problem
  |> List.fold_left ( + ) 0
;;
