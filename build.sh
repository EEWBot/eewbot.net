#!/bin/bash

set -eux
shopt -s extglob


# --------------------------------

depends=( curl tar )
notfound=()

for app in "${depends[@]}"; do
	if ! type "$app" > /dev/null 2>&1; then
		notfound+=("$app")
	fi
done

if [[ ${#notfound[@]} -ne 0 ]]; then
	echo Failed to lookup dependency:

	for app in "${notfound[@]}"; do
		echo "- $app"
	done

	exit 1
fi


# --------------------------------

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

set -x

# --------------------------------

# depName=EEWBot/eew-resources
RESOURCES_VERSION="v2024.4.1"

curl -L -f -s \
	--output resources.tar \
	"https://github.com/EEWBot/eew-resources/releases/download/${RESOURCES_VERSION}/resources.tar"

tar xf resources.tar

# --------------------------------

cp -ri ./template ./static

find ./static -name "*.html" | while read -r html; do
	sed -i "s/RESOURCES_VERSION/${RESOURCES_VERSION}/g" "$html"
done

mkdir -p ./static/imgs/

cp ./resources/ogp.png ./static/imgs/
cp ./resources/icon.png ./static/imgs/
