# Advent of Code 2025

A template with nix flakes and code snippets in multiple languages for getting started with Advent of Code

## Results

Times are recorded with hyperfine on NixOS 25.05 on an AMD 8700GE.
All times are the mean time reported by hyperfine rounded to the nearest whole number.
Peak RAM usage is reported by GNU time and is the max resident set size.
The "Baseline Time" refers to the template runtime on the inputs, but with no parsing or processing.
The "Total Time" is the end-to-end runtime of the solution.
The "Solution Time" is the difference between the baseline and total times and gives a fairer comparison of the just the algorithm runtime between native binaries, VM bytecode and interpreted languages.

| Day (Part) | Language  | Baseline Time | Total Time | Solution Time | Peak RAM (KiB) |
| :--------- | --------- | ------------: | ---------: | ------------: | -------------: |
| 1 (Both)   | 🦀 Rust   |        718 µs |     790 µs |         82 µs |          2,268 |
| 2 (Both)   | ⭐ Gleam  |    125,000 µs | 143,000 µs |     18,000 µs |         77,272 |
| 3 (1)      | ⚡ Zig    |        247 µs |     286 µs |         39 µs |            264 |
| 3 (Both)   | ⚡ Zig    |        251 µs |     460 µs |        209 µs |            264 |
| 4 (1)      | 🐹 Go     |      1,258 µs |   1,627 µs |        369 µs |          2,176 |
| 4 (Both)   | 🐹 Go     |      1,267 µs |   8,619 µs |      7,532 µs |          2,684 |
| 5 (1)      | λ Haskell |      2,178 µs |   6,570 µs |      4,392 µs |          9,564 |
| 5 (Both)   | λ Haskell |      2,205 µs |   6,434 µs |      4,229 µs |          9,576 |
| 6 (1)      | 🐫 OCaml  |      1,009 µs |   3,909 µs |      2,900 µs |          6,396 |
| 6 (Both)   | 🐫 OCaml  |      1,015 µs |   5,384 µs |      4,369 µs |          6,792 |
| 7 (1)      | 🐍 Python |     12,452 µs |  16,901 µs |      4,449 µs |         12,372 |
| 7 (Both)   | 🐍 Python |     12,539 µs |  18,105 µs |      5,566 µs |         12,116 |
| 9 (1)      | ⭐ Gleam  |    114,900 µs | 185,400 µs |     70,500 µs |        122,504 |
| 11 (1)     | ⭐ Gleam  |    115,700 µs | 130,800 µs |     15,100 µs |         75,068 |
| 11 (Both)  | ⭐ Gleam  |    116,000 µs | 130,900 µs |     14,900 µs |         76,748 |

## Usage

1. Copy one of the templates, e.g.:
   ```shell
   cp -r template/ocaml day-01/
   ```
1. Enter the directory and activate the nix shell:
   ```shell
   cd day-01
   nix develop -c fish # Replace `fish` with your shell, e.g. `zsh`
   ```

1. Save the problem input as `input.txt` in the folder

1. All templates have the following Make commands:
   ```shell
   make test
   make run
   make benchmark
   ```
