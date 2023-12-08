package flag 

import "core:runtime"
import "core:fmt"
import "core:os"
import "core:strings"

FlagSet :: struct {
    flags: [dynamic]Flag,

    // Associated functions (selector call expression shorthand)
    add: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid),
    contains: proc(flagset: ^FlagSet, flag: Flag) -> bool,
    parse: proc(flagset: ^FlagSet),
}

new_flagset :: proc() -> FlagSet {
    return FlagSet { 
        make([dynamic]Flag), 

        add_flag,  
        flagset_contains,
        parse_flagset
    }
}

add_flag :: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid) {
    flag := new_flag(name, source, type)
    append_elem(&flagset.flags, flag)
}

flagset_contains :: proc(flagset: ^FlagSet, flag: Flag) -> bool {
    for f in flagset.flags {
        if f.source == flag.source {
            return true 
        }
    }
    return false
}

parse_flagset :: proc(flagset: ^FlagSet) {
    for arg in os.args {
        for flag in flagset.flags {
            if strings.compare(strings.to_string(flag.parse_name), arg) == 0 {
                

                // Check if arg contains an = (flag=100)

                // Check if arg is a boolean
            }
        }
    }
}