# odin-flag
An extensive and easy to use command-line flags pacakge for Odin.

```odin
package main

import flag "../.." // Path to pacakge
import "core:fmt"

main :: proc() {
    send_msg := new(bool)
    msg := new(string)

    flag.new(name="send", value=&send_msg, type=bool)
    flag.new(name="msg", value=&msg, type=string)

    flag.parse()

    if send_msg {
        fmt.println(msg)
    }
}
```
