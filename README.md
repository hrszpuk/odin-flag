# odin-flag
An extensive and easy to use command-line flags pacakge for Odin.

```odin
package main

import "core:fmt"
import flag "../.." // path to package

main :: proc() {
    using flag
    send_msg := new(bool)
    msg := new(string)

    init_global_flags()
    defer free_global_flags()
    
    new_flag(name="send", value=send_msg, type=bool)
    new_flag(name="msg", value=msg, type=string)

    parse_flags()

    if send_msg^ {
        fmt.println(msg)
    }
}
```

## Development

#### Iteration 1

Goals:
- Basic global flags
- Supported types: bool, string, int, float

#### Iteration 2

Goals:
- Subcommand support: `./exe --globalflag subcommand --flag`
- ^ done through flagSet type (a set of flags)

#### Iteration 3

Goals: 
- Move global flag type to a subcommand (flagSet) type
- Allow global flags *after* a subcommand (unlike Go)
