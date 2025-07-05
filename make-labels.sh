#!/bin/bash

INPUT_DIR=jsons # YAML or JSON in *.yaml
OUTPUT_DIR=svgs

TEMPLATE=ApothecaryLabel.mustache
FONT='"font":{"label-size":22, "sublabel-size":16, "family":"Copperplate"}'

while getopts i:o:t: OPT; do
    case $OPT in
        i)
            INPUT_DIR=$OPTARG
            ;;
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        t)
            TEMPLATE=$OPTARG
            ;;
        *)
            echo $0 "-i input-directory (default: jsons)"
            echo $0 "-o output-directory (default: svgs)"
            echo $0 "-t template.mustache (default: ApothecaryLabel.mustache)"
            ;;
    esac
done

MUSTACHE="mustache $TEMPLATE"

echo "Searching for JSON files in: $INPUT_DIR"

shopt -s nullglob
JSON_FILES=("$INPUT_DIR"/*.json)
shopt -u nullglob # Turn off nullglob to restore default behavior

# 3. Check if any SVG files were found.
if [ ${#JSON_FILES[@]} -eq 0 ]; then
  echo "Error: No JSON files found in '$INPUT_DIR'."
  exit 1
fi

echo "Found ${#JSON_FILES[@]} JSON files. Creating svgs ..."

mkdir "$OUTPUT_DIR"

for FP in "${JSON_FILES[@]}" ; do
    FILE=$(basename "$FP")
    echo "Processing $INPUT_DIR/$FILE ..."
    cat "$INPUT_DIR"/$FILE | sed "s|\$FONT|$FONT|g" 
    cat "$INPUT_DIR"/$FILE | sed "s|\$FONT|$FONT|g" | $MUSTACHE > "$OUTPUT_DIR"/"${FILE%.*}.svg"
done
