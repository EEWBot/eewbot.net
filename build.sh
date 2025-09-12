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
RESOURCES_VERSION="v2024.4.2"

curl -L -f -s \
	--output resources.tar \
	"https://github.com/EEWBot/eew-resources/releases/download/${RESOURCES_VERSION}/resources.tar"

tar xf resources.tar

# --------------------------------

mkdir -p ./static/imgs/

cp ./resources/ogp.png ./static/imgs/
cp ./resources/icon.png ./static/imgs/

for file in ./template/*; do
	if [[ -f "$file" && "${file##*.}" != "html" ]]; then
		cp "$file" ./static/
	fi
done

if [[ -d ./template/imgs ]]; then
	cp -r ./template/imgs/* ./static/imgs/ 2>/dev/null || true
fi

find ./template -name "*.html" -type f | while read -r html_file; do
	if [[ "$(basename "$html_file")" == "header.html" || "$(basename "$html_file")" == "footer.html" ]]; then
		continue
	fi
	
	relative_path="${html_file#./template/}"
	output_file="./static/$relative_path"
	
	mkdir -p "$(dirname "$output_file")"
	
	cp "$html_file" "$output_file"
	
	sed '/<header><\/header>/r ./template/header.html' "$output_file" | sed '/<header><\/header>/d' > "${output_file}.tmp"
	mv "${output_file}.tmp" "$output_file"
	
	sed '/<footer><\/footer>/r ./template/footer.html' "$output_file" | sed '/<footer><\/footer>/d' > "${output_file}.tmp"
	mv "${output_file}.tmp" "$output_file"
	
	sed -i "s/RESOURCES_VERSION/${RESOURCES_VERSION}/g" "$output_file"
done
