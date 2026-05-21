config const doTest = false;
proc getEnvs(envs: [] string, toForward: [] string) {
  use List, OS.POSIX;
  var result = new list(envs);
  for e in toForward {
    var v = getenv(e.c_str());
    if v != nil {
      result.pushBack(e + "=" + string.createCopyingBuffer(v));
    }
  }
  return result.toArray();
}
proc string.stripSuffix(suffix: string): string do
  if this.endsWith(suffix)
    then return this[0..#(this.size - suffix.size)];
    else return this;
proc runCheck(args, expectedOutput: string) {
  use IO, Subprocess, Regex;
  var f = openMemFile();
  var w = f.writer();
  // TODO: all output must be to stderr until issue is resolved
  //  https://github.com/chapel-lang/chapel/issues/15497
  const execname = args[0].stripSuffix("_real");
  var p = spawn([execname, "-nl1", "--doTest=true"],
      stdout=pipeStyle.pipe, stderr=pipeStyle.pipe,
      // stdout=pipeStyle.pipe, stderr=pipeStyle.stdout);
      env=getEnvs(["CHPL_RT_UNWIND=0"],
                  ["GASNET_SPAWNFN", "GASNET_ROUTE_OUTPUT",
                    "GASNET_QUIET", "GASNET_MASTERIP",
                    "GASNET_WORKERIP", "CHPL_RT_OVERSUBSCRIBED"]));
  p.wait();
  var stdout, stderr: string;
  p.stdout.readAll(stdout);
  p.stderr.readAll(stderr);
  w.write(stdout);
  w.write(stderr);
  w.close();

  var actualOutput = f.reader().readAll(string);
  var pathRegex = new regex("[^ ]+\\.chpl:[0-9]+: ");
  actualOutput = actualOutput.replace(pathRegex, "");

  writeln("Actual Output");
  writeln("="*80);
  writeln(actualOutput);
  writeln("Expected Output");
  writeln("="*80);
  writeln(expectedOutput);

  assert(actualOutput == expectedOutput);
}

proc test() {
  use Crypto;
  var a = new unmanaged CryptoBuffer(""); // doesn't do anything
  writeln(a.toHex());
  delete a;
}

proc main(args: [] string) {
  if doTest then
    test();
  else
    runCheck(args, "error: halt reached - Enter a string with length greater " +
                   "than 0 in order to create a buffer\n");
}
