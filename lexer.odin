package flag 

import "core:strings"
import "core:fmt"

TokenType :: enum {
    FLAG,
    IDENTIFIER,
    EQUALS,
    INTEGER,
    FLOAT,
    BOOLEAN,
}

Token :: struct {
    value: string,
    type: TokenType,
}

lex :: proc(input: string) -> [dynamic]^Token {
    using strings
    tokens := make([dynamic]^Token)

    i := 0
    length := len(input) 

    builder: Builder

    cmd := clone(input)
    defer delete(cmd)

    builder_init(&builder)

    for i < length {
        fmt.println(cmd[i])
        switch cmd[i] {
            case '-':
                if i+1 < length {
                    if int(cmd[i+1]) < 58 && int(cmd[i+1]) > 47 {
                        write_byte(&builder, cmd[i])
                        i += 1
                        get_number(&i, &tokens, &builder, &cmd)
                    } else {
                        get_identifier(&i, &tokens, &builder, &cmd)
                    }
                }
            case '0'..='9', '.': get_number(&i, &tokens, &builder, &cmd)
            case 'A'..='Z', 'a'..='z': get_identifier(&i, &tokens, &builder, &cmd)
        }
        i += 1
    }

    builder_destroy(&builder)
    return tokens
}

get_number :: proc(i: ^int, tokens: ^[dynamic]^Token, builder: ^strings.Builder, cmd: ^string) {
    using strings
    length := len(cmd)
    t := new(Token)
    t.type = TokenType.INTEGER
    for i^ < length && ((int(cmd[i^]) < 58 && int(cmd[i^]) > 47) || cmd[i^] == '.') {
        write_byte(builder, cmd[i^])
        if cmd[i^] == '.' {
            t.type = TokenType.FLOAT
        }
        i^ += 1
    }
    t.value = clone(to_string(builder^))
    append(tokens, t)

    builder_destroy(builder)
    builder_init(builder)
}

get_identifier :: proc(i: ^int, tokens: ^[dynamic]^Token, builder: ^strings.Builder, cmd: ^string) {
    using strings
    length := len(cmd)
    t := new(Token)
    t.type = TokenType.IDENTIFIER

    for i^ < length && 
    ((int(cmd[i^]) < 123 && int(cmd[i^]) > 96) || (int(cmd[i^]) < 91 && int(cmd[i^]) > 64) || (int(cmd[i^]) < 58 && int(cmd[i^]) > 47) || cmd[i^] == '-') {
        write_byte(builder, cmd[i^])
        i^ += 1
    }
    t.value = clone(to_string(builder^))
    append(tokens, t)

    if compare(t.value, "true") == 0 || compare(t.value, "false") == 0 {
        t.type = TokenType.BOOLEAN
    } else if has_prefix(t.value, "--") {
        t.type = TokenType.FLAG
    }

    builder_destroy(builder)
    builder_init(builder)
}

free_tokens :: proc(t: ^[dynamic]^Token) {
    for ptr in t^ {
        delete(ptr.value)
        free(ptr)
    }
    delete(t^)
}