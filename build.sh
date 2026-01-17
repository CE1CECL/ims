#!/bin/bash

set -x

if [ -z "$ANDROID_HOME" ];then
export ANDROID_HOME=/usr/lib/android-sdk
fi

zip -d $ANDROID_HOME/platforms/android-33/android.jar android/telephony/ims/feature/MmTelFeature.class android/telephony/ims/feature/MmTelFeature\$MmTelCapabilities.class

gradleTarget=assembleDebug
target=debug
file=app-debug
if [ "$1" == "release" ]; then
gradleTarget=assembleRelease
target=release
file=app-release-unsigned
fi
./gradlew $gradleTarget
LD_LIBRARY_PATH=./signapk/ java -jar signapk/signapk.jar keys/platform.x509.pem keys/platform.pk8 ./app/build/outputs/apk/$target/${file}.apk app.apk
