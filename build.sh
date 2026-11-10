#!/usr/bin/env bash
# Compila el APK sin Gradle: aapt2 + javac + d8 + apksigner
set -euo pipefail
cd "$(dirname "$0")"
SDK=${ANDROID_HOME:-$HOME/android-sdk}
BT=$SDK/build-tools/36.0.0
JAR=$SDK/platforms/android-34/android.jar
rm -rf build && mkdir -p build/res build/classes build/dex
$BT/aapt2 compile --dir res -o build/res/res.zip
$BT/aapt2 link -o build/base.apk -I $JAR --manifest AndroidManifest.xml -A assets build/res/res.zip --java build/gen
javac --release 11 -classpath $JAR -d build/classes $(find src build/gen -name '*.java') 2>&1 | grep -v "^warning\|^1 warning" || true
$BT/d8 --min-api 24 --lib $JAR --output build/dex $(find build/classes -name '*.class')
cp build/base.apk build/unsigned.apk
(cd build/dex && zip -q -u ../unsigned.apk classes.dex)
$BT/zipalign -f -p 4 build/unsigned.apk build/aligned.apk
[ -f release.keystore ] || keytool -genkeypair -keystore release.keystore -storepass semana123 -keypass semana123 \
  -alias semana -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Cube Project" >/dev/null 2>&1
$BT/apksigner sign --ks release.keystore --ks-pass pass:semana123 --ks-key-alias semana --out Semana.apk build/aligned.apk
$BT/apksigner verify Semana.apk && ls -la Semana.apk
