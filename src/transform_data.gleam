import gleam/list
import gleam/option.{None, Some}
import gleam/dict.{type Dict}
import gleam/int
import gleam/string
import gleam/float
import gleam/result
import dice.{d, score}
import gleam/set

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
  list.map(matrix, fn(a) {
    let set_length =
      a
      |> set.from_list()
      |> set.size()

    let length = list.length(a)

    let result = list.fold(a, 0, fn(acc, b) { acc + score(b) })

    case set_length == 1 && result > 0 {
      True -> 10
      False ->
        case result > length {
          True -> 10
          _ -> result
        }
    }
  })
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

pub fn adv(length: Int) -> List(Int) {
  let combinations = create_outcome_matrix([d(length), d(length)])
  combinations
  |> list.map(fn(a) { list.fold(a, 0, fn(acc, b) { int.max(acc, b) }) })
}

pub fn dis(length: Int) -> List(Int) {
  let combinations = create_outcome_matrix([d(length), d(length)])
  combinations
  |> list.map(fn(a) {
    list.fold(a, 0, fn(acc, b) {
      case acc {
        0 -> b
        _ -> int.min(acc, b)
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

  sum
  |> int.to_float
  |> float.divide(int.to_float(total_count))
  |> result.unwrap(-999.0)
  |> float.to_string
  |> string.slice(0, 4)
}

pub fn count_natural_average(stats: Dict(Int, Int)) {
  let total_count =
    dict.fold(stats, 0, fn(acc, _, occurences) { acc + occurences })

  let rows =
    stats
    |> dict.to_list()

  let sum =
    list.fold(rows, 0, fn(result, row) { result + int.max(row.0 * row.1, 0) })

  sum
  |> int.to_float
  |> float.divide(int.to_float(total_count))
  |> result.unwrap(-999.0)
  |> float.to_string
  |> string.slice(0, 4)
}
