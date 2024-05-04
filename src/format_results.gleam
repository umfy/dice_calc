import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string
import gleam/io
import transform_data

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

  let #(_, output_rows) =
    list.map_fold(sorted_rows, 0, fn(acc, a) {
      let percentage = a.1 * 10_000 / total_count
      let acc = acc + percentage
      #(acc, #(a.0, percentage, acc))
    })

  list.fold(output_rows, "", fn(result, row) {
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

    result <> score <> percentage <> total <> "\n"
  })
}

pub fn display_results(dice: List(List(Int))) {
  io.println("score" <> " | percentage | " <> "total")

  let occurences = dice
  |> transform_data.create_outcome_matrix()
  |> transform_data.fold_individual_rolls()
  |> transform_data.count_occurrences()
  
  occurences
  |> format_output()
  |> io.println()

  io.print("average:   ")
  occurences
  |> transform_data.count_average()
  |> io.println()

}
