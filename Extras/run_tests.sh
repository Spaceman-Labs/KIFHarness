#!/bin/bash

# disallow undefined vars
set -u

usage ()
{
    cat >&2 <<EOF
Usage: ${0##*/} [-v] [-w /path/to/waxsim] [-o /output/path.txt] /path/to/application.app
EOF
}

verbose="NO"
waxSimPath=`which waxsim`
outputPath="/tmp/KIF-$$.out"

while getopts "vw:o:" o; do 
    case "$o" in
        v ) verbose="YES" ;;
        w ) waxSimPath="$OPTARG" ;;
        o ) outputPath="$OPTARG" ;;
        * ) usage ; exit 1 ;;
    esac
done
shift $(($OPTIND-1))

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

failwith () {
    echo "$1"
    exit 1
}

if [ ! -f "$waxSimPath" ]; then
	echo "Error: WaxSim does not exist at the provided path.";
	exit 1
fi

if [ $verbose == "YES" ]; then
	echo "Using WaxSim at path: $waxSimPath"
fi

if [ $verbose == "YES" ]; then
	echo "Writing results to file at path: $outputPath"
fi

if [ $verbose == "YES" ]; then
	echo "Kill running instances of the simulator."
fi

if [ $verbose == "YES" ]; then
	echo "Running WaxSim."
fi

# set -o errexit
# set -o verbose

`$waxSimPath -f "iphone" "$1" > $outputPath 2>&1`

# WaxSim hides the return value from the app, so to determine success we search for a "no failures" line
failCount=`grep -o "TESTING FINISHED: \([\1-9]*\) failures" $outputPath | sed "s/[^0-9]//g"`
if [ $verbose == "YES" ]; then
	echo "Failures: $failCount"
fi

if [ noFailsCount!="0" ]; then
	exit 1
else
	exit 0
fi

