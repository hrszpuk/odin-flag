package flag 

import "core:fmt"

FlagError :: struct {

}

/* Parsing:
 * - Parsing assumes the pattern: FLAG VALUE...
 * - If pattern does not match it will ignore the irregularities
 */
parse_ :: proc(args: []string) {
    tokens := lex(args)
    //defer free_tokens(&tokens)

    fmt.println("GLOBAL FLAGS: ", global_flags)
    fmt.println("TOKENS: ", tokens)

    i := 0
    length := len(tokens)

    for i < length {
        if tokens[i].type == TokenType.FLAG {
            fmt.println("FOUND FLAG: ", tokens[i])
            flag_tkn := tokens[i]
            flag: ^Flag = nil

            for gflag in global_flags {
                if gflag.name == flag_tkn.value {
                    flag = gflag
                }
            }

            i += 1
            if flag == nil {
                break
            } 
            fmt.println("FLAG IS VALID: ", flag)

            if i < length {
                value_tkn := tokens[i]
                fmt.println("VALUE FOUND: ", value_tkn)
                if value_tkn.type == TokenType.FLAG {
                    if flag.type == bool {
                        ptr := cast(^bool)flag.value
                        fmt.println("ptr: ", ptr)
                        ptr^ = true
                    }
                    // Check flag typeid is boolean
                    // Set flag's value to true
                } else if value_tkn.type == TokenType.IDENTIFIER {
                    // Check if there are more identifiers 
                    // Check group numbers
                    // Combine if checks pass else bypass them
                    // Set flag's value to token's combined value
                } else {
                    // Convert TokenType to typeid
                    // Check flag typeid == flag token typeid
                    // Cast token's value
                    // Set flag's value to token's casted value
                }
            } else {
                fmt.println("END OF INPUT: ", flag.type)
                if flag.type == bool {
                    ptr := cast(^bool)flag.value
                    ptr^ = true
                    fmt.println("ACCEPTED")
                }
            }
            
        }
        i += 1
        fmt.println("i: ", i, "length: ", length, "condition: ", i < length)
    }
    free_tokens(&tokens)
}

convert_token_type_to_typeid :: proc(type: TokenType) -> typeid {
    #partial switch type {
        case TokenType.INTEGER: return int
        case TokenType.FLOAT: return f64
        case TokenType.BOOLEAN: return bool
        case: return nil
    }
}