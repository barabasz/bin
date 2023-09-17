#!/bin/zsh
#
# ANSI escape code warper
#
# Usage: 
#   style:                    ansi <style>
#
#   color:                    ansi <color>
#   bright color:             ansi bright <color>
#   8-bit color:              ansi 8bit {0..255}
#   rgb color:                ansi rgb {0..255} {0..255} {0..255}
#   default color:            ansi default
#
#   background color:         ansi bg <color>
#   background 8-bit color:   ansi bg 8bit {0..255}
#   background rgb color:     ansi bg rgb {0..255} {0..255} {0..255}
#   background default color: ansi bg default
#
#   reset style:              ansi reset <style>
#   reset color:              ansi reset color
#   reset background color:   ansi reset bg
#   reset all:                ansi reset
# colors and styles can be combined, e.g.:
#   style and color:          ansi <style> <color>
#
# Colors:
#   black         red         yellow
#   white         green       magenta = purple
#   default       blue        cyan
#
# Styles
#   - bold
#   - dim
#   - italic
#   - underline
#   - blink
#   - fastblink
#   - reverse
#   - invisible
#   - strikethrough
#   - overline
#
# Example:
#   printf "$(ansi red bold)some red bold text$(ansi reset)"
#
# SGR (Select Graphic Rendition) parameters of ANSI escape codes
# man: https://man7.org/linux/man-pages/man4/console_codes.4.html

ansi() {
    local color=-1
    local mod=-1
    local bg=false
    local cm=1      # color mode: 1 - name, 2 - rgb, 3 - 8bit 256 colors

    # styles
    case "$@" in
        # unset
        *reset*)
            case "$@" in
                *color*) color=39 ;;
                *bold*) mod=22 ;;
                *dim*) mod=22 ;;
                *italic*) mod=23 ;;
                *underline*) mod=24 ;;
                *blink*) mod=25 ;;
                *fastblink*) mod=26 ;;
                *reverse*) mod=27 ;;
                *invisible*) mod=28 ;;
                *strikethrough*) mod=29 ;;
                *overline*) mod=55 ;;
                *) echo "\e[0m"; return 0
            esac
        ;;
        # set
        *regular*) mod=0 ;;
        *bold*) mod=1 ;;
        *dim*) mod=2 ;;
        *italic*) mod=3 ;;
        *underline*) mod=4 ;;
        *dunderline*) mod=21 ;;
        *blink*) mod=5 ;;
        *fastblink*) mod=6 ;;
        *reverse*) mod=7 ;;
        *invisible*) mod=8 ;;
        *strikethrough*) mod=9 ;;
        *overline*) mod=53 ;;
    esac

    if (( $mod > -1 )); then
        shift
    fi

    # colors
    case "$@" in
        # background color {100..107}
        *bg*)
            bg=true
            shift
            case "$@" in
                *black*) color=40 ;;
                *red*) color=41 ;;
                *green*) color=42 ;;
                *yellow*) color=43 ;;
                *blue*) color=44 ;;
                *magenta*) color=45 ;;
                *purple*) color=45 ;;
                *cyan*) color=46 ;;
                *white*) color=47 ;;
                *rgb*) cm=2 color=48 ;;
                *8bit*) cm=5 color=48 ;;
                *default*) color=49 ;;
            esac
        ;;
        # foreground bright colors {90..97}
        *bright*)
            case "$@" in
                *black*) color=90 ;;
                *red*) color=91 ;;
                *green*) color=92 ;;
                *yellow*) color=93 ;;
                *blue*) color=94 ;;
                *magenta*) color=95 ;;
                *purple*) color=95 ;;
                *cyan*) color=96 ;;
                *white*) color=97 ;;
            esac
        ;;
        # foreground colors {30..37}
        *black*) color=30 ;;
        *red*) color=31 ;;
        *green*) color=32 ;;
        *yellow*) color=33 ;;
        *blue*) color=34 ;;
        *magenta*) color=35 ;;
        *purple*) color=35 ;;
        *cyan*) color=36 ;;
        *white*) color=37 ;;
        *rgb*) cm=2 color=38 ;;
        *8bit*) cm=5 color=38 ;;
        *default*) color=39 ;;
        *gray*) color=90 ;;
    esac

    if (( $color > -1 )); then
        shift
    fi

    code="\e["
    if (( $mod > -1 )); then
        code="$code$mod;"
    fi

    if (( $color > -1 )); then
        if $bg; then
            if (( $cm == 5 )); then
                code="${code}48;5;$1"
            elif (( $cm == 2 )); then
                code="${code}48;2;$1;$2;$3"
            else
                code="${code}${color}"
            fi
        else
            if (( $cm == 5 )); then
                code="${code}38;5;$1"
            elif (( $cm == 2 )); then
                code="${code}38;2;$1;$2;$3"
            else
                code="${code}${color}"
            fi
        fi
    fi

    echo "${code}m"

}
