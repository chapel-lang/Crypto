proc main() {
  use Crypto;

  /* Create AES instance with the version required */
  var a = new AES(256, CryptoChainMode.cbc);

  /* Key Generation phase starts */
  var salt = new CryptoBuffer("random_salt");
  var hash = new Hash(Digest.SHA256);
  var k = new KDF(a.getByteSize(), 1000, hash);
  var key = k.passKDF("random_key", salt);
  var keyHex = key.toHex();
  writeln("Generated Key: ", keyHex);
  var expectedKey =
    ["c1", "75", "99", "d8", "24", "84", "cd", "a5", "3f", "23", "a1", "9a",
     "ba", "6c", "05", "0f", "02", "5d", "6c", "6c", "b9", "3d", "c6", "bc",
     "0e", "43", "74", "d3", "6d", "d0", "d0", "2f"];
  assert(&& reduce (keyHex == expectedKey));
  /* Key Generation phase ends */

  /* IV is manipulated to return the same encryption on every run (for testing purposes) */
  var iv = new CryptoBuffer("random_iv_asdfiljhkalsmvncbhdhfu");
  var ivHex = iv.toHex();
  writeln("Generated IV: ", ivHex);
  var expectedIV =
    ["72", "61", "6e", "64", "6f", "6d", "5f", "69", "76", "5f", "61", "73",
     "64", "66", "69", "6c", "6a", "68", "6b", "61", "6c", "73", "6d", "76",
     "6e", "63", "62", "68", "64", "68", "66", "75"];
  assert(&& reduce (ivHex == expectedIV));

  /* The message to be encrypted */
  var msg = new CryptoBuffer("foo_bar");
  var msgHex = msg.toHex();
  writeln("Original Message: ", msgHex);
  var expectedMsg = ["66", "6f", "6f", "5f", "62", "61", "72"];
  assert(&& reduce (msgHex == expectedMsg));

  /* Encrypt the message using the key and IV */
  var ct = a.encrypt(msg, key, iv);
  var ctHex = ct.toHex();
  writeln("Obtained Ciphertext: ", ctHex);
  var expectedCt =
    ["db", "47", "b2", "de", "7e", "4c", "86", "15",
     "4d", "a1", "d3", "59", "c2", "59", "05", "27"];
  assert(&& reduce (ctHex == expectedCt));

  /* Decrypt the message using the key and IV */
  var orig = a.decrypt(ct, key, iv);
  var origHex = orig.toHex();
  writeln("Obtained Plaintext: ", origHex);
  assert(&& reduce (origHex == expectedMsg));
}
