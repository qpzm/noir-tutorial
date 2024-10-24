use dep::std;

fn has_ship(coord: Field, ship_coords: [Field; 25]) -> u32 {
  let mut collisions = 0;
  for i in 0..25 {
    collisions = collisions + (ship_coords[i] == coord) as u32;
  }
  collisions
}

// Input:
// lengths: [u4; 5] - Lengths of the 5 ships
fn check_for_collision(lengths: [u4; 5], ships: [Field; 15]) {
  let mut collisions = 0;
  // Array is initialized to length 25 because array indices in Noir are currently restricted
  // to compile time values. Length 25 ensures index never exceeds array bounds. (index max (i * 5 + j) is 24 because 0 <= i, j < 5)
  // The board is 10x10 matrix, so 100 is an arbitrary value that is not a valid ship coordinate.
  let mut ship_coords: [Field; 25] = [100; 25];

  for i in 0..5 {
    for j in 0..5 {
      // check (0, 1), (0, 2), (0, 3), (0, 4), (1, 2), (1, 3), ... , (3, 4)
      if (lengths[i] > j as u4) {
        collisions = collisions + has_ship(coord, ship_coords);
        ship_coords[index] = coord;
      }
    }
  }
  constrain collisions == 0;
}

// z { u4 } - Orientation of ship (horizontal or vertical)
fn check_ship_ranges(length: u4, x: u4, y: u4, z: u4) {
  // Constrain z to binary
  constrain z <= 1;

  if z == 1 {
    constrain y + length <= 10;
    constrain x < 10;
  } else {
    constrain x + length <= 10;
    constrain y < 10;
  }
}

// At the time of writing this tutorial, multi-dimensional array was not supported.
// Now, multi-dimensional array is supported. https://noir-lang.org/docs/noir/concepts/data_types/arrays
// It had better replace with 2D array of lengths [5][3]
fn main(hash: pub Field, ships: [Field; 15]) {
  // Lengths of the 5 ships
  let length: [u4; 5] = [5, 4, 3, 3, 2];
  for i in 0..5 {
    check_ship_ranges(lengths[i], ships[i*3] as u4, ships[i*3 + 1] as u4, ships[i*3 + 2] as u4);
  }
  check_for_collision(length, ships);
  let computed_hash = std::hash::pedersen(ships);
  constrain hash == computed_hash[0];
}
