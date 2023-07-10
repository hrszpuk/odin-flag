package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {

    if len(os.args) < 2 {
        help()
    } else if os.args[1] == "get" {
        s := os.args[2]
        if !strings.has_prefix(s, "https://") {
            s = fmt.aprintf("https://%s", s)
        }
        if !strings.has_suffix(s, ".git") {
            s = fmt.aprintf("%s.git", s)
        }
        cmd := fmt.aprintf("git clone %s temp", s)
        libc.system(strings.clone_to_cstring(cmd))
    }
}

help :: proc() {

}