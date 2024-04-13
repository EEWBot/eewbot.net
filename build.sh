#!/bin/bash

set -eux
shopt -s extglob

depends=( curl inkscape )
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

# depName=git@github.com:notofonts/noto-fonts.git
NOTOFONTS_COMMIT="ffebf8c1ee449e544955a7e813c54f9b73848eac"

mkdir -p ~/.fonts

curl -L -f -s \
	--output ~/.fonts/NotoSans-Medium.ttf \
	"https://raw.githubusercontent.com/notofonts/noto-fonts/${NOTOFONTS_COMMIT}/hinted/ttf/NotoSans/NotoSans-Medium.ttf"

for f in ./logo/*.svg; do
	echo "Convert $f -> $f.png"
	inkscape --export-type=png "$f" --export-filename="${f%.*}.png"
done

mkdir -p ./static/imgs/

cp ./logo/*.png ./static/imgs/
