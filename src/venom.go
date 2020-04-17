/*
Author: Alexis Rodriguez
Date: 10 April 2020

This programs makes the payload generation process
with Msfvenom simpler and user-friendly.
*/

package main

import (
	"fmt"
	"os/exec"
	"strconv"
)

// Ansicolors
const (
	reset  string = "\x1b[0m"
	bold   string = "\x1b[1m"
	red    string = "\x1b[31m"
	blue   string = "\x1b[34m"
	yellow string = "\x1b[33m"
	green  string = "\x1b[32m"
)

// venomOptions is a struct containing
// most of the options provided by
// msfvenom and each can be further understood
// by reading the explanations present
// in msfvenom's help menu.
type venomOpts struct {
	targetIP      string
	targetPort    int
	hostIP        string
	hostPort      int
	payload       string
	encoder       string
	architecture  string
	badCharacters string
	format        string
  output        string
}

func run(v venomOpts, b bool) {
  if !b {
    results, err := exec.Command(
                      "msfvenom",
                      v.targetIP,
                      strconv.Itoa(v.targetPort),
                      v.hostIP,
                      "LPORT="+strconv.Itoa(v.hostPort),
                      "-p",
                      v.payload).Output()
    if err != nil {
      fmt.Println(err)
    } else {
      fmt.Println(string(results))
    }
  } else {
    results, err := exec.Command(
                      "msfvenom",
                      v.targetIP,
                      strconv.Itoa(v.targetPort),
                      v.hostIP,
                      strconv.Itoa(v.hostPort)).Output()
    if err != nil {
      fmt.Println(err)
    } else {
      fmt.Println(string(results))
    }
  }
}
