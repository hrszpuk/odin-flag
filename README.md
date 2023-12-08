# odin-flag
A simple, easy to use flag system for Odin.

```odin
package main

import "core:fmt"
import flag "../.." // path to package

main :: proc() {

    flags := FlagSet()

    // Create new flags
    send_msg := flags.new(bool, "send")  // --send 
    msg := flags.new(string, "msg")      // --msg

   flags.parse_flags() 

    if send_msg^ {
        fmt.println(msg)
    }
}
```
