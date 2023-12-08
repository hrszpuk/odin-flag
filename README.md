<p align="center">
    Odin-flag
</p>

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
