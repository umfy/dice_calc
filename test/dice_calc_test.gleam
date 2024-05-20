import gleeunit
import gleeunit/should
import gleam/dict
import transform_data
import format_results

pub fn main() {
  gleeunit.main()
}

pub fn expand_outcome_test() {
  transform_data.expand_outcome([[1], [2]], [1, 2])
  |> should.equal([[1, 1], [1, 2], [2, 1], [2, 2]])
}

pub fn create_outcome_matrix_test() {
  transform_data.create_outcome_matrix([[1, 2, 3], [1, 2], [3]])
  |> should.equal([
    [1, 1, 3],
    [1, 2, 3],
    [2, 1, 3],
    [2, 2, 3],
    [3, 1, 3],
    [3, 2, 3],
  ])
}

pub fn fold_individual_rolls_test() {
  transform_data.fold_individual_rolls([[1, 2], [2, 4], [10, 6]])
  |> should.equal([-100, 0, 10])
}

pub fn count_occurrences_test() {
  transform_data.count_occurrences([
    -2, -1, -1, -1, -1, 0, -1, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0,
    1, -1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 2,
  ])
  |> should.equal(
    dict.from_list([#(-2, 1), #(-1, 8), #(0, 18), #(1, 8), #(2, 1)]),
  )
}

pub fn to_fixed_test() {
  format_results.to_fixed(1090)
  |> should.equal("10.90")

  format_results.to_fixed(987)
  |> should.equal("9.87")
}

pub fn count_average_test() {
  let scores = dict.from_list([#(-1, 1), #(0, 4), #(1, 4), #(2, 3)])
  transform_data.count_average(scores)
  |> should.equal("0.75")
}

pub fn count_natural_average_test() {
  let scores = dict.from_list([#(-1, 1), #(0, 4), #(1, 4), #(2, 1)])
  transform_data.count_natural_average(scores)
  |> should.equal("0.6")
}

pub fn adv_test() {
  transform_data.adv(3)
  |> should.equal([1, 2, 3, 2, 2, 3, 3, 3, 3])
}

pub fn dis_test() {
  transform_data.dis(3)
  |> should.equal([1, 1, 1, 1, 2, 2, 1, 2, 3])
}
