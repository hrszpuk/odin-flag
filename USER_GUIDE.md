# User guide for Odin-flag

## Table of Contents
- Walkthough of the basic example
    - What is FlagSet?
    - Adding flags
    - After parsing
    - After freeing
- Command line syntax
- Default types
- Adding custom arguments
    - Creating a flag parse handler procedure
    - What is the FlagParseHandler map?
    - A complete example

# - Walkthough of the basic example
The complete basic example can be found in examples/basic/basic.odin.

## What is FlagSet?
FlagSet is a collection of flags.
This struct allows us to keep track of flags easily as shown below.
```odin
// Create a new FlagSet using the flagset() procedure.
flags := flagset() 

// flagset.odin: FlagSet definition
FlagSet :: struct {
    flags: [dynamic]^Flag,

    // Associated procedures (selector call expression shorthand)
    add: proc(flagset: ^FlagSet, name: string, source: rawptr, type: typeid),
    parse: proc(flagset: ^FlagSet),
    free: proc(flagset: ^FlagSet),
}
```
The associated procedures can be accessed nicely using the selector call expression syntax sugar:
```odin
// Selector call expression: a->b(...) is converted to a.b(a, ...)
flagset->add(...)
flagset->parse(...)
flagset->free(...)
```

## Adding flags
If you're using a flag parsing library, you likely already know what a flag is.
So, below is a realistic example of how we would add a Flag to a FlagSet:
```odin

// Any initialised value will be the "default" value used if a flag is not used.
x := 100

// name ("x") is the name of the flag used on the command line
// source (&x) is a reference of the variable (may modify the variable's value)
// type (int) is the typeid of the variable
flagset->add("x", &x, int)
```

Below is how we would create a standalone flag:
```odin 
name: string
our_flag := new_flag("name", &name, string)
```
Creating a flag in this way gives us more control of the flag itself.
We can access, and modify, the `parse_name` field, which is the name the parser uses when checking the command line arguments (defaults to `--name`).
We can also check fields for more information about the flag after parsing: checking `found` tells us whether the flag was found or not, and checking `value` is the value of the flag before it was fully parsed.

## After parsing
After parsing all flag variables can still be used as normal.
The values of the variables may have been modified after pasring.

## After freeing
Freeing the FlagSet (using `flagset->free()` or `free_flagset(flagset)`) will cause all associated flags to be freed as well.
The flag variables (those of which are passed as referenes) will remain intacted and should be freed by you when necessary.

# Command line syntax
Currently, the command line syntax looks as follows:
```
program --bool --str="Hello World" --bool2=false --int=100 --uint=3445 --cstr="cstring"
```
The default `--name` syntax can be changed using the `Flag.parse_name` field.

# Default types
The default types are the following:
```
bool 
int
uint
string
cstring
```
More may be added in the future. 
You can add logic to parse custom types.