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
    parse: proc(flagset: ^FlagSet),
    free: proc(flagset: ^FlagSet),
}

flagset :: proc() -> FlagSet {
    return FlagSet { 
        make([dynamic]^Flag), 

        add_flag,  
        parse_flagset,
        free_flagset,
    }
}

free_flagset :: proc(f: ^FlagSet) {
    for flag in f.flags {
        strings.builder_destroy(&flag.parse_name)
        free(flag)
    }
    delete(f.flags)
}

add_flag :: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid) {
    flag := new_flag(name, source, type)
    append_elem(&flagset.flags, flag)
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