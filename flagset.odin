package flag 

import "core:runtime"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

FlagSet :: struct {
    flags: [dynamic]^Flag,

    // Associated functions (selector call expression shorthand)
    add: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid),
    contains: proc(flagset: ^FlagSet, flag: Flag) -> bool,
    parse: proc(flagset: ^FlagSet),
}

flagset :: proc() -> FlagSet {
    return FlagSet { 
        make([dynamic]^Flag), 

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
    for arg in os.args[1:] {
        buffer := arg
        value := "true"
        if strings.contains(buffer, "=") {
            split_str := strings.split_after_n(arg, "=", 2)
            if len(split_str) > 1 {
                buffer = split_str[0][:len(split_str[0])-1]
                value = split_str[1]
            }
        } 

        for flag in flagset.flags {
            if strings.to_string(flag.parse_name) == buffer {
                flag.found = true
                flag.value = value
                FlagModifyHandlers[flag.type](flag.source, value)
            }
        }
    }
}