import gleam/list
import gleam/option.{None, Some}
import gleam/dict.{type Dict}
import gleam/int
import gleam/string
import gleam/float
import gleam/result
import dice.{d, score}
import gleam/set

const critical_success = 5

pub fn reroll_ones(dice: List(List(Int))) {
  let copy = list.filter(dice, fn(a) { list.all(a, fn(b) { b != 1 }) })
  list.concat([copy, copy, dice])
}

pub fn expand_outcome(x: List(List(Int)), y: List(Int)) {
  list.map(x, fn(a) { list.map(y, fn(b) { list.append(a, [b]) }) })
  |> list.flatten
}

pub fn create_outcome_matrix(dice: List(List(Int))) {
  dice
  |> create_outcome_matrix_loop([[]])
  // |> reroll_ones()
}

fn create_outcome_matrix_loop(dice: List(List(Int)), acc: List(List(Int))) {
  case dice {
    [] -> acc
    [head, ..tail] ->
      create_outcome_matrix_loop(tail, expand_outcome(acc, head))
  }
}

fn count_success(rolls) {
  let length = list.length(rolls)

  let set_length =
    rolls
    |> set.from_list()
    |> set.size()

  let result = list.fold(rolls, 0, fn(acc, b) { acc + score(b) })

  case set_length == 1 && result > 0 || result > length {
    True -> critical_success
    _ -> result
  }
}

pub fn fold_individual_rolls(matrix: List(List(Int))) {
  list.map(matrix, fn(a) {
    let count_failures =
      list.fold(a, 0, fn(acc, b) {
        case b {
          1 -> acc + 1
          _ -> acc
        }
      })

    case count_failures {
      0 -> count_success(a)
      1 -> -1
      _ -> -2
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
