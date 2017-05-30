---
title: A Simple Network Client in Rust
tags: rust, programming
description: Rust source code for a simple network client that does I/O for the weather.
---
Below is the source code for a network client in Rust 0.12.0. Inspired by Graham King's [blog post](http://www.darkcoding.net/software/rust-what-i-learnt-so-far/#connect_to_a_socket), this program retrieves the weather conditions for a region specified by an ID code. The remainder of this article will explain portions of the code in detail.

#### [weather.rs](https://github.com/wyc/snippets/blob/master/rust/weather.rs):
```rust
/**
 * rust network client example updated from
 * http://www.darkcoding.net/software/rust-what-i-learnt-so-far/#connect_to_a_socket
 *
 * rust 0.12.0
 */

extern crate std;

use std::io::{TcpStream, IoResult};
use std::str;

fn fetch(code: &str) -> IoResult<Vec<u8>> {
    let mut stream = TcpStream::connect("205.156.51.232", 80);
    let data_get = format!(
        "GET /pub/data/observations/metar/decoded/{}.TXT HTTP/1.1\n",
        code);
    let data_headers = "Host: weather.noaa.gov\n\n";

    /* we can use try!() here, but for this example we won't use macros */
    match stream.write(data_get.as_bytes()) {
        Ok(_) => (),
        Err(err) => return Err(err)
    }
    match stream.write(data_headers.as_bytes()) {
        Ok(_) => (),
        Err(err) => return Err(err)
    }
    let rv = stream.read_to_end();

    /* just to show how to explicitly close the connection.
     * drop() is called anyway when a variable goes out of scope. */
    drop(stream);

    return rv;
}

fn main() {
    match fetch("KEWR") {
        Ok(v) => println!("{}", match str::from_utf8(v.as_slice()){
            Some(s) => s,
            None => ""
        }),
        Err(err) => println!("error: {}", err)
    }
}
```

#### The Function Header:

```
fn fetch(code: &str) -> IoResult<Vec<u8>> {
```

This function is called `fetch`, and it takes a string parameter named `code` with type of `&str`. `&str` is essentially a `&[u8]` ([slice](http://doc.rust-lang.org/master/std/slice/) of bytes) with the [guarantee that the bytes are valid UTF-8](http://doc.rust-lang.org/std/str/#representation). `fetch` returns an [`IoResult<Vec<u8>>`](http://doc.rust-lang.org/std/io/type.IoResult.html), which can be matched into an  either a [`Vec<u8>`](http://doc.rust-lang.org/master/std/vec/struct.Vec.html) or [`IoError`](http://doc.rust-lang.org/std/io/struct.IoError.html). This value is matched against in `main` to determine between outputting the fetched data or an error message.

#### Using `TcpStream.write()`:

```
    match stream.write(data_get.as_bytes()) {
        Ok(_) => (),
        Err(err) => return Err(err)
    }
```

The call to [`stream.write()`](http://doc.rust-lang.org/std/io/net/tcp/struct.TcpStream.html#method.write) takes a slice of bytes. A byte slice conveniently holds its own length, so it's not necessary to specify the number of bytes to write. `data_get` is an immutable String (this type is inferred by the `let` statement), and the method [`as_bytes()`](http://doc.rust-lang.org/master/std/string/struct.String.html#method.as_bytes) is called on it, returning an immutable byte slice.

Because `stream.write()` returns an `IoResult`, it must be matched against to check for errors. Early termination via `return` occurs if there was an error.

#### Using `TcpStream.read_to_end()`:

```
    let rv = stream.read_to_end();
```

[`stream.read_to_end()`](http://doc.rust-lang.org/std/io/net/tcp/struct.TcpStream.html#method.read_to_end)
is called, `rv` is assigned a return value of type `IoResult<Vec<u8>>`. This is the correct return type for the function, and the memory for the `Vec<u8>` will be allocated at the behest of the library call. `read_to_end()` is defined in [`rust/src/libstd/io/mod.rs`](https://github.com/rust-lang/rust/blob/dd348b3ab0147fda3dedbdc6947c14354971e14a/src/libstd/io/mod.rs#L686-L686):

```
/// Reads all remaining bytes from the stream.
///
/// # Error
///
/// Returns any non-EOF error immediately. Previously read bytes are
/// discarded when an error is returned.
///
/// When EOF is encountered, all bytes read up to that point are returned.
fn read_to_end(&mut self) -> IoResult<Vec<u8>> {
    let mut buf = Vec::with_capacity(DEFAULT_BUF_SIZE);
    loop {
        match self.push_at_least(1, DEFAULT_BUF_SIZE, &mut buf) {
            Ok(_) => {}
            Err(ref e) if e.kind == EndOfFile => break,
            Err(e) => return Err(e)
        }
    }
    return Ok(buf);
}


```
---
Thanks for reading.

#### Special thanks to:

[__dbaupp__](http://www.reddit.com/r/rust/comments/2ajpvy/a_simple_network_client_in_rust/civwlmv) for pointing out that `IoError` can be directly printed and mentioning the [`try!()`](http://doc.rust-lang.org/master/std/result/#the-try!-macro) macro. I've decided to keep pattern matching to reveal details about handling `IoResult`.

[__zokier__](https://news.ycombinator.com/reply?id=8048088) for pointing out an incorrect assumption. I assumed that `read_to_end()` would only read `DEFAULT_BUF_SIZE` at most, but this was wrong.
