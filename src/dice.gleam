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
  generate_dice_output_loop(1, length, [])
}

fn generate_dice_output_loop(start: Int, end: Int, acc: List(Int)) -> List(Int) {
  case start > end {
    True -> acc
    False -> generate_dice_output_loop(start, end - 1, [end, ..acc])
  }
}
