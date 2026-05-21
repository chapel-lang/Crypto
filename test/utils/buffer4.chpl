proc main() {
  use Crypto;
  var x: [0..10] uint(8);
  var a = new unmanaged CryptoBuffer(x);
  var res = a.toHex();
  writeln(res); // prints 0 due to uninitialized values
  assert(&& reduce (res == "00"));
  delete a;
}
