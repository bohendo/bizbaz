#!/usr/bin/env bash

name="${1:-zod}"
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )
data="$root/data"
fresh="fresh-$name"
reset="${2:-"false"}" # or "true" to reset all persistent data to fresh state

if [[ "$1" == "--reset" ]]
then reset="true"
fi

if [[ -n "$(command -v urbit)" ]]
then
  echo "Starting urbit via local binary at $(realpath "$(which urbit)")"
  urbit="$(realpath "$(which urbit)")";
elif [[ -n "$(command -v docker)" ]]
then
  image_name="tloncorp/vere"
  image_version="v2.12-53c50a9"
  image="$image_name:$image_version"
  if ! grep -q "$image_version" <<<"$(docker image ls | grep "$image_name")"
  then docker image pull "$image"
  fi
  port="$(( RANDOM % (65535 - 1000 + 1 ) + 1000 ))"
  urbit="docker run --interactive --tty --rm --name=$name --mount=type=bind,src=$data,dst=/urbit --publish=$port:80 --entrypoint=urbit $image --loom 31"
else
  echo "Neither urbit nor docker is installed, can't start a fake ship" && exit 1
fi

mkdir -p "$data"
cd "$data" || exit 1
if [[ -d "$fresh" ]]
then
  if [[ ! -d "$name" ]]
  then
    echo "Copying fresh data from $fresh to $name"
    cp -r "$fresh" "$name"
  elif [[ "$reset" == "true" ]]
  then
    echo "Deleting all data for $name and copying over fresh data"
    sleep 3 # give user a sec to ctrl-c if this was a mistake
    rm -rfv "$name"
    cp -r "$fresh" "$name"
  fi
  $urbit "$name"
else
  echo
  echo "No data found at $(realpath $fresh)"
  echo "Booting a new urbit to use as a quick-start $name.."
  echo "Once this ship boots, run '|exit' to preserve a pristinely booted fresh ship"
  echo "Then, re-run this script to start a fresh $name ship from the generated fresh-$name data"
  echo
  sleep 3 # give the user a sec to read the message above
  $urbit --fake "$name" --pier "$fresh" # warning: takes ~2 minutes & lots of cpu
fi
