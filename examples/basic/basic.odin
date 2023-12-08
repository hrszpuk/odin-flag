package example

// To run please us the command below:
// odin build . && ./basic --toggle --msg="hello there good chum" --n=100 --pi=3.14

import "core:fmt"
import "core:strconv"
import flag "../.." // path to odin-flag

main :: proc() {
    using flag 

    flags := flagset() // Contains all our flags

    msg := "This is a default value."
    toggle: bool 
    n: int 
    pi := 3.14

    flags->add("msg", &msg, string)
    flags->add("toggle", &toggle, bool)
    flags->add("n", &n, int)
    flags->add("pi", &pi, f32)

    flags->parse()

    fmt.printf("Values ( msg: %s, toggle: %t, n: %d, f: %f )\n", msg, toggle, n, pi)

    flags->free()
}