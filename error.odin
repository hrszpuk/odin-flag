package flag 

FlagError :: struct {

}

/* Parsing:
 * - Parsing assumes the pattern: FLAG VALUE...
 * - If pattern does not match it will ignore the irregularities
 */
parse_ :: proc(args: []string) {
    tokens := lex(args)
    defer free_tokens(&tokens)

    i := 0
    for length := len(tokens); i < length {
        switch tokens.TokenType {
            case TokenType.FLAG:
                flag_tkn := tokens[i]
                i += 1
                if i < length {
                    value_tkn := tokens[i]
                    if value_tkn.TokenType == TokenType.FLAG {
                        // Check if flag token name is valid
                        // Check flag typeid is boolean
                        // Set flag's value to true/false
                    } else if value.TokenType == TokenType.IDENTIFIER {
                        // Check if flag token name is valid
                        // Check if there are more identifiers 
                        // Check group numbers
                        // Combine if checks pass else bypass them
                        // Set flag's value to token's combined value
                    } else {
                        // Check if flag token name is valid
                        // Convert TokenType to typeid
                        // Check flag typeid == flag token typeid
                        // Cast token's value
                        // Set flag's value to token's casted value
                    }
                }
            case:
                i += 1
        }
    }
}