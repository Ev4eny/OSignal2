#!/bin/bash
set -e

WORKING_DIR=$(pwd)

FRAMEWORK_FOLDER_NAME="OneSignal_XCFramework"

FRAMEWORK_NAME="OneSignal"

FRAMEWORK_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/${FRAMEWORK_NAME}.xcframework"

BUILD_SCHEME="OneSignalFramework"

SIMULATOR_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/simulator.xcarchive"

IOS_DEVICE_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/iOS.xcarchive"

CATALYST_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/catalyst.xcarchive"

rm -rf "${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}"
echo "Deleted ${FRAMEWORK_FOLDER_NAME}"
mkdir "${FRAMEWORK_FOLDER_NAME}"
echo "Created ${FRAMEWORK_FOLDER_NAME}"
echo "Archiving ${FRAMEWORK_NAME}"

xcodebuild archive ONLY_ACTIVE_ARCH=NO -scheme ${BUILD_SCHEME} -destination="generic/platform=iOS Simulator" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme ${BUILD_SCHEME} -destination="generic/platform=iOS" -archivePath "${IOS_DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme ${BUILD_SCHEME} -destination='generic/platform=macOS,variant=Mac Catalyst' -archivePath "${CATALYST_ARCHIVE_PATH}" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${CATALYST_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -output "${FRAMEWORK_PATH}"

rm -rf "${SIMULATOR_ARCHIVE_PATH}"
rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"
rm -rf "${CATALYST_ARCHIVE_PATH}"
open "${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}"
