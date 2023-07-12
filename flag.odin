package flag

import "core:os"
import "core:strings"
import "core:fmt"
import "core:reflect"

CommandLineFlagData :: struct {
    name: string, 
    value: rawptr,
    type: typeid,
}

Flag :: struct {
    name: string,
    value: rawptr,
    type: typeid,
    parsed: bool,
    err: FlagError
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
    tokens := lex(os.args[1:])
    flag_data := parse(&tokens)
    //free_tokens(&tokens)

    fmt.println(global_flags)
    fmt.println(tokens)
    fmt.println(flag_data)
    for flag in global_flags {
        for point in flag_data {
            if flag.name == point.name {
                fmt.println("YES")
                if flag.type == point.type {
                    fmt.println("GO ON MY SON")
                    switch flag.type {
                        case int: 
                        user_value := cast(^int)flag.value
                        value := (cast(^int)point.value)^
                        fmt.printf("%p = %d (originally: %d)\n", user_value, value, user_value^)
                        user_value^ = value
                        case f64: 
                        user_value := cast(^f64)flag.value
                        value := (cast(^f64)point.value)^
                        fmt.printf("%p = %d (originally: %d)\n", user_value, value, user_value^)
                        user_value^ = value
                        case string: 
                        user_value := cast(^string)flag.value
                        value := (cast(^string)point.value)^
                        fmt.printf("%p = %d (originally: %d)\n", user_value, value, user_value^)
                        user_value^ = value
                        case bool: 
                        user_value := cast(^bool)flag.value
                        value := (cast(^bool)point.value)^
                        fmt.printf("%p = %d (originally: %d)\n", user_value, value, user_value^)
                        user_value^ = value
                    }
                } else {
                    // Names match but are different types!
                }
            }
        }
    }
}