# User guide for Odin-flag

## Table of Contents
- [The basic example](#the-basic-example)
- [Command line syntax](#command-line-syntax)
- [Adding custom arguments](#adding-custom-arguments)
    - [Hexadexcimal example](#hexadecimal-example)
    - [Vector3 example](#vector3-example)
- [Complete reference](#complete-reference)
    - [FlagSet](#flagset)
        - [Associated procedures](#associated-procedures)
            - [flagset() -> FlagSet](#flagset()-->-FlagSet)
            - [free_flagset(^FlagSet)](#free_flagset(^FlagSet))
            - [add_flag(^FlagSet, string, rawptr, typeid)](#add_flag(^FlagSet,-string,-rawptr,-typeid))
            - [parse_flagset(^FlagSet)](#parse_flagset(^FlagSet))
    - [Flag](#flag)
        - [Associated procedures](#associated-procedures-1)
            - [new_flag(string, rawptr, typeid) -> ^Flag](#new_flag(string,-rawptr,-typeid)-->-^Flag)
            - [free_flag(^Flag)](#free_flag(^Flag))
    - [FlagModifyHandlers](#FlagModifyHandlers)
        - [Adding a new handler](#Adding-a-new-handler)


# The basic example
The basic example can be found in [examples/basic/basic.odin](./examples/basic/basic.odin).

```odin
package example

import "core:fmt"
import flag "../.." // path to odin-flag

main :: proc() {
    using flag 

    flags := flagset() // Contains all our flags

    // We're going to define the flags for the example below:
    // program --toggle --msg="hello there good chum" --n=100 --pi=3.14

    msg := "This is a default value."
    toggle: bool 
    n: int 
    pi := 3.14

    // you can use either add_flag (or ->add).
    // This takes a name (will be used by the user on the command line), a reference to the flag variable, and the type of the variable.
    flags->add("msg", &msg, string)
    flags->add("toggle", &toggle, bool)
    flags->add("n", &n, int)
    flags->add("pi", &pi, f32)

    // The parse procedure will search through os.args to find any flags you've defined.
    flags->parse()

    // If any flags are found, the user can modify the variable's value.
    // Otherwise, the variable keeps the same value as it was initialised with.

    fmt.printf("Values ( msg: %s, toggle: %t, n: %d, f: %f )\n", msg, toggle, n, pi)

    // This will remove all memory related to the FlagSet and each individual Flag.
    // It will not free the flag's variable, that is your responsibility,
    flags->free()
}
```

# Command line syntax
Currently, the command line syntax looks as follows:
| ------- | ----------- |
| Type    | Flag usage  | 
| bool    | `--bool`, `--bool=true`, `--bool=false` |
| int     | `--int=101`, `--int=-49` |
| uint    | `--int=11209` |
| string  | `--str="Hello, World"`, `--str=Oak` |
| cstring | `--str="Hello, World"`, `--str=Oak` |

**Full example:**
```
program --bool --str="Hello World" --bool2=false --int=100 --uint=3445 --cstr="cstring"
```
The default `--name` syntax can be changed using the `Flag.parse_name` field.
```odin
run_command := false
flag := new_flag("run", &run_command, bool) // Syntax: program --run

// We could change the syntax to remove the -- prefix.
strings.builder_clear(flag.parse_name)
strings.write_string(flag.parse_name, "run")  // Syntax: program run
```

# Adding custom arguments
So far we have only explored the basic types.
What if you wanted to parse something more complex on the command line?

## Hexadecimal example
The hexadecimal example can be found in [examples/basic/basic.odin](./examples/basic/basic.odin).

```odin 
package example

import "core:fmt"
import "core:strconv"
import flag "../.."

// Our custom type
hexadecimal :: distinct int 

/* Our handler for the custom argument
    -> flag_source is the pointer to the variable we reference when creating the flag
    -> parsed_value contains the value of our flag (e.g. --flag=parsed_value) */
modify_hexadecimal_flag :: proc(flag_source: rawptr, parsed_value: string) {

    // First we cast the rawptr to the correct pointer type so we can dereference it.
    source := cast(^hexadecimal) flag_source

    // We parsed the value and assign it to the flag's variable
    if true_value, ok := strconv.parse_int(parsed_value, 16); ok {
        source^ = cast(hexadecimal) true_value
    }
}

main :: proc() {
    using flag 

    // Add our custom type's flag to the map of all flags
    FlagModifyHandlers[hexadecimal] = modify_hexadecimal_flag

    flags := flagset()

    hex: hexadecimal

    flags->add("hex", &hex, hexadecimal)
    flags->parse()

    fmt.printf("Our hexidecimal: %x\n", hex)
    fmt.printf("Our hexidecimal as an int: %d\n", hex)

    flags->free()
}
```

## Vector3 example
The vector3 example can be found in [examples/basic/basic.odin](./examples/basic/basic.odin).

```odin
package example

// To run please us the command below:
// odin build . && ./vector3 --vec=(100,200,-700)

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:unicode"
import flag "../.."

// Our custom type
vector3 :: distinct [3]int 

/* Our handler for the custom argument
    -> flag_source is the pointer to the variable we reference when creating the flag
    -> parsed_value contains the value of our flag (e.g. --flag=parsed_value) */
modify_vector3_flag :: proc(flag_source: rawptr, parsed_value: string) {

    // First we cast the rawptr to the correct pointer type so we can dereference it.
    source := cast(^vector3) flag_source

    // Parsing (d,d,d)
    count := 0
    if parsed_value[0] == '(' {
        buffer := strings.builder_make()
        for c, i in parsed_value[1:] {
            if unicode.is_digit(c) {
                strings.write_rune(&buffer, c)
            } else if c == ',' {
                if n, ok := strconv.parse_int(strings.to_string(buffer)); ok {
                    source^[count] = n
                } else {
                    fmt.println("Vector3 parse error: strconv.parse_int failed!")
                    return
                }
                count += 1
                strings.builder_reset(&buffer)
            } else if c == ')' {
                if count != 2 {
                    fmt.println("Vector3 parse error: expected 3 integers!")
                    return
                } else if n, ok := strconv.parse_int(strings.to_string(buffer)); ok {
                    source^[count] = n
                    return
                } else {
                    return
                }

            } else {
                fmt.println("Vector3 parse error: unexpected character found!")
                return
            }
        }
    }
}

main :: proc() {
    using flag 

    // Add our custom type's flag to the map of all flags
    FlagModifyHandlers[vector3] = modify_vector3_flag

    flags := flagset()

    vec: vector3

    flags->add("vec", &vec, vector3)
    flags->parse()

    fmt.printf("%d\n", vec)

    flags->free()
}
```

# Complete reference

## FlagSet
```odin
// Definition
FlagSet :: struct {
    flags: [dynamic]^Flag,

    // Associated procedures (selector call expression shorthand)
    add: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid),
    parse: proc(flagset: ^FlagSet),
    free: proc(flagset: ^FlagSet),
}
```
### Associated procedures

#### flagset() -> FlagSet
Creates a new, empty flagset.
```odin
// Usage
flags := flagset()
```

#### free_flagset(^FlagSet)
Frees all associated data. Does not harm referenced variables.
```odin
// Usage
free_flagset(&flags)

// Shorthand
flags->free()
```

#### add_flag(^FlagSet, string, rawptr, typeid)
Adds a new flag to the flagset.
```odin
// Usage
name: string = "Jerry"
add_flag(&flags, "name", &name, string)

// Shorthand
flags->add("name", &name, string)
```

#### parse_flagset(^FlagSet)
Parses `os.args`, finds flag, parses flag value and modifies variable value.
```odin
// Usage
parse_flagset(&flags)

// Shorthand
flags->parse()
```

## Flag
```odin
// Definition
Flag :: struct {

    // Name of the flag
    name: string,

    // Defaults to: --name (can be changed if you want a different prefix than -- or a different name)
    parse_name: strings.Builder,

    // Points to where data will be stored
    source: rawptr,

    // The type of data the flag will parse
    type: typeid,

    found: bool,
    value: string,

    // Associated procedures (selector call expression shorthand)
    free: proc(self: ^Flag),
}
```

### Associated procedures

#### new_flag(string, rawptr, typeid) -> ^Flag
Creates a new flag.

```odin
// Usage
n := 1
n_flag := new_flag("n", &n, int)
```

#### free_flag(^Flag)
Frees all associated data. Does not harm referenced variables.


# FlagModifyHandlers
When a flag is found on the command line, it's value is stored in a string and given to the flag's parsing procedure.
`FlagModifyHandlers` is a map that contains all the parsing procedures available.
The flag's typeid is used to find the correct parsing procedure.
```odin
// Definition
FlagModifyHandlers := map[typeid]proc(flag_source: rawptr, parsed_value: string){
    bool = modify_bool_flag,
    int = modify_int_flag,
    uint = modify_uint_flag,
    string = modify_string_flag,
    cstring = modify_cstring_flag,
}
```

## Adding a new handler
```odin
// Create your handler
modify_TYPE_handler :: proc(flag_source: rawptr, parsed_value: string) {
    // flag_source points to the flag's variable
    // parsed_value holds what value the parser has found for our flag (could be anything)

    source := cast(^TYPE) flag_source

    // parse the parsed_value how every you like.

    source^ = VALUE
}
```
