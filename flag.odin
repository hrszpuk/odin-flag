package flag

import "core:os"
import "core:strings"

Flag :: struct {
    name: string,
    value: rawptr,
    type: typeid,
}

global_flags: [dynamic]^Flag

init_global_flags :: proc() {
    global_flags = make([dynamic]^Flag)
}

free_global_flags :: proc() {
    delete(global_flags)
}

new_flag :: proc(name: string, value: rawptr, type: typeid) {
    f := new(Flag)
    f.name = name 
    f.value = value
    f.type = type
    append(&global_flags, f)
}

parse :: proc() {
    /* Parsing rules
     * -------------
     * 1. Flags are prefixed with - or --
     * 2. Flags must match a pre-existing flag name
     * 3. Flags may have a =... prefix
     *
     * Types:
     *  bool: true, false
     *  int: [0-9]+
     *  string: "..."
     *  float: [0-9]+.[0-9]+ (or int)
     * 
     * Examples of valid flags:
     *  --debug                    // Only for boolean flags
     *  -a
     *  --count=101                // Available for any type of flag
     *  --msg="Hello, World!"
     *  --pi 3.14159               // Only non-boolean flags
     */
    
}

