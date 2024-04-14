import gleeunit
import gleeunit/should
import gleam/dict
import loops

pub fn main() {
  gleeunit.main()
}

pub fn add_dimension_test() {
  loops.add_dimension([1, 2, 3, 4], [1, 2, 3, 4])
  |> should.equal([
    [1, 1],
    [1, 2],
    [1, 3],
    [1, 4],
    [2, 1],
    [2, 2],
    [2, 3],
    [2, 4],
    [3, 1],
    [3, 2],
    [3, 3],
    [3, 4],
    [4, 1],
    [4, 2],
    [4, 3],
    [4, 4],
  ])
}

pub fn expand_dimension_test() {
  loops.expand_dimension([[1], [2]], [1, 2])
  |> should.equal([[1, 1], [1, 2], [2, 1], [2, 2]])
}

pub fn create_outcome_matrix_test() {
  loops.create_outcome_matrix([[1, 2, 3], [1, 2], [3]])
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
  loops.fold_individual_rolls([[1, 2], [2, 4], [10, 6]])
  |> should.equal([-1, 0, 3])
}

pub fn count_occurrences_test() {
  loops.count_occurrences([
    -2, -1, -1, -1, -1, 0, -1, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0,
    1, -1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 2,
  ])
  |> should.equal(
    dict.from_list([#(-2, 1), #(-1, 8), #(0, 18), #(1, 8), #(2, 1)]),
  )
}
