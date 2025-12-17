import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

import simplifile

pub fn main() -> Int {
  case simplifile.read("input.txt") {
    Ok(input) -> {
      let adjacency_list = parse_input(input)

      adjacency_list
      |> solve_part_one
      |> int.to_string
      |> io.println

      adjacency_list
      |> solve_part_two
      |> int.to_string
      |> io.println

      0
    }
    Error(error) -> {
      io.println_error(
        "Could not load \"input.txt\": " <> simplifile.describe_error(error),
      )
      1
    }
  }
}

pub fn parse_input(file_contents: String) -> Dict(String, List(String)) {
  let parse_line = fn(line) {
    case string.split(line, " ") {
      [] ->
        panic as {
          "Got an invalid line"
          <> string.inspect(line)
          <> ", expect format \"aaa: bbb ccc\""
        }
      [key, ..values] -> #(string.drop_end(key, 1), values)
    }
  }

  file_contents
  |> string.trim_end
  |> string.split("\n")
  |> list.map(parse_line)
  |> dict.from_list
}

pub fn solve_part_one(adjacency_list: Dict(String, List(String))) -> Int {
  count_paths(matching: "out", starting_at: "you", in: adjacency_list)
}

/// Traveres the graph depth first, assumes no cycles.
fn count_paths(
  matching needle: String,
  starting_at node: String,
  in adjacency_list: Dict(String, List(String)),
) -> Int {
  case node == needle {
    True -> 1
    False -> {
      let adjacent = dict.get(adjacency_list, node) |> result.unwrap([])
      list.fold(adjacent, 0, fn(acc, n) {
        acc + count_paths(needle, n, adjacency_list)
      })
    }
  }
}

pub fn solve_part_two(adjacency_list: Dict(String, List(String))) -> Int {
  // use cache <- memo.create()
  let #(result, _) =
    count_paths_with_dac_and_fft(
      matching: "out",
      starting_at: "svr",
      in: adjacency_list,
      fft_found: False,
      dac_found: False,
      with_memory: dict.new(),
    )
  result
}

/// Traveres the graph depth first, assumes no cycles.
fn count_paths_with_dac_and_fft(
  matching needle: String,
  starting_at node: String,
  in adjacency_list: Dict(String, List(String)),
  fft_found fft_found: Bool,
  dac_found dac_found: Bool,
  with_memory cache,
) -> #(Int, Dict(#(String, Bool, Bool), Int)) {
  case dict.get(cache, #(node, fft_found, dac_found)) {
    Ok(result) -> #(result, cache)
    Error(Nil) -> {
      case node == needle {
        True ->
          case fft_found, dac_found {
            True, True -> #(
              1,
              dict.insert(cache, #(node, fft_found, dac_found), 1),
            )
            _, _ -> #(0, dict.insert(cache, #(node, fft_found, dac_found), 0))
          }
        False -> {
          let #(result, updated_cache) =
            count_paths_for_neighbours(
              matching: needle,
              starting_at: node,
              in: adjacency_list,
              fft_found: fft_found,
              dac_found: dac_found,
              with_memory: cache,
            )

          #(
            result,
            dict.insert(updated_cache, #(node, fft_found, dac_found), result),
          )
        }
      }
    }
  }
}

fn count_paths_for_neighbours(
  matching needle: String,
  starting_at node: String,
  in adjacency_list: Dict(String, List(String)),
  fft_found fft_found: Bool,
  dac_found dac_found: Bool,
  with_memory cache,
) -> #(Int, Dict(#(String, Bool, Bool), Int)) {
  let adjacent = dict.get(adjacency_list, node) |> result.unwrap([])
  let updated_fft_found = fft_found || node == "fft"
  let updated_dac_found = dac_found || node == "dac"

  list.fold(adjacent, #(0, cache), fn(acc, neighbour) {
    let #(current_count, current_cache) = acc
    let #(path_count, updated_cache) =
      count_paths_with_dac_and_fft(
        matching: needle,
        starting_at: neighbour,
        in: adjacency_list,
        fft_found: updated_fft_found,
        dac_found: updated_dac_found,
        with_memory: current_cache,
      )
    #(current_count + path_count, updated_cache)
  })
}
