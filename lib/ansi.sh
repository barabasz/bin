#!/bin/zsh
#
# ANSI escape code warper
#
# Usage: 
#   ansi <style> <background> <foreground>
#   ansi reset [option]
# Style:
#   style:                    ansi <style>
# Background:
#   color:                    ansi bg <color>
#   8-bit color:              ansi bg 8bit {0..255}
#   rgb color:                ansi bg rgb {0..255} {0..255} {0..255}
#   default color:            ansi bg default
# Foreground:
#   color:                    ansi <color>
#   bright color:             ansi bright <color>
#   8-bit color:              ansi 8bit {0..255}
#   rgb color:                ansi rgb {0..255} {0..255} {0..255}
#   default color:            ansi default
# Reset:
#   reset style:              ansi reset <style>
#   reset all:                ansi reset
# Colors:
#   black      red             yellow
#   white      green           magenta = purple
#   default    blue            cyan
# Styles:
#   bold       underline        dim
#   italic     strikethrough    blink
#   reverse    overline         invisible
# Examples:
#   printf "$(ansi bold red)bold red$(ansi reset) reset"
#   echo "$(ansi yellow)yellow $(ansi reverse)reverse$(ansi reset reverse) normal$(ansi default) default"
#
# SGR (Select Graphic Rendition) parameters of ANSI escape codes
# man: https://man7.org/linux/man-pages/man4/console_codes.4.html

ansi::example() {
    echo "Styles:"
    echo "  • $(ansi bold)bold$(ansi reset bold)"
    echo "  • $(ansi italic)italic$(ansi reset italic)"
    echo "  • $(ansi reverse)reverse$(ansi reset reverse)"
    echo "  • $(ansi underline)underline$(ansi reset underline)"
    echo "  • $(ansi strikethrough)strikethrough$(ansi reset strikethrough)"
    echo "  • $(ansi overline)overline$(ansi reset overline)"
    echo "  • $(ansi dim)dim$(ansi reset dim)"
    echo "  • $(ansi blink)blink$(ansi reset blink)"
    echo "  • $(ansi invisible)red$(ansi reset invisible) (invisible)"
    echo "Foreground:"
    echo "  • $(ansi red)red$(ansi default)"
    echo "  • $(ansi bright red)bright red $(ansi default)"
    echo "  • $(ansi 8bit 196)8bit 196$(ansi default)"
    echo "  • $(ansi rgb 255 0 0)rgb 255 0 0$(ansi default)"
    echo "Background:"
    echo "  • $(ansi bg red)bg red$(ansi bg default)"
    echo "  • $(ansi bg 8bit 196)bg 8bit 196$(ansi bg default)"
    echo "  • $(ansi bg rgb 255 0 0)bg rgb 255 0 0$(ansi bg default)"
    echo "Compound expression:"
    echo "  • $(ansi bg rgb 0 255 0 red)bg rgb 0 255 red$(ansi reset)"
    echo "  • $(ansi bold yellow)bold yellow$(ansi reset)"
    echo "  • $(ansi italic cyan)italic cyan $(ansi reset)"
}

ansi::style() {
    case "$@" in
        regular*) mod=0 ;;
        bold*) mod=1 ;;
        dim*) mod=2 ;;
        italic*) mod=3 ;;
        underline*) mod=4 ;;
        dunderline*) mod=21 ;;
        blink*) mod=5 ;;
        fastblink*) mod=6 ;;
        reverse*) mod=7 ;;
        invisible*) mod=8 ;;
        strikethrough*) mod=9 ;;
        overline*) mod=53 ;;
    esac
}

ansi::reset() {
    mod=0
    case "$@" in
        bold*) mod=22 ;;
        dim*) mod=22 ;;
        italic*) mod=23 ;;
        underline*) mod=24 ;;
        blink*) mod=25 ;;
        fastblink*) mod=26 ;;
        reverse*) mod=27 ;;
        invisible*) mod=28 ;;
        strikethrough*) mod=29 ;;
        overline*) mod=55 ;;
    esac
}

# foreground colors {30..37}
ansi::foreground() {
    shift=1
    case "$@" in
        black*) color=30 ;;
        red*) color=31 ;;
        green*) color=32 ;;
        yellow*) color=33 ;;
        blue*) color=34 ;;
        magenta*) color=35 ;;
        purple*) color=35 ;;
        cyan*) color=36 ;;
        white*) color=37 ;;
        default*) color=39 ;;
        gray*) color=90 ;;
        rgb*) color="38;2;$2;$3;$4"; shift=4 ;;
        8bit*) color="38;5;$2"; shift=2 ;;
    esac
}

# background colors {40..47}
ansi::background() {
    shift=1
    case "$@" in
        black*) bcolor=40 ;;
        red*) bcolor=41 ;;
        green*) bcolor=42 ;;
        yellow*) bcolor=43 ;;
        blue*) bcolor=44 ;;
        magenta*) bcolor=45 ;;
        purple*) bcolor=45 ;;
        cyan*) bcolor=46 ;;
        white*) bcolor=47 ;;
        default*) bcolor=49 ;;
        rgb*) bcolor="48;2;$2;$3;$4"; shift=4 ;;
        8bit*) bcolor="48;5;$2"; shift=2 ;;
    esac
}

# foreground bright colors {90..97}
ansi::bright() {
    case "$@" in
        black*) color=90 ;;
        red*) color=91 ;;
        green*) color=92 ;;
        yellow*) color=93 ;;
        blue*) color=94 ;;
        magenta*) color=95 ;;
        purple*) color=95 ;;
        cyan*) color=96 ;;
        white*) color=97 ;;
    esac
}

ansi::code() {
    prefix="\e["
    mod=${mod:+$mod}
    s1=${mod:+${${color:-${bcolor:+;}}:+;}}
    bcolor=${bcolor:+$bcolor}
    s2=${color:+${bcolor:+;}}
    color=${color:+$color}
    sufix="m"
    echo "${prefix}${mod}$s1${bcolor}$s2${color}$sufix"
}

ansi::make() {

    # styles
    if [[ "$*" == "reset"* ]]; then
        shift
        ansi::reset $@
        if (( $mod > 0 )); then shift; fi
    else
        ansi::style $@
        if [[ -v mod ]]; then shift; fi
    fi
    # backgrouund
    if [[ "$*" == "bg"* ]]; then
        shift
        ansi::background $@
        shift $#
    fi
    # foreground
    if [[ "$*" == "bright"* ]]; then
        shift
        ansi::bright $@
        shift
    else
        ansi::foreground $@
        shift $shift
    fi
    ansi::code
}

ansi() {
    ansi::make "$@ tail tail tail"
    ansi::code
}
