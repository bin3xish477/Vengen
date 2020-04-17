package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

//
func getMainOptions() {
	var p venomOpts
	var reverseOrBind string
	reader := bufio.NewReader(os.Stdin)

	fmt.Println(red+bold+"[1] Reverse,[2] bind, [3] shellcode:", reset)
	fmt.Scanf("%s", &reverseOrBind)

	switch reverseOrBind {
	case "1":
		p = reverseShell(p)
	case "2":
		p = bindshell(p)
	case "3":
		p = shellcodeGen(p)
	default:
		fmt.Println(red+bold+"Invalid option.", reset)
	}

	fmt.Println(red+bold+"Payload:", reset)
	payload, err := reader.ReadString('\n')
	e := checkError(err)
	if e == false {
		p.payload = payload
	}

	fmt.Println(red + bold + "Format:" + reset)
	format, err := reader.ReadString('\n')
	e = checkError(err)
	if e == false {
		p.format = format
	}

	fmt.Println("Add more options?"+red+" [Y/n]", reset)
	var cont string
	fmt.Scanf("%s", &cont)
	cont = strings.ToLower(cont)

	var areExtras bool
	// Checking if the user wants to add more options
	// to the payload they are creating.
	switch cont {
	case "y":
		p = extras(p)
		areExtras = true
		run(p, areExtras)
	case "n":
		areExtras = false
		run(p, areExtras)
	default:
		fmt.Println(red+"Goodbye...", reset)
		os.Exit(0)
	}
}

func reverseShell(v venomOpts) venomOpts {
	reader := bufio.NewReader(os.Stdin)

	fmt.Println("\n"+red+bold+"Target IP:", reset)
	targetIP, err := reader.ReadString('\n')
	e := checkError(err)
	if e == false {
		v.targetIP = targetIP
	}

	fmt.Println(green+bold+"Target port:", reset)
	var targetPort int
	_, err = fmt.Scanf("%d", &targetPort)
	e = checkError(err)
	if e == false {
		v.targetPort = targetPort
	}
	return v
}

func bindshell(v venomOpts) venomOpts {
	reader := bufio.NewReader(os.Stdin)
	fmt.Println(blue+bold+"Host IP:", reset)
	hostIP, err := reader.ReadString('\n')
	e := checkError(err)
	if e == false {
		v.hostIP = hostIP
	}

	fmt.Println(yellow+bold+"Host port:", reset)
	var hostPort int
	_, err = fmt.Scanf("%d", &hostPort)
	e = checkError(err)
	if e == false {
		v.hostPort = hostPort
	}
	return v
}

// Generates shellcode does not save to file.
// Shell code is generated and displayed to stdout.
func shellcodeGen(v venomOpts) venomOpts {

}

func extras(p venomOpts) venomOpts {
	reader := bufio.NewReader(os.Stdin)

	fmt.Println(green + bold + "Encoder:" + reset)
	encoder, err := reader.ReadString('\n')
	e := checkError(err)
	if e == false {
		p.encoder = encoder
	}

	fmt.Println(blue + bold + "Architecture:" + reset)
	encoder, err = reader.ReadString('\n')
	e = checkError(err)
	if e == false {
		p.architecture = encoder
	}

	fmt.Println(yellow + bold + "Bad Characters:" + reset)
	architecture, err := reader.ReadString('\n')
	e = checkError(err)
	if e == false {
		p.architecture = architecture
	}

	fmt.Println(blue + bold + "Output File Name:" + reset)
	outf, err := reader.ReadString('\n')
	e = checkError(err)
	if e == false {
		p.output = outf
	}
	return p
}

// checkError simply takes in an error and 
// determines if an error occured performing
// a particular operation.
func checkError(e error) bool {
	if e != nil {
		fmt.Println(red, e, reset)
		os.Exit(0)
	}
	return false
}

//
func welcome() {
	fmt.Println(" |==================================|")
	fmt.Println("||", "\t\t\t\t    ||")
	fmt.Println("||", red, "\t", bold, " Vengen v1.0", "\t\t", reset, "  ||")
	fmt.Println("||", "\tby:", yellow, "BinexisHATT", reset, "\t  ", " ||")
	fmt.Println("||", "\t\t\t\t    ||")
	fmt.Println(" |==================================|")
}

func main() {
	welcome()
	getMainOptions()
}