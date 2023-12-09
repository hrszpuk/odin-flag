package example

// To run please us the command below:
// odin build . && ./vector3 --vec=(100,200,-700)

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:unicode"
import flag "../.."

// Our custom type
vector3 :: distinct [3]int 

/* Our handler for the custom argument
    -> flag_source is the pointer to the variable we reference when creating the flag
    -> parsed_value contains the value of our flag (e.g. --flag=parsed_value) */
modify_vector3_flag :: proc(flag_source: rawptr, parsed_value: string) {

    // First we cast the rawptr to the correct pointer type so we can dereference it.
    source := cast(^vector3) flag_source

    // Parsing (d,d,d)
    count := 0
    if parsed_value[0] == '(' {
        buffer := strings.builder_make()
        for c, i in parsed_value[1:] {
            if unicode.is_digit(c) {
                strings.write_rune(&buffer, c)
            } else if c == ',' {
                if n, ok := strconv.parse_int(strings.to_string(buffer)); ok {
                    source^[count] = n
                } else {
                    fmt.println("Vector3 parse error: strconv.parse_int failed!")
                    return
                }
                count += 1
                strings.builder_reset(&buffer)
            } else if c == ')' {
                if count != 2 {
                    fmt.println("Vector3 parse error: expected 3 integers!")
                    return
                } else if n, ok := strconv.parse_int(strings.to_string(buffer)); ok {
                    source^[count] = n
                    return
                } else {
                    return
                }

            } else {
                fmt.println("Vector3 parse error: unexpected character found!")
                return
            }
        }
    }
}

main :: proc() {
    using flag 

    // Add our custom type's flag to the map of all flags
    FlagModifyHandlers[vector3] = modify_vector3_flag

    flags := flagset()

    vec: vector3

    flags->add("vec", &vec, vector3)
    flags->parse()

    fmt.printf("%d\n", vec)

    flags->free()
}