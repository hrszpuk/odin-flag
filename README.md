<h1 align="center">
    Odin-flag
</h1>

<p align="center">
    An extenible flag parsing library for Odin.
</p>

<p align="center">
<a href="./LICENSE.md"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
<a href="https://github.com/hrszpuk"><img src="https://img.shields.io/github/followers/hrszpuk?style=social"></a>
<a href="https://github.com/hrszpuk/odin-flag/issues"><img src="https://img.shields.io/github/issues/hrszpuk/odin-flag"></a>
</p>

<p align="center">
    <a href="https://github.com/hrszpuk/odin-flag#Installation">Installation</a>&nbsp;&nbsp;&nbsp;
    <a href="https://github.com/hrszpuk/odin-flag/blob/main/USER_GUIDE.md">User Guide</a>&nbsp;&nbsp;&nbsp;
    <a href="https://github.com/hrszpuk/odin-flag#Contributing">Contributing</a>&nbsp;&nbsp;&nbsp;
</p>

<hr />

```odin
package main

import "core:fmt"
import flag "../.." // path to package

main :: proc() {
    using flag

    flags := flagset()

    count := 1
    send := false
    msg: string

    flags->add("count", &count, int)
    flags->add("send", &send, bool)
    flags->add("msg", &msg, string)

    flags->parse()
    
    if send {
        for _ in 0..<count {
            fmt.println(msg)
        }
    }

    flags->free()
}
```

## Installation
The recommended way to install odin-flag is to use git submodules.

In your project, create a directory called "external" (or alternative name) and run the command below.
```
git submodule add https://github.com/hrszpuk/odin-flag external/odin-flag
```
From your project directory you can access the library like in the code below.
```odin
package main

import flag "../external/odin-flag"

main :: proc() {
    using flag

    flag := flagset()

    // ...

    flag->free()
}
```
NOTE: the path to odin-flag may be different depending on where odin-flag is installed and where you are trying to access odin-flag from.

## Contributing
