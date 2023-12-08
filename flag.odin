package flag 

import "core:strings"

Flag :: struct {

    // The name used on the command line to refer to the flag
    name: string,

    // Defaults to: --name (can be changed if you want a different prefix than -- or a different name)
    parse_name: strings.Builder,

    // Points to where data will be stored
    source: rawptr,

    // The type of data the flag will parse
    type: typeid,

    found: bool,

    // Associated functions (selector call expression shorthand)
    free: proc(self: ^Flag),
}

new_flag :: proc(name: string, source: rawptr, type: typeid) -> Flag {
    parse_name := strings.builder_make()

    strings.write_string(&parse_name, "--")
    strings.write_string(&parse_name, name)

    return Flag{ name, parse_name, source, type, false, free_flag }
}

free_flag :: proc(flag: ^Flag) {
    strings.builder_destroy(&flag.parse_name)
}

