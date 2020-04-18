package main

import (
	"fmt"
	"os"
)

//
func start() {
	var reverseOrBindOrShellCode string
	fmt.Println(red+bold+"  < [1] Reverse [2] Bind [3] Exit >", reset)
	fmt.Scanf("%s", &reverseOrBindOrShellCode)

	switch reverseOrBindOrShellCode {
	case "1":
		reverseShell()
	case "2":
		bindShell()
	case "3":
		os.Exit(0)
	default:
		fmt.Println(green+bold+"Invalid Option!", reset)
		start()
	}
}

func welcome() {
	fmt.Println(" |===================================|")
	fmt.Println("||", "\t\t\t\t     ||")
	fmt.Println("||", red, "\t", bold, " Vengen v1.0", "\t\t", reset, "   ||")
	fmt.Println("||", "\tby:", green, "BinexisHATT", reset, "\t  ", "  ||")
	fmt.Println("||", "\t\t\t\t     ||")
	fmt.Println(" |===================================|")
}

func main() {
	welcome()
	start()
}
