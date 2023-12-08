package flag 

import "core:runtime"
import "core:fmt"
import "core:os"
import "core:strings"

FlagSet :: struct {
    flags: [dynamic]Flag,
}

new_flagset :: proc() -> FlagSet {
    return FlagSet { make([dynamic]Flag) }
}

add_flag :: proc(flagset: ^FlagSet, name: string, source: ^$T) {
    flag := new_flag(name, source, typeid_of(T))
    append_elem(&flagset.flags, flag)
}

parse_flags :: proc(flagset: ^FlagSet) {
    for arg in os.args {
        if strings.has_prefix(arg, "--") {
            for flag in flagset.flags {
                if strings.compare(strings.to_string(flag.parse_name), arg) == 0 {
                    source := cast(^int)(flag.source)
                    source^ = 0
                }
            }
        }
    }
}

