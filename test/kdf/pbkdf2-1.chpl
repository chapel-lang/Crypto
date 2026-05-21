proc main() {
  use Crypto;

  var hash = new Hash(Digest.SHA256);
  var k = new KDF(32, 1000, hash);
  var buf = new CryptoBuffer("random_salt");
  var key = k.passKDF("random_key", buf);
  var res = key.toHex();
  writeln("Generated Key: ", res);
  var expected =
    ["c1", "75", "99", "d8", "24", "84", "cd", "a5", "3f", "23", "a1", "9a",
     "ba", "6c", "05", "0f", "02", "5d", "6c", "6c", "b9", "3d", "c6", "bc",
     "0e", "43", "74", "d3", "6d", "d0", "d0", "2f"];
  assert(&& reduce (res == expected));
}
