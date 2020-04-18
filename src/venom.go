/*
Author: Alexis Rodriguez
Date: 10 April 2020

This programs makes the payload generation process
with Msfvenom simpler and user-friendly.
*/

package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strconv"
)

// Ansicolors
const (
	reset string = "\x1b[0m"
	bold  string = "\x1b[1m"
	red   string = "\x1b[31m"
	green string = "\x1b[32m"
)

// venomOptions is a struct containing
// most of the options provided by
// msfvenom and each can be further understood
// by reading the explanations present
// in msfvenom's help menu.
type venom struct {
	targetIP   string
	targetPort int
	hostIP     string
	hostPort   int
	payload    string
	format     string
	output     string
}

//
func reverseShell() {
	var v venom
	reader := bufio.NewReader(os.Stdin)

	fmt.Println(red+bold+"Host IP:", reset)
	hIP, err := reader.ReadString('\n')
	if noError(err) {
		v.hostIP = hIP
	}

	fmt.Println(red+bold+"Host Port:", reset)
	hPort, err := reader.ReadString('\n')
	if noError(err) {
		v.hostPort, _ = strconv.Atoi(hPort)
	}

	fmt.Println(red+bold+"Payload", reset)
	payload, err := reader.ReadString('\n')
	if noError(err) {
		v.payload = payload
	}

	fmt.Println(red+bold+"Format:", reset)
	format, err := reader.ReadString('\n')
	if noError(err) {
		v.format = format
	}

	v = promptFileName(v)
	promptStartOver()

	var b bool
	if v.output != "" {
		b = true
	} else {
		b = false
	}
	run(v, b, "reverse")
}

//
func bindShell() {
	var v venom
	reader := bufio.NewReader(os.Stdin)

	fmt.Println(red+bold+"Target IP:", reset)
	hIP, err := reader.ReadString('\n')
	if noError(err) {
		v.hostIP = hIP
	}

	fmt.Println(red+bold+"Target Port:", reset)
	hPort, err := reader.ReadString('\n')
	if noError(err) {
		v.hostPort, _ = strconv.Atoi(hPort)
	}

	fmt.Println(red+bold+"Payload", reset)
	payload, err := reader.ReadString('\n')
	if noError(err) {
		v.payload = payload
	}

	fmt.Println(red+bold+"Format:", reset)
	format, err := reader.ReadString('\n')
	if noError(err) {
		v.format = format
	}

	v = promptFileName(v)
	promptStartOver()

	var b bool
	if v.output != "" {
		b = true
	} else {
		b = false
	}
	run(v, b, "bind")
}

//
func promptFileName(v venom) venom {
	reader := bufio.NewReader(os.Stdin)

	fmt.Println("Would you like to save shellcode to file?", red+bold+"Y/n", reset)
	ans, _, err := reader.ReadRune()
	if noError(err) {
		if ans == 'y' || ans == 'Y' {
			reader = bufio.NewReader(os.Stdin)
			fmt.Println(red+bold+"Enter File Name:", reset)
			fileName, err := reader.ReadString('\n')
			if noError(err) {
				v.output = fileName
			}
		}
	}
	return v
}

// startOver will check if the user wants to start the
// process again to change the original input values.
func promptStartOver() {
	reader := bufio.NewReader(os.Stdin)
	fmt.Println("Would you like to generate a new payload?", red+bold+"Y/n", reset)
	ans, _, err := reader.ReadRune()
	if noError(err) {
		if ans == 'y' || ans == 'Y' {
			start()
		}
	}
}

//
func run(v venom, toWrite bool, payloadType string) {
	cmd := exec.Command(
		"msfvenom",
		"--help",
	)

	cmd.Stdin, cmd.Stdout = os.Stdin, os.Stdout
	err := cmd.Run()
	if noError(err) {
		fmt.Println(red+bold+"Payloaded successfully generated!", reset)
	}

}

// checkError simply takes in an error and
// determines if an error occured performing
// a particular operation.
func noError(e error) bool {
	if e != nil {
		fmt.Println(red, e, reset)
		os.Exit(0)
	}
	return true
}
