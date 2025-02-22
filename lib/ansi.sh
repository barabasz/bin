#!/bin/zsh
#
# ANSI escape code warper
#
# SGR (Select Graphic Rendition) parameters of ANSI escape codes
# man: https://man7.org/linux/man-pages/man4/console_codes.4.html

ansi::info() {
    \cat << EOF
$(ansi bold yellow)ANSI escape code warper$(ansi reset)

$(ansi bold)Usage$(ansi reset): 
  $(ansi yellow)ansi$(ansi reset) help                 show help
  $(ansi yellow)ansi$(ansi reset) info                 show this info
  $(ansi yellow)ansi$(ansi reset) example              show examples
  $(ansi yellow)ansi$(ansi reset) <style>              set style
  $(ansi yellow)ansi$(ansi reset) <foreground>         set foreground color
  $(ansi yellow)ansi$(ansi reset) bg <background>      set background color
  $(ansi yellow)ansi$(ansi reset) reset [option]       reset style
  $(ansi yellow)ansi$(ansi reset) show <command>       only show ANSI code

EOF
}

ansi::help() {
    ansi::info
    \cat << EOF
$(ansi bold)Expected arguments order$(ansi reset):
  $(ansi yellow)ansi$(ansi reset) [style] [[bright] <foreground>] [bg <background>] [reset [style]]

$(ansi bold)Style$(ansi reset):
  style:                    ansi $(ansi bold purple)<style>$(ansi reset)

$(ansi bold)Foreground$(ansi reset):
  color:                    $(echo "\e[33mansi\e[39m") $(ansi bold cyan)<color>$(ansi reset)
  bright color:             $(echo "\e[33mansi\e[39m") bright $(ansi bold cyan)<color>$(ansi reset)
  8-bit color:              $(echo "\e[33mansi\e[39m") 8bit {0..255}
  rgb color:                $(echo "\e[33mansi\e[39m") rgb {0..255} {0..255} {0..255}
  default color:            $(echo "\e[33mansi\e[39m") default

$(ansi bold)Background$(ansi reset):
  color:                    $(echo "\e[33mansi\e[39m") bg $(ansi bold cyan)<color>$(ansi reset)
  8-bit color:              $(echo "\e[33mansi\e[39m") bg 8bit {0..255}
  rgb color:                $(echo "\e[33mansi\e[39m") bg rgb {0..255} {0..255} {0..255}
  default color:            $(echo "\e[33mansi\e[39m") bg default

$(ansi bold)Reset$(ansi reset):
  reset style:              $(echo "\e[33mansi\e[39m") reset $(ansi bold purple)<style>$(ansi reset)
  reset all:                $(echo "\e[33mansi\e[39m") reset

$(ansi bold cyan)Colors$(ansi reset):
  black     red     yellow
  white     green   magenta = purple
  default   blue    cyan

$(ansi bold purple)Styles$(ansi reset):
  bold      underline      dim
  italic    strikethrough  blink
  reverse   overline       invisible

$(ansi bold)Examples$(ansi reset):
  printf "\$(ansi bold red)bold red\$(ansi reset) reset"
  echo "\$(ansi yellow)yellow \$(ansi reverse)reverse\$(ansi reset reverse) normal\$(ansi default) default"

EOF
}

ansi::example() {
    ansi::info
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
    echo "  • $(ansi default)default$(ansi reset)"
    echo "Foreground:"
    echo "  • $(ansi red)red$(ansi default)"
    echo "  • $(ansi bright red)bright red $(ansi default)"
    echo "  • $(ansi 8bit 196)8bit 196$(ansi default)"
    echo "  • $(ansi rgb 255 0 0)rgb 255 0 0$(ansi default)"
    echo "Background:"
    echo "  • $(ansi bg green)bg green$(ansi bg default)"
    echo "  • $(ansi bg 8bit 196)bg 8bit 196$(ansi bg default)"
    echo "  • $(ansi bg rgb 0 0 255)bg rgb 0 0 255$(ansi bg default)"
    echo "Compound expression:"
    echo "  • $(ansi bold yellow)bold yellow$(ansi reset)"
    echo "  • $(ansi italic cyan)italic cyan $(ansi reset)"
    echo "  • $(ansi bg rgb 0 255 0 red)bg rgb 0 255 red$(ansi reset)"
    echo "  • $(ansi italic yellow bg blue)italic yellow bg blue$(ansi reset)"
}

ansi::style() {
    case "$1" in
        regular) mod=0 ;;
        bold) mod=1 ;;
        dim) mod=2 ;;
        italic) mod=3 ;;
        underline) mod=4 ;;
        dunderline) mod=21 ;;
        blink) mod=5 ;;
        fastblink) mod=6 ;;
        reverse) mod=7 ;;
        invisible) mod=8 ;;
        strikethrough) mod=9 ;;
        overline) mod=53 ;;
    esac
}

ansi::reset() {
    case "$1" in
        all) mod=0 ;;
        bold) mod=22 ;;
        dim) mod=22 ;;
        italic) mod=23 ;;
        underline) mod=24 ;;
        blink) mod=25 ;;
        fastblink) mod=26 ;;
        reverse) mod=27 ;;
        invisible) mod=28 ;;
        strikethrough) mod=29 ;;
        overline) mod=55 ;;
        *) echo "Invalid reset style: $1"; return 1 ;;
    esac
}

# foreground colors {30..37}
ansi::foreground() {
    shift=1
    case "$1" in
        black) color=30 ;;
        red) color=31 ;;
        green) color=32 ;;
        yellow) color=33 ;;
        blue) color=34 ;;
        magenta) color=35 ;;
        purple) color=35 ;;
        cyan) color=36 ;;
        white) color=37 ;;
        rgb) color="38;2;$2;$3;$4"; shift=4 ;;
        8bit) color="38;5;$2"; shift=2 ;;
        default) color=39 ;;
        gray) color=90 ;;
        *) echo "Invalid style or foreground color: $1"; return 1 ;;
    esac
    shift $shift
}

# background colors {40..47}
ansi::background() {
    shift=1
    case "$1" in
        black) bcolor=40 ;;
        red) bcolor=41 ;;
        green) bcolor=42 ;;
        yellow) bcolor=43 ;;
        blue) bcolor=44 ;;
        magenta) bcolor=45 ;;
        purple) bcolor=45 ;;
        cyan) bcolor=46 ;;
        white) bcolor=47 ;;
        default) bcolor=49 ;;
        rgb) bcolor="48;2;$2;$3;$4"; shift=4 ;;
        8bit) bcolor="48;5;$2"; shift=2 ;;
        *) echo "Invalid background color: $1"; return 1 ;;
    esac
}

# foreground bright colors {90..97}
ansi::bright() {
    case "$1" in
        black) color=90 ;;
        red) color=91 ;;
        green) color=92 ;;
        yellow) color=93 ;;
        blue) color=94 ;;
        magenta) color=95 ;;
        purple) color=95 ;;
        cyan) color=96 ;;
        white) color=97 ;;
        *) echo "Invalid bright color name: $1"; return 1 ;;
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
    if [[ $show -eq 1 ]]; then
        echo -n "\\"
        echo "${prefix:1}${mod}$s1${bcolor}$s2${color}$sufix"
    else
        echo -n "${prefix}${mod}$s1${bcolor}$s2${color}$sufix"
    fi
}

ansi::make() {
    # reset
    if [[ "$*" == "reset"* ]]; then
        shift
        if (( $# == 0 )); then
            ansi::reset all
        else
            ansi::reset $1
            shift
        fi
    fi
    # set style or color
    if (( $# > 0 )); then
        # style
        ansi::style $@
        if [[ -n $mod ]]; then
            shift
        fi

        # background
        if [[ "$*" == "bg"* ]]; then
            if [[ $# -eq 1 ]]; then
                echo "Missing background color name"
                return 1
            fi
            shift
            ansi::background $@ || return 1
            shift $shift
            unset shift
        fi 

        # foreground
        if [[ "$*" == "bright"* ]]; then
            if [[ $# -eq 1 ]]; then
                echo "Missing bright color name"
                return 1
            fi
            shift
            ansi::bright $@ || return 1
            shift
        else
            if [[ $# -gt 0 ]]; then
                ansi::foreground $@ || return 1
                shift $shift
                unset shift
            fi
        fi
 
        # background again (when set with foreground)
        if [[ "$*" == "bg"* ]]; then
            if [[ $# -eq 1 ]]; then
                echo "Missing background color name"
                return 1
            fi
            shift
            ansi::background $@
            shift $shift
            unset shift
        fi 

        if (( $# > 0 )); then
            echo "Too many arguments: $@"
            return 1
        fi
    fi
}

ansi() {
    unset mod color bcolor show shift
    if [[ $# == 0 ]]; then
        ansi::info
        return 0
    elif [[ "$1" == "help" ]]; then
        ansi::help
        return 0
    elif [[ "$1" == "example" ]]; then
        ansi::example
        return 0
    elif [[ "$1" == "show" ]]; then
        show=1
        shift
    fi
    ansi::make "$@" || return 1
    ansi::code
}   