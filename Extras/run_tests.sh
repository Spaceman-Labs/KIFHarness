#!/bin/bash

# disallow undefined vars
set -u

usage ()
{
    cat >&2 <<EOF
Usage: ${0##*/} [-vd] [-w /path/to/waxsim] [-o output_path] [-j junit_results_path] /path/to/application.app
EOF
}

verbose="NO"
waxSimPath=`which waxsim`
outputPath="/tmp/KIF-$$.out"
junitPath=""

while getopts "vw:o:j:" o; do 
    case "$o" in
        v ) verbose="YES" ;;
        w ) waxSimPath="$OPTARG" ;;
        o ) outputPath="$OPTARG" ;;
        j ) junitPath="$OPTARG" ;;
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
	echo "Writing output to: $outputPath"
fi

if [ "$junitPath" != "" ]; then
	if [ $verbose == "YES" ]; then
		echo "Writing JUnit results to: $junitPath"
	fi
	
	export KIFHarnessJUnitPath="$junitPath"
	echo "env xxxx"
	echo `env | grep KIFHarnessJUnitPath`
	echo "env xxxx"
	
fi


if [ $verbose == "YES" ]; then
	echo "Kill running instances of the simulator."
fi

if [ $verbose == "YES" ]; then
	echo "Running WaxSim."
fi

# set -o errexit
# set -o verbose

`$waxSimPath -f "iphone" "$1" -e KIFHarnessJUnitPath="/users/jerryhjones/desktop/wtf" > $outputPath 2>&1`

# WaxSim hides the return value from the app, so to determine success we search for a "no failures" line
failCount=`grep -o "TESTING FINISHED: \([\1-9]*\) failures" $outputPath | sed "s/[^0-9]//g"`
junitFile=`grep "JUNIT XML RESULTS AT " /Users/jerryhjones/Desktop/tests-results.txt | sed "s/.*JUNIT XML RESULTS AT //"`

if [ $verbose == "YES" ]; then
	echo "Failures: $failCount"
fi

if [ -f "$junitFile" ]; then
	echo "Moving JUnit results to: $junitPath"
	mv "$junitFile" "$junitPath"
fi

if [ noFailsCount!="0" ]; then
	exit 1
else
	exit 0
fi

