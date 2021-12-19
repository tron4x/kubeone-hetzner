package main

import (
    "fmt"
    "os/exec"
    "runtime"
)

func execute() {

    out, err := exec.Command("/usr/bin/aptitude", "update").Output()

    if err != nil {
        fmt.Printf("%s", err)
    }

    fmt.Println("Command Successfully Executed")
    output := string(out[:])
    fmt.Println(output)

    out, err = exec.Command("/usr/bin/aptitude", "upgrade", "-y").Output()
    if err != nil {
        fmt.Printf("%s", err)
    }
    fmt.Println("Command Successfully Executed")
    output = string(out[:])
    fmt.Println(output)
}

func main() {
    if runtime.GOOS == "windows" {
        fmt.Println("Can't Execute this on a windows machine")
    } else {
        execute()
    }
}