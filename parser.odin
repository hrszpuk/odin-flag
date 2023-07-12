package flag 

import "core:strconv"
import "core:strings"
import "core:fmt"

parse :: proc(tokens: ^[dynamic]^Token) -> [dynamic]^CommandLineFlagData {
    flags := make([dynamic]^CommandLineFlagData)

    i := 0
    length := len(tokens)

    for i < length {
        if tokens[i].type == TokenType.FLAG {
            //fmt.println("FLAG FOUND")
            flag := new(CommandLineFlagData) 
            flag.name = tokens[i].value 
            append(&flags, flag)
            //fmt.println("DEBUG:", flags)

            if i+1 < length {
                switch tokens[i+1].type {
                    case TokenType.INTEGER:
                        //fmt.println("INT FOUND")
                        flag.type = int 
                        v := new(int)
                        v^ = strconv.atoi(tokens[i+1].value)
                        flag.value = v
                    case TokenType.FLOAT:
                        flag.type = f64 
                        v := new(f64) 
                        v^ = strconv.atof(tokens[i+1].value)
                        //fmt.println("FLOAT: ", v^, " AT ", v)
                        flag.value = v
                    case TokenType.BOOLEAN:
                        flag.type = bool 
                        v := new(bool) 
                        v^, _ = strconv.parse_bool(tokens[i+1].value)
                        flag.value = v
                    case TokenType.IDENTIFIER:
                        flag.type = string 
                        buffer: strings.Builder 
                        strings.builder_init(&buffer)
                        
                        group := tokens[i+1].group
                        strings.write_string(&buffer, tokens[i+1].value)

                        i += 2
                        for i < length {
                            if tokens[i].type != TokenType.FLAG && tokens[i].group == group {
                                strings.write_byte(&buffer, ' ')
                                strings.write_string(&buffer, tokens[i].value)
                            } else {
                                break
                            }
                            i += 1
                        }

                        v := new(string)
                        v^ = strings.clone(strings.to_string(buffer))
                        flag.value = v //NOTE(remy) data lost originates here
                        strings.builder_destroy(&buffer)
                    case TokenType.FLAG: // set current flag to bool and break
                        //fmt.println("BOOL DEBUG: ", tokens[i+1].value)
                        flag.type = bool 
                        v := new(bool) 
                        v^ = true
                        flag.value = v
                        i -= 1
                        break
                }
                i += 2
            } else {
                flag.type = bool 
                v := new(bool) 
                v^ = true
                flag.value = v
                break
            }
        } else {
            i += 1  // ignoring invalid arguments for now
        }
    }
    return flags
}

free_commandline_data :: proc(data: [dynamic]^CommandLineFlagData) {
    for point in data {
        free(point.value)
        free(point)
    }
    delete(data)
}
