package main

import "core:fmt"
import "core:os"
import flag ".."

main :: proc() {
    using flag

    count := 0
    new_flag("count", &count, int)

    parse_flags()
    fmt.println(count)
}