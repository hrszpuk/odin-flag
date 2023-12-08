package flag

import "core:fmt"
import "core:strconv"

hexadecimal :: int 

modify_hexadecimal_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^hexadecimal) flag_source
    if true_value, ok := strconv.parse_int(parsed_value, 16); ok {
        source^ = true_value
    }
}

main :: proc() {

    FlagModifyHandlers[hexadecimal] = modify_hexadecimal_flag

    flags := flagset()

    b: uint

    flags->add("b", &b, hexadecimal)
    flags->parse()
    fmt.printf("out: %d\n", b)
    flags->free()
}