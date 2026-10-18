#!/usr/bin/env bash==============================================================================Script:       deploy-apps.shDescription:  Headless batch installation of APKs via ADBTarget:       De-Googled / CLI Managed Android Deployments==============================================================================set -euo pipefailAPK_DIR="${1:-./packages}"echo "[*] Waiting for target device to be authorized via ADB..."
adb wait-for-deviceif [[ ! -d "${APK_DIR}" ]]; then
echo "[-] Error: Package directory ${APK_DIR} does not exist!" >&2
exit 1
fishopt -s nullglob
APK_LIST=("${APK_DIR}"/*.apk)
shopt -u nullglobif [[ ${#APK_LIST[@]} -eq 0 ]]; then
echo "[-] Warning: No .apk packages discovered in ${APK_DIR}."
exit 0
fiecho "[*] Beginning batch installation of ${#APK_LIST[@]} application(s)..."for package in "${APK_LIST[@]}"; do
pkg_name="$(basename "${package}")"
echo -n "  -> Installing [${pkg_name}]... "
if adb install -r -d "${package}" &>/dev/null; then
echo "SUCCESS"
else
echo "FAILED" >&2
fi
doneecho "[✔] Application provisioning cycle complete."
