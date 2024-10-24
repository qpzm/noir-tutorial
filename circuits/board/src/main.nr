use dep::std;

fn has_ship(coord: Field, ship_coords: [Field; 25]) -> u32 {
  let mut collisions = 0;
  for i in 0..25 {
    collisions = collisions + (ship_coords[i] == coord) as u32;
  }
  collisions
}

// Input:
// lengths: [u8; 5] - Lengths of the 5 ships
fn check_for_collision(lengths: [u8; 5], ships: [Field; 15]) {
  let mut collisions = 0;
  // Array is initialized to length 25 because array indices in Noir are currently restricted
  // to compile time values. Length 25 ensures index never exceeds array bounds. (index max (i * 5 + j) is 24 because 0 <= i, j < 5)
  // The board is 10x10 matrix, so 100 is an arbitrary value that is not a valid ship coordinate.
  let mut ship_coords: [Field; 25] = [100; 25];

  for i in 0..5 {
    for j in 0..5 {
      // check (0, 1), (0, 2), (0, 3), (0, 4), (1, 2), (1, 3), ... , (3, 4)
      if (lengths[i] > j as u8) {
        let mut coord = 0;
        let index = i * 5 + j;
        if ships[i*3+2] == 1 { // vertical
          coord = ships[i*3] + (ships[i*3+1] + j as Field) * 10;
        } else { // horizontal
          coord = ships[i*3] + (j as Field) + ships[i*3+1] * 10;
        }
        collisions = collisions + has_ship(coord, ship_coords);
        ship_coords[index] = coord;
      }
    }
  }
  assert(collisions == 0);
}

// z { u8 } - Orientation of ship (horizontal or vertical)
fn check_ship_ranges(length: u8, x: u8, y: u8, z: u8) {
  // Constrain z to binary
  assert(z <= 1);

  if z == 1 {
    assert(y + length <= 10);
    assert(x < 10);
  } else {
    assert(x + length <= 10);
    assert(y < 10);
  }
}

// At the time of writing this tutorial, multi-dimensional array was not supported.
// Now, multi-dimensional array is supported. https://noir-lang.org/docs/noir/concepts/data_types/arrays
// It had better replace with 2D array of lengths [5][3]
fn main(hash: pub Field, ships: [Field; 15]) {
  // Lengths of the 5 ships
  let lengths: [u8; 5] = [5, 4, 3, 3, 2];
  for i in 0..5 {
    check_ship_ranges(lengths[i], ships[i*3] as u8, ships[i*3 + 1] as u8, ships[i*3 + 2] as u8);
  }
  check_for_collision(lengths, ships);
  let computed_hash = std::hash::pedersen_hash(ships);
  assert(hash == computed_hash);
}

#[test]
fn test_check_for_collision() {
  let lengths: [u8; 5] = [5, 4, 3, 3, 2];
  let ships: [Field; 15] = [
    0, 4, 1, // Carrier (length 5): starts at (0,4), vertical
    4, 3, 0, // Battleship (length 4): starts at (4,3), horizontal
    3, 5, 0, // Cruiser (length 3): starts at (3,5), horizontal
    1, 1, 0, // Submarine (length 3): starts at (1,1), horizontal
    6, 7, 0  // Destroyer (length 2): starts at (6,7), horizontal
  ];
  check_for_collision(lengths, ships);
}

#[test(should_fail)]
fn test_check_ship_ranges_with_negative_x() {
  check_ship_ranges(-1, 4, 3, 0);
}

#[test]
fn test_check_ship_ranges() {
  check_ship_ranges(5, 0, 4, 1);
}
