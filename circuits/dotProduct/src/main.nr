fn main(x: [Field; 2], y: [Field; 2], solution: Field) {
  let out = dotProduct(x, y);
  assert (out == solution);
}

fn dotProduct(x: [Field; 2], y: [Field; 2]) -> Field {
  let mut out = 0;
  for i in 0..2 {
    out += x[i] * y[i];
  }

  out
}

#[test]
fn test_main() {
  main([1, 2], [3, 4], 11);
}
