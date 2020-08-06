#!/usr/bin/env bash
# define variables
JQ_URL='https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64'
TMPDIR="$(mktemp -d)"
OUTPUT="/Library/Application Support/dt/caldigitversion.txt"

# check for resource directory, make it if needed
if [ ! -d "/Library/Application Support/dt" ] 
then
    echo "Error: Directory Library/Application Support/dt does not exist."
    mkdir "/Library/Application Support/dt/"
else
    echo "/Library/Application Support/dt/ already exists."
fi

# create the file for output
touch "$OUTPUT"
chmod 775 "$OUTPUT"

# cleanup function
function cleanup {
  if [[ -d "${TMPDIR}" ]]; then
    rm -rf "${TMPDIR}"
  fi
}

trap cleanup EXIT

# Get jq and put in in the tmpdir
if command -v jq >/dev/null; then
  JQ="$(which jq)"
else
  wget -q -O "${TMPDIR}/jq" "${JQ_URL}"
  chmod 755 "${TMPDIR}/jq"
  JQ="${TMPDIR}/jq"
fi

# Get the version of firmware of the Thunderbolt dock and output it to the created file
system_profiler -json SPThunderboltDataType | "${JQ}" -r \ '.SPThunderboltDataType[]._items[]? | select(.vendor_name_key=="CalDigit, Inc.") | .switch_version_key' > "$OUTPUT"
