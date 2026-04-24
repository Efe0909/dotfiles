#!/bin/sh
dest="$1"
stage=/tmp/yazi_rsync_stage

if [ ! -f "$stage" ] || [ ! -s "$stage" ]; then
    echo "Nothing staged. Use r a to stage files first."
    read -r _
    exit 1
fi

while IFS= read -r f; do
    rsync -av --progress "$f" "$dest/"
done < "$stage" && rm -f "$stage"

echo
echo "--- Done. Press any key to close ---"
read -r _
