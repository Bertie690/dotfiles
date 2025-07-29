#!/usr/bin/env bash
## Logging utilities for bootstrap.sh

# Make text orange.
orange () {
    printf "\e[33m%s\e[0m" "$1"
}

# Make text red.
red () {
    printf "\e[31m%s\e[0m" "$1"
}

# Make text green.
green () {
    printf "\e[32m%s\e[0m" "$1"
}

# Make text blue.
blue () {
    printf "\e[34m%s\e[0m" "$1"
}

# Annotate text with a blue [...].
info () {
    printf "[$(blue ...)] %s\n" "$1"
}

# Annotate text with a green [✔].
success () {
    printf "[$(green '✔ ')] %s\n" "$1"
}

# Annotate text with a blue [???].
user () {
    printf "[$(orange '???')] %s\n" "$1"
}

# Annotate text with a red [✗].
error () {
	printf "[ $(red '✗') ] %s\n" "$1"
}

# Log error text and exit the program.
quit () {
    error "$1"
	exit 1
}