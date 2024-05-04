import gleam/list
import gleam/option.{None, Some}
import gleam/dict.{type Dict}
import gleam/int
import gleam/float
import gleam/result
import dice.{score}

pub fn expand_outcome(x: List(List(Int)), y: List(Int)) {
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
      create_outcome_matrix_loop(tail, expand_outcome(acc, head))
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

pub fn count_average(stats: Dict(Int, Int)) {
  let total_count =
    dict.fold(stats, 0, fn(acc, _, occurences) { acc + occurences })

  let rows =
    stats
    |> dict.to_list()

  let sum = list.fold(rows, 0, fn(result, row) { result + row.0 * row.1 })
  int.to_float(sum) /. int.to_float(total_count)

  sum
  |> int.to_float
  |> float.divide(int.to_float(total_count))
  |> result.unwrap(-999.0)
  |> float.to_string
}
