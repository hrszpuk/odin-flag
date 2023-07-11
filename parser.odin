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
            fmt.println("FLAG FOUND")
            flag := new(CommandLineFlagData) 
            flag.name = tokens[i].value 
            append(&flags, flag)
            fmt.println("DEBUG:", flags)

            if i+1 < length {
                switch tokens[i+1].type {
                    case TokenType.INTEGER:
                        fmt.println("INT FOUND")
                        flag.type = int 
                        v := new(int)
                        v^ = strconv.atoi(tokens[i+1].value)
                        flag.value = v
                    case TokenType.FLOAT:
                        flag.type = f32 
                        //flag.value = strconv.atof(tokens[i+1].value)
                    case TokenType.BOOLEAN:
                        flag.type = bool 
                        //flag.value, _ = strconv.parse_bool(tokens[i+1].value)
                    case TokenType.IDENTIFIER:
                        flag.type = string 
                        buffer: strings.Builder 
                        strings.builder_init(&buffer)
                        
                        group := tokens[i+1].group
                        strings.write_string(&buffer, tokens[i+1].value)

                        i += 2
                        for i < length {
                            if tokens[i].type == TokenType.IDENTIFIER && tokens[i].group == group {
                                strings.write_byte(&buffer, ' ')
                                strings.write_string(&buffer, tokens[i].value)
                            } else {
                                break
                            }
                        }

                        //flag.value = strings.clone(strings.to_string(buffer))
                        strings.builder_destroy(&buffer)
                    case TokenType.FLAG: // set current flag to bool and break
                        flag.type = bool 
                        //flag.value = true
                        break
                }
                i += 2
            } else {
                flag.type = bool 
                //flag.value = true
                break
            }
        } else {
            i += 1  // ignoring invalid arguments for now
        }
    }
    return flags
}
