package flag

import "core:fmt"

main :: proc() {
    send_msg := new(bool)
    msg := new(string)
    
    new_flag(name="send", value=send_msg, type=bool)
    new_flag(name="msg", value=msg, type=string)

    parse()

    if send_msg^ {
        fmt.println(msg)
    }
}