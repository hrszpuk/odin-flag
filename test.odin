package flag

import "core:fmt"

main :: proc() {
    flags := new_flagset()

    x := 100
    add_flag(&flags, "x", &x)

    fmt.println(flags)

    fmt.println(x)
    parse_flags(&flags)

    fmt.println(x)
}