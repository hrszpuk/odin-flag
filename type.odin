package flag 

import "core:strconv"

FlagModifyHandlers := map[typeid]proc(flag_source: rawptr, parsed_value: string){
    int = modify_int_flag,
    bool = modify_bool_flag
}

modify_int_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^int) flag_source
    if true_value, ok := strconv.parse_int(parsed_value); ok {
        source^ = true_value
    }
}

modify_bool_flag :: proc(flag_source: rawptr, parsed_value: string) {
    source := cast(^bool) flag_source
    if true_value, ok := strconv.parse_bool(parsed_value); ok {
        source^ = true_value
    }
}