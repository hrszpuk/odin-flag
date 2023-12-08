package flag 

import "core:strings"
import "core:strconv"

FlagModifyHandlers := map[typeid]proc(flag_source: rawptr, parsed_value: string){
    bool = modify_bool_flag,
    int = modify_int_flag,
    uint = modify_uint_flag,
    string = modify_string_flag,
    cstring = modify_cstring_flag,
}

modify_bool_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^bool) flag_source
    if true_value, ok := strconv.parse_bool(parsed_value); ok {
        source^ = true_value
    }
}

modify_int_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^int) flag_source
    if true_value, ok := strconv.parse_int(parsed_value); ok {
        source^ = true_value
    }
}

modify_uint_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^uint) flag_source
    if true_value, ok := strconv.parse_uint(parsed_value); ok {
        source^ = true_value
    }
}

modify_string_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^string) flag_source
    source^ = parsed_value
}

modify_cstring_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^cstring) flag_source
    source^ = strings.clone_to_cstring(parsed_value)
}