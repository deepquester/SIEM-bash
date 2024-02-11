#!/bin/bash

function convert_to_gb() {
    input=$1
    limit=
    if [[ $2 ]]; then
        limit=$2
    else
        limit=20
    fi
    unit=$(echo $input | sed -n -E 's/([0-9.]+)([BbKkMmGgTtPpEeZzYy])?.?/\2/p' | tr '[:lower:]' '[:upper:]')

    case $unit in
        B) factor=1e-12 ;;
        K) factor=1e-9 ;;
        M) factor=1e-6 ;;
        G) factor=1e-3 ;;
        T) factor=1 ;;
        P) factor=1e3 ;;
        E) factor=1e6 ;;
        Z) factor=1e9 ;;
        Y) factor=1e12 ;;
        *) factor=0 ;;  # Default case for gigabytes
    esac

    if [ "$factor" != "0" ]; then
        result=$(echo "$input" | sed -E "s/([0-9.]+)([BbKkMmGgTtPpEeZzYy])?B?/\1/" | awk "{printf \"%."$limit"f\", \$1 * $factor}")
        echo "$result"
    else
        return 0
    fi
}

export -f convert_to_gb