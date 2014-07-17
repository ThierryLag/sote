#!/bin/bash
###################################
# sote                            #
# https://github.com/leny/sote    #
#                                 #
# Copyright (c) 2014 leny         #
# Licensed under the MIT license. #
###################################

sote() {

    # sote vars

    local version=0.0.1
    local store="$HOME/.sote"

    # regular colors

    local K="\033[0;30m"    # black
    local R="\033[0;31m"    # red
    local G="\033[0;32m"    # green
    local Y="\033[0;33m"    # yellow
    local B="\033[0;34m"    # blue
    local M="\033[0;35m"    # magenta
    local C="\033[0;36m"    # cyan
    local W="\033[0;37m"    # white

    # emphasized (bolded) colors

    local EMK="\033[1;30m"
    local EMR="\033[1;31m"
    local EMG="\033[1;32m"
    local EMY="\033[1;33m"
    local EMB="\033[1;34m"
    local EMM="\033[1;35m"
    local EMC="\033[1;36m"
    local EMW="\033[1;37m"

    # usage text

    local usage="
    ${EMW}Usage: ${Y}sote ${G}[options] ${C}[command]

    ${EMC}Commands:

        ${C}list                   ${W}Lists the paths stored by sote.
        ${C}show ${B}<name>            ${W}Shows the path corresponding to the given name.
        ${C}add ${B}<name> ${G}[path]      ${W}Add the path to the store with the given name. If no path is given, use current path.
        ${C}remove ${B}<name>          ${W}Remove the path stored by sote at the given name.
        ${C}clear                  ${W}Clear all the paths stored by sote. Ask for confirmation before acting.
        ${C}*                      ${W}Jumps to the path corresponding to the given name.

    ${EMG}Options:

        ${G}-h      ${W}output usage information
        ${G}-V      ${W}output the version number
    "


    # Check for git

    command -v git >/dev/null 2>&1 || { echo "sote requires git but it's not installed. Aborting." >&2; return 1; }

    # Check for store file

    if [ ! -f $store ]
    then
        echo "" > $store
    fi

    # Show help if no args

    if [ $# == 0 ] ; then
        echo -e "$usage"
        return;
    fi

    # Commands

    action=$1
    arg1=$2
    arg2=$3

    case "$action" in
        "-v")
            echo -e "${Y}sote ${W}v$version"
            return;
            ;;
        "--version")
            echo -e "${Y}sote ${W}v$version"
            return;
            ;;
        "-h")
            echo -e "$usage"
            return;
            ;;
        "--help")
            echo -e "$usage"
            return;
            ;;
        "list")
            # TODO : parse & show
            git config --file $store --list
            return;
            ;;
        "show")
            git config --file $store --get "store.$arg1"
            return;
            ;;
        "add")
            git config --file $store --replace-all "store.$arg1" $arg2
            return;
            ;;
        "remove")
            git config --file $store --unset-all "store.$arg1"
            return;
            ;;
        "clear")
            echo "" > $store
            return;
            ;;
        *)
            path=$( git config --file $store --get "store.$action" )
            cd $path
            return;
            ;;
    esac
}
