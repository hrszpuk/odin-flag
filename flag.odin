package flag

ErrorHandling :: int
ContinueOnError : ErrorHandling = 0
ExitOnError : ErrorHandling = 1
PanicOnError : ErrorHandling = 2

Flag :: struct {
    Name: string,           // name as it appears on the command line
    Usage: string,          // help message
    Value: Value,           // value as set
    DefValue: string,       // default value (as text); for usage message
}

lookup :: proc(name: string) -> ^Flag {
    
}


