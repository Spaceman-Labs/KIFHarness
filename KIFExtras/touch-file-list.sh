#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

Uses the current build environment settings from the Xcode workspaceto touch the link file lists. If you are not using workspaces, use the -p flag.

OPTIONS:
   -h      Show this message
   -p      Use Project configuration varaibles
EOF
}

PROJECT=
while getopts “hp” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         p)
             PROJECT=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done
	
if [[ -z $SDKROOT ]]; then
	echo "Error: No value found for \$SDKROOT\". \nThis generally means you are not running this script via an Xcode pre-action, or forgot to provide the build settings in the Run Script action."
	exit 1
fi

echo "\n********* Attempting to touch Link File Lists matching: LINK_FILE_LIST_"$BUILD_VARIANTS"_"$NATIVE_ARCH" *********\n"

OUTPUT=
if [[ -z $PROJECT ]]; then
	echo "Using WORKSPACE: $WORKSPACE_PATH"
	OUTPUT=`xcodebuild -workspace "$WORKSPACE_PATH" -scheme "$SCHEME_NAME" -sdk "$SDKROOT" -configuration $CONFIGURATION -showBuildSettings | grep "LINK_FILE_LIST_"$BUILD_VARIANTS"_"$NATIVE_ARCH | sed s/[^=]*\=\ //`
else
	echo "Using PROJECT: $PROJECT_FILE_PATH"
	OUTPUT=`xcodebuild -project "$PROJECT_FILE_PATH" -target "$TARGET_NAME" -sdk "$SDKROOT" -configuration $CONFIGURATION -showBuildSettings | grep "LINK_FILE_LIST_"$BUILD_VARIANTS"_"$NATIVE_ARCH | sed s/[^=]*\=\ //`
fi

echo "$OUTPUT" | while read a; do
    echo "Trying to touch: $a"
    if [ -e "$a" ]; then
        touch $a
        echo -e "\tTouched\n"
    else
        echo "\tNo File\n"
    fi
done

echo "\n*************************** Done trying to touch Link File Lists ******************************\n"