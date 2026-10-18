#!/usr/bin/env bash==============================================================================Script:       extract-payload.shDescription:  Automates extraction of boot/recovery kernels from payload.binTarget:       Ubuntu Linux / LineageOS Deployments==============================================================================set -euo pipefailTARGET_ZIP="${1:-lineage20.zip}"
WORKDIR="${HOME}/mia1_flash"echo "[*] Initializing extraction environment..."
cd "${WORKDIR}"if [[ ! -f "${TARGET_ZIP}" ]]; then
echo "[-] Error: Source archive ${TARGET_ZIP} not found!" >&2
exit 1
fiecho "[*] Checking for payload_dumper utility..."
if ! command -v payload_dumper &>/dev/null && [[ ! -f "${HOME}/.local/bin/payload_dumper" ]]; then
echo "[+] Installing payload_dumper via host override..."
pip3 install payload_dumper --break-system-packages
fiDUMPER_BIN="$(command -v payload_dumper || echo "${HOME}/.local/bin/payload_dumper")"echo "[*] Extracting payload.bin container..."
unzip -p "${TARGET_ZIP}" payload.bin > payload.binecho "[*] Dumping boot partition..."
"${DUMPER_BIN}" --partitions boot payload.bincp output/boot.img lineage_boot.img
rm -rf output payload.binecho "[✔] Success: lineage_boot.img ready for deployment."
ls -lh lineage_boot.img
