package flag

import "core:os"
import "core:strings"
import "core:fmt"
import "core:reflect"

CommandLineFlagData :: struct {
    name: string, 
    value: any,
    type: typeid,
}

Flag :: struct {
    name: string,
    value: rawptr,
    type: typeid,
    parsed: bool,
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
                    fmt.println(point.value)
                    switch flag.type {
                        case int: 
                        user_value := cast(^int)flag.value
                        value, ok := reflect.as_int(point.value)

                        fmt.printf("%p = %d (originally: %d)\n", user_value, value, user_value^)
                        user_value^ = value
                        
                        case f32: 
                        user_value := cast(^f32)flag.value
                        //user_value^ = point.value.(f32)
                        case string: 
                        user_value := cast(^string)flag.value
                        //user_value^ = point.value.(string)
                        case bool: 
                        user_value := cast(^bool)flag.value
                        //user_value^ = point.value.(bool)
                    }
                }
            }
        }
    }
}