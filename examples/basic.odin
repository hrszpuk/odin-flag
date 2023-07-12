package main

import "core:fmt"
import "core:os"
import flag ".."

main :: proc() {
    using flag

    count := 0
    new_flag("count", &count, int)

    toggle := false 
    new_flag("toggle", &toggle, bool)

    msg := ""
    new_flag("msg", &msg, string)

    pi : f64 = 0.0
    new_flag("pi", &pi, f64)

    parse_flags()
    fmt.println("OUTPUT: ", count, toggle, msg, pi)

    free_global_flags()
}