use Crypto;
use IO;
proc main(args: [] string) {
  if args.size == 1 {
    var shasum = shasumStdin();
    writeln(shasum, "  -");
  } else {
    for f in args[1..] {
      var shasum = shasumFile(f);
      writeln(shasum, "  ", f);
    }
  }
}

proc shasumFile(filename: string): string do
  return shasumReader(openReader(filename));
proc shasumStdin(): string do
  return shasumReader(stdin);

proc shasumReader(r: fileReader(?)): string {
  var sha = new Hash(Digest.SHA256);
  var buf: bytes = r.readAll(bytes);
  var bufCrypto = new CryptoBuffer(buf);
  var digest = sha.getDigest(bufCrypto);
  return digest.toHexString();
}
