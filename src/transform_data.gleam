import gleam/list
import gleam/option.{None, Some}
import gleam/dict.{type Dict}
import gleam/int
import gleam/string
import gleam/float
import gleam/result
import dice.{d, score}

const critical_success = 5

pub fn reroll_ones(dice: List(List(Int))) {
  let copy = list.filter(dice, fn(a) { list.all(a, fn(b) { b != 1 }) })
  list.concat([copy, copy, dice])
}

pub fn keep_extreme_of_first_x(
  dice: List(List(Int)),
  index: Int,
  comparator: fn(Int, Int) -> Int,
) {
  list.map(dice, fn(a) {
    let tup = list.split(a, index)

    let extreme =
      list.fold(tup.0, 0, fn(acc, b) {
        case acc {
          0 -> b
          _ -> comparator(acc, b)
        }
      })
    list.concat([[extreme], tup.1])
  })
}

pub fn expand_outcome(x: List(List(Int)), y: List(Int)) {
  list.map(x, fn(a) { list.map(y, fn(b) { list.append(a, [b]) }) })
  |> list.flatten
}

pub fn create_outcome_matrix(dice: List(List(Int))) {
  dice
  |> create_outcome_matrix_loop([[]])
  // |> reroll_ones()
  // |> keep_extreme_of_first_x(2, int.min)
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

  let result = list.fold(rolls, 0, fn(acc, b) { acc + score(b) })

  case result > length {
    True -> critical_success
    _ -> result
  }
}

pub fn is_critical_failure(a: List(Int)) {
  // all the same value 11, 22 / 111, 222, 333
  // let length = list.length(a)
  let first = list.first(a)
  case first {
    Ok(head) -> head <= 3 && list.all(a, fn(b) { b == head })
    Error(Nil) -> False
  }
}

// pub fn is_critical_failure(a: List(Int)) {
//   let length = list.length(a)
//   list.all(a, fn(b) { b <= length })
// }

pub fn fold_individual_rolls(matrix: List(List(Int))) {
  list.map(matrix, fn(a) {
    case is_critical_failure(a) {
      False -> count_success(a)
      True -> -1
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
