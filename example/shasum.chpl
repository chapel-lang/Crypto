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

const BUF_SIZE = 1024;

proc shasumFile(filename: string): string do
  return shasumReader(openReader(filename));
proc shasumStdin(): string do
  return shasumReader(stdin);

proc shasumReader(r: fileReader(?)): string {
  var sha = new StreamingHash(Digest.SHA256);
  var buf: bytes;
  while r.readBytes(buf, BUF_SIZE) {
    var bufCrypto = new LocalBorrowedCryptoBuffer(buf);
    sha.update(bufCrypto);
  }
  var digest = sha.finish();
  return digest.toHexString();
}
