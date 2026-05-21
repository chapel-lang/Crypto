proc main() {
  use Crypto;

  var SHA = new StreamingHash(Digest.SHA1);
  var SHA2 = new StreamingHash(Digest.SHA256);
  var s1 = b"The quick brown fox ",
      s2 = b"jumps over the lazy dog";
  writeln(s1, s2);


  var buf1 = new LocalBorrowedCryptoBuffer(s1),
      buf2 = new LocalBorrowedCryptoBuffer(s2);
  SHA.update(buf1);
  SHA.update(buf2);
  var digest = SHA.finish();
  var sha1Hex = digest.toHex();
  writeln(SHA.getDigestName() , " = " , sha1Hex);
  var expectedSHA1 =
    ["2f", "d4", "e1", "c6", "7a", "2d", "28", "fc", "ed", "84",
     "9e", "e1", "bb", "76", "e7", "39", "1b", "93", "eb", "12"];
  assert(&& reduce (sha1Hex == expectedSHA1));


  SHA.reset();
  SHA.update(buf1);
  SHA.update(buf2);
  digest = SHA.finish();
  var sha1Hex2 = digest.toHex();
  writeln(SHA.getDigestName() , " = " , sha1Hex2);
  assert(&& reduce (sha1Hex2 == expectedSHA1));


  SHA2.update(buf1);
  SHA2.update(buf2);
  digest = SHA2.finish();
  var sha256Hex = digest.toHex();
  writeln(SHA2.getDigestName() , " = " , sha256Hex);
  var expectedSHA256 =
    ["d7", "a8", "fb", "b3", "07", "d7", "80", "94", "69", "ca", "9a", "bc",
     "b0", "08", "2e", "4f", "8d", "56", "51", "e4", "6d", "3c", "db", "76",
     "2d", "02", "d0", "bf", "37", "c9", "e5", "92"];
  assert(&& reduce (sha256Hex == expectedSHA256));
}
