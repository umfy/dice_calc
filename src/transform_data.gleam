import gleam/list
import gleam/option.{None, Some}
import gleam/dict
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
