---
title: Logging Function Names in Go
tags: golang, programming
description: How do you log a message along with its location in the Go source code?
---
[TLDR](http://www.reddit.com/r/golang/comments/2af8ri/logging_function_names_in_go/ciwzn90): `runtime.Caller()`, `runtime.FuncForPC()`

It's often useful to see the name of the function emitting log messages. I frequently found myself manually inserting the function name into `log` calls:

```go
func login() {
	log.Println("login(): called")
    err := doSomething()
    if err != nil {
    	log.Println("login(): ERROR: doSomething failed")
    }
    /* ... */
}
```

Go 1.3 provides flags to emit file names and line numbers in the standard `log` package, but these data are subject to frequent change and are therefore not as valuable. For example, in a 400-line source file, a line number alone might not have enough context for fast debugging. Fortunately, Go's `runtime` package has great introspective tools that can be used to reveal the calling function's name.

```go
package main

import (
	"log"
	"path/filepath"
	"runtime"
	"strings"
)

var (
	LogE = log.New(LogWriter{}, "ERROR: ", 0)
	LogW = log.New(LogWriter{}, "WARN: ", 0)
	LogI = log.New(LogWriter{}, "INFO: ", 0)
)

type LogWriter struct{}

func (f LogWriter) Write(p []byte) (n int, err error) {
	pc, file, line, ok := runtime.Caller(4)
	if !ok {
		file = "?"
		line = 0
	}

	fn := runtime.FuncForPC(pc)
	var fnName string
	if fn == nil {
		fnName = "?()"
	} else {
		dotName := filepath.Ext(fn.Name())
		fnName = strings.TrimLeft(dotName, ".") + "()"
	}

	log.Printf("%s:%d %s: %s", filepath.Base(file), line, fnName, p)
	return len(p), nil
}

func infoFunc() {
	LogI.Println("information message")
}

func warnFunc() {
	LogW.Println("warning message")
}

func errorFunc() {
	LogE.Println("error message")
}

func main() {
	infoFunc()
	warnFunc()
	errorFunc()
}

```

Output:
```
2009/11/10 23:00:00 prog.go:39 infoFunc(): INFO: information message
2009/11/10 23:00:00 prog.go:43 warnFunc(): WARN: warning message
2009/11/10 23:00:00 prog.go:47 errorFunc(): ERROR: error message
```

See for yourself: http://play.golang.org/p/uSNxYUAXHD

Because the code simply fits a `log.Logger` with a custom `io.Writer`, all of the `log` package APIs are available for use (e.g. Print, Println, Printf, etc).

Also available as a package (you might want to hold off using it until there's at least a readme and some tests):
https://github.com/wyc/funclog

```go

package main

import "github.com/wyc/funclog"

func main() {
        LogI := funclog.New("INFO: ")
        LogI.Println("informative message")
        c := make(chan bool)
        go func() {
        	LogI.Println("other informative message")
            c <- true
        }
        <-c /* wait for the goroutine */
}
```

Future work involves accepting a custom writer (maybe not using `log.Printf` as a crutch). Currently, `log.SetOutput` will direct the output of `funclog`.

It's also possible to log live callstacks (using ASCII nesting) by using the tools in `runtime/pprof`.
