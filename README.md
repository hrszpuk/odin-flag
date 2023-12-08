# odin-flag
A simple, easy to use flag system for Odin.

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
