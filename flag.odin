package flag

import "core:os"
import "core:strings"
import "core:fmt"

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

parse_flags :: proc() {
    //args := strings.join(os.args[1:], " ")
    tokens := lex(os.args[1:])
    flags := parse(&tokens)

    fmt.println(tokens)
    free_tokens(&tokens)
    //delete(args)
}