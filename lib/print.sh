#!/bin/zsh

# Print library

# Print yellow header
function printh() {
    output="\n${yellowb}"$*"${reset}\n"
    printf "$output"
}

# Print red error
function printe() {
    output="${redb}"$*"${reset}\n"
    printf "$output"
}

# Print cyan info
function printc() {
    output="${cyani}"$*"${reset}\n"
    printf "$output"
}

# Print blue info
function printb() {
    output="${bluei}"$*"${reset}\n"
    printf "$output"
}

# Print green info
function printi() {
    output="${greeni}"$*"${reset}\n"
    printf "$output"
}

# Print purple info
function printp() {
    output="${purplei}"$*"${reset}\n"
    printf "$output"
}

# Print white info
function printw() {
    output="${whitei}"$*"${reset}\n"
    printf "$output"
}

# Print red info
function printr() {
    output="${redi}"$*"${reset}\n"
    printf "$output"
}

# Print yellow info
function printy() {
    output="${yellowi}"$*"${reset}\n"
    printf "$output"
}

alias printhead=printh
alias printinfo=printi
