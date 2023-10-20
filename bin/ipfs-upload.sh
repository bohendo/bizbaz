#!/usr/bin/env bash

root=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )
glob_dir="$root/data/zod/.urb/put"
glob="$(ls -t $glob_dir | head -n 1)"
glob_path="$glob_dir/$glob"
url="${1:-$BLOG_URL/ipfs}"

if [[ -z "$glob" ]]
then echo "Couldn't find any globs in $glob_dir" && exit 1
elif [[ ! -f "$glob_path" ]]
then echo "File does not exist at $glob_path" && exit 1
fi

echo "Uploading $glob to ${BLOG_URL#*@}/ipfs"
echo
echo curl --request POST --header 'content-type: application/octet-stream' --upload-file $glob_path $url
echo
sleep 2 # give the user a sec to ctrl-c if the above doesn't look right

curl --request POST --header 'content-type: application/octet-stream' --upload-file "$glob_path" "$url"
