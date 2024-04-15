import gleam/list
import gleam/dict.{type Dict}
import gleam/option.{None, Some}
import gleam/io
import gleam/int
import gleam/float
import gleam/string
import gleam/result

pub fn score(x: Int) -> Int {
  case x {
    1 -> -1
    2 -> 0
    3 -> 0
    4 -> 0
    5 -> 0
    6 -> 1
    7 -> 1
    8 -> 1
    9 -> 1
    10 -> 2
    11 -> 2
    12 -> 2
    _ -> panic as "Invalid input. Must be between 1 and 12."
  }
}

pub fn d(length: Int) -> List(Int) {
  generate_list_loop(1, length, [])
}

fn generate_list_loop(start: Int, end: Int, acc: List(Int)) -> List(Int) {
  case start > end {
    True -> acc
    False -> generate_list_loop(start, end - 1, [end, ..acc])
  }
}

pub fn add_dimension(x: List(Int), y: List(Int)) {
  list.map(x, fn(a) { list.map(y, fn(b) { [a, b] }) })
  |> list.flatten
}

pub fn expand_dimension(x: List(List(Int)), y: List(Int)) {
  list.map(x, fn(a) { list.map(y, fn(b) { list.append(a, [b]) }) })
  |> list.flatten
}

pub fn create_outcome_matrix(dice: List(List(Int))) {
  create_outcome_matrix_loop(dice, [[]])
}

fn create_outcome_matrix_loop(dice: List(List(Int)), acc: List(List(Int))) {
  case dice {
    [] -> acc
    [head, ..tail] ->
      create_outcome_matrix_loop(tail, expand_dimension(acc, head))
  }
}

pub fn fold_individual_rolls(matrix: List(List(Int))) {
  list.map(matrix, fn(a) { list.fold(a, 0, fn(acc, b) { acc + score(b) }) })
}

pub fn count_occurrences(results: List(Int)) {
  list.fold(results, dict.new(), fn(acc, x) {
    dict.update(acc, x, fn(y) {
      case y {
        Some(i) -> i + 1
        None -> 1
      }
    })
  })
}

pub fn to_fixed(n: Int) -> String {
  let integer_part =
    n / 100
    |> int.to_string()

  let decimal_part =
    n % 100
    |> int.to_string()
    |> string.pad_right(2, "0")

  integer_part <> "." <> decimal_part
}

pub fn format_output(stats: Dict(Int, Int)) {
  let total_count =
    dict.fold(stats, 0, fn(acc, _, occurences) { acc + occurences })

  let sorted_rows =
    stats
    |> dict.to_list()
    |> list.sort(fn(a, b) { int.compare(b.0, a.0) })

  let output_rows =
    list.map_fold(sorted_rows, 0, fn(acc, a) {
      let percentage = a.1 * 10_000 / total_count
      let acc = acc + percentage
      #(acc, #(a.0, percentage, acc))
    })

  io.println("score" <> " | percentage | " <> "total")

  list.each(output_rows.1, fn(row) {
    let score =
      row.0
      |> int.to_string()
      |> string.pad_left(3, " ")

    let percentage =
      row.1
      |> to_fixed
      |> string.pad_left(12, " ")

    let total =
      row.2
      |> to_fixed
      |> string.pad_left(12, " ")

    io.println(score <> percentage <> total)
  })
}

pub fn count_results(dice: List(List(Int))) {
  dice
  |> create_outcome_matrix()
  |> fold_individual_rolls()
  |> count_occurrences()
  |> format_output()
}
