use dep::std;

// Input:
// shot: { [Field; 2] } - x, y coordinates of a shot
fn check_for_hit(lengths: [u8; 5], ships: [Field; 15], shot: [Field; 2]) -> bool {
  let shot_coord = shot[0] + shot[1] * 10;
  let mut hits = 0;
  for i in 0..5 {
    for j in 0..5 {
      if(lengths[i] > j as u8) {
        let mut coord = 0;
        if ships[i*3+2] == 1 { // vertical
          // e.g. length = 2, ship coodrdinates: [19, 29, 39]
          coord = ships[i*3] + (ships[i*3+1] + j as Field) * 10;
        } else { // horizontal
          // e.g. length = 2, ship coodrdinates: [15, 16, 17]
          coord = ships[i*3] + j as Field + ships[i*3+1] * 10;
        }
        hits = hits + (coord == shot_coord) as u1;
      }
    }
  }
  hits > 0
}

fn main(hash: pub Field, hit: pub u1, ships: [Field; 15], shot: pub [Field; 2]) {
  let lengths: [u8; 5] = [5, 4, 3, 3, 2];
  assert(shot[0] as u8 < 10);
  assert(shot[1] as u8 < 10);

  let computed_hash = std::hash::pedersen_hash(ships);
  assert(hash == computed_hash);

  let hits = check_for_hit(lengths, ships, shot);
  assert(hits as u1 == hit);
}

#[test]
fn test_check_for_hit() {
  // Board representation:
  // . . . . . . . . . .
  // . x x x x x . . . .
  // . . . . . . . . . .
  // . . . . x x x x . .
  // x . . . . . . . . .
  // x . . x x x . . . .
  // x . . . . . . . . .
  // x . . . . . x x . .
  // x . . . . . . . . .
  // . . . . . . . . . .
  let lengths: [u8; 5] = [5, 4, 3, 3, 2];
  let ships: [Field; 15] = [
    0, 4, 1, // Carrier (length 5): starts at (0,4), vertical
    4, 3, 0, // Battleship (length 4): starts at (4,3), horizontal
    3, 5, 0, // Cruiser (length 3): starts at (3,5), horizontal
    1, 1, 0, // Submarine (length 3): starts at (1,1), horizontal
    6, 7, 0  // Destroyer (length 2): starts at (6,7), horizontal
  ];
  let shot: [Field; 2] = [1, 1];
  assert(check_for_hit(lengths, ships, shot) == true);
}
