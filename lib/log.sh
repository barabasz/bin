#!/bin/zsh

source ~/lib/ansi.sh

# signs
hs='─' # header
ss='✔' # success
es='✖' # error
ws='▴' # warning
ns='❢' # note

# colors
hc='cyan'    # header
sc='green'   # success
ec='red'     # error
wc='yellow'  # warning
nc='magenta' # note

log::err() {
    echo "$@" 1>&2
}

log::line() {
    local TOTAL_CHARS=60
    local total=$TOTAL_CHARS-2
    local size=${#1}
    local left=$((($total - $size) / 2))
    local right=$(($total - $size - $left))
    printf "%${left}s" '' | tr ' ' $hs
    printf " $1 "
    printf "%${right}s" '' | tr ' ' $hs
}

log::log() {
    local template="$1"
    shift
    log::err "$(printf "$template" "$@")"
}

log::header() { log::log "\n$(ansi bold $hc)$(log::line "$1")$(ansi reset)\n"; }
log::success() {log::log "$(ansi $sc)$ss %s$(ansi reset)\n" "$@"; }
log::error() { log::log "$(ansi bold $ec)$es %s$(ansi reset)\n" "$@"; }
log::warning() { log::log "$(ansi $wc)$ws %s$(ansi reset)\n" "$@"; }
log::note() { log::log "$(ansi $nc)$ns $@$(ansi reset)\n"; }