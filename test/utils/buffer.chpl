proc main() {
  use Crypto;

  /* String to buffer */
  var b = new unmanaged CryptoBuffer("foobar");
  var bHex = b.toHex();
  writeln(bHex);
  assert(&& reduce (bHex == ["66", "6f", "6f", "62", "61", "72"]));
  var bHexStr = b.toHexString();
  writeln(bHexStr);
  assert(bHexStr == "666f6f626172");
  writeln(b.getBuffData());
  assert(&& reduce (b.getBuffData() == [102, 111, 111, 98, 97, 114]));
  writeln(b.getBuffSize());
  assert(b.getBuffSize() == 6);

  delete b;

  /* Array to buffer */
  var arr: [0..4] uint(8) = [1: uint(8), 2: uint(8), 3: uint(8), 4: uint(8), 5: uint(8)];
  var c = new unmanaged CryptoBuffer(arr);
  var cHex = c.toHex();
  writeln(cHex);
  assert(&& reduce (cHex == ["01", "02", "03", "04", "05"]));
  var cHexStr = c.toHexString();
  writeln(cHexStr);
  assert(cHexStr == "0102030405");
  writeln(c.getBuffData());
  assert(&& reduce (c.getBuffData() == [1, 2, 3, 4, 5]));
  writeln(c.getBuffSize());
  assert(c.getBuffSize() == 5);

  delete c;
}
