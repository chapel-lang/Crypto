# Crypto

A cryptographic library based on 'OpenSSL'.

This module provides a cryptographic library based on
[OpenSSL](https://www.openssl.org/).

## Installation

Add Crypto as a Mason dependency:

```bash
mason add Crypto@0.1.0
```

## Usage

```chapel
use Crypto;

var sha = new Hash(Digest.SHA256);
var buf = new CryptoBuffer(b"Hello, World!");
var digest = sha.getDigest(buf);

writeln(digest.toHexString());
```

## License

See [Mason.toml](Mason.toml).
