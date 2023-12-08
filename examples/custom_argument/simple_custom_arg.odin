package example

// To run please us the command below:
// odin build . && ./custom_argument --hex=56

import "core:fmt"
import "core:strconv"
import flag "../.."

// Our custom type
hexadecimal :: distinct int 

/* Our handler for the custom argument
    -> flag_source is the pointer to the variable we reference when creating the flag
    -> parsed_value contains the value of our flag (e.g. --flag=parsed_value) */
modify_hexadecimal_flag :: proc(flag_source: rawptr, parsed_value: string) {

    // First we cast the rawptr to the correct pointer type so we can dereference it.
    source := cast(^hexadecimal) flag_source

    // We parsed the value and assign it to the flag's variable
    if true_value, ok := strconv.parse_int(parsed_value, 16); ok {
        source^ = cast(hexadecimal) true_value
    }
}

main :: proc() {
    using flag 

    // Add our custom type's flag to the map of all flags
    FlagModifyHandlers[hexadecimal] = modify_hexadecimal_flag

    flags := flagset()

    hex: hexadecimal

    flags->add("hex", &hex, hexadecimal)
    flags->parse()

    fmt.printf("Our hexidecimal: %x\n", hex)
    fmt.printf("Our hexidecimal as an int: %d\n", hex)

    flags->free()
}