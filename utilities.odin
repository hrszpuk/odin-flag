package flag 

@(private="package")
is_numeric :: proc{
    is_numeric_str, 
    is_numeric_byte,
}

@(private="file")
is_numeric_str :: proc(input: string) -> bool {
    for i in input {
        if !(int(i) < 58 && int(i) > 47) {
            return false
        }
    }
    return true
}

@(private="file")
is_numeric_byte :: proc(input: byte) -> bool {
    return (int(input) < 58 && int(input) > 47)
}

