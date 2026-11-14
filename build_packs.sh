#!/usr/bin/env bash
#
# looks through custom-wings-resource/assets/fantasticwings/textures/entity/equipment/wings/
# for PNGs, writes a matching wing JSON then zips up both the datapack and the resource
# pack with no mac clutter files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DATA_DIR="custom-wings-data"
RESOURCE_DIR="custom-wings-resource"
WINGS_TEXTURE_DIR="$RESOURCE_DIR/assets/fantasticwings/textures/entity/equipment/wings"
WINGS_DATA_DIR="$DATA_DIR/data/fantasticwings/fantasticwings/wings"

if [[ ! -d "$WINGS_TEXTURE_DIR" ]]; then
	echo "Error: expected to find $WINGS_TEXTURE_DIR" >&2
	exit 1
fi

if [[ ! -d "$WINGS_DATA_DIR" ]]; then
	echo "Error: expected to find $WINGS_DATA_DIR" >&2
	exit 1
fi

# generate a wing JSON for every PNG that doesn't already have one
shopt -s nullglob
png_files=("$WINGS_TEXTURE_DIR"/*.png)
shopt -u nullglob

if [[ ${#png_files[@]} -eq 0 ]]; then
	echo "No PNGs found in $WINGS_TEXTURE_DIR, nothing to generate."
else
	for png in "${png_files[@]}"; do
		filename="$(basename "$png" .png)"

		# clean filename to fit minecraft ID's
		id="$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_.-]/_/g')"

		if [[ "$id" != "$filename" ]]; then
			echo "Note: '$filename.png' sanitized to id '$id'"
		fi

		json_path="$WINGS_DATA_DIR/$id.json"

		if [[ -f "$json_path" ]]; then
			echo "Skipping $id (wing JSON already exists)"
			continue
		fi

		cat > "$json_path" <<EOF
{
	"asset_id": "fantasticwings:$id",
	"model": "insectoid"
}
EOF
		echo "Created $json_path"
	done
fi

# zip the datapack
rm -f "$DATA_DIR.zip"
(
	cd "$DATA_DIR"
	zip -r -X "../$DATA_DIR.zip" pack.mcmeta data -x "*.DS_Store"
)
echo "Built $DATA_DIR.zip"

# zip the resource pack
rm -f "$RESOURCE_DIR.zip"
(
	cd "$RESOURCE_DIR"
	zip -r -X "../custom_wings_host/${RESOURCE_DIR}_2.zip" pack.mcmeta assets -x "*.DS_Store"
)
echo "Built $RESOURCE_DIR.zip"

echo "Done."