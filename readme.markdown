

file_list=`xcodebuild -project "$PROJECT_FILE_PATH" -target "$TARGET_NAME" -sdk "$SDKROOT" -configuration "$CONFIGURATION" -showBuildSettings | grep "LINK_FILE_LIST_"$BUILD_VARIANTS"_"$NATIVE_ARCH | sed s/[^=]*\=\ //`
touch $file_list