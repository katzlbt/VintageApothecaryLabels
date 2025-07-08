#!/bin/bash
set -e
set -o pipefail

# This script can merge (-m) all json files of a directory into a single file for 
# translation or editing purposes and split (-s) it again into single files for template processing
# The format of the merged file (JSON_FILE) is simple:
# { "filename1.json": (JSON contained in the file), "filename2.json": (JSON contained in the file) }

# --- DEFAULTS ---
FILES_DIR="jsons"
JSON_FILE="jsons-merged.nogit.json"
ACTION=""

# --- USAGE FUNCTION ---
usage() {
    echo "Usage: $0 [-m|-s] [-d <dir>] [-j <file>]"
    echo ""
    echo "Actions (mutually exclusive):"
    echo "  -m          Merge all .json files from a directory into a single JSON file."
    echo "  -s          Split a merged JSON file back into individual .json files in a directory."
    echo ""
    echo "Options:"
    echo "  -d <dir>    The directory for individual JSON files. (Default: $FILES_DIR)"
    echo "  -j <file>   The merged JSON file. (Default: $JSON_FILE)"
    echo ""
    exit 1
}

# --- OPTIONS ---
while getopts d:j:ms OPT; do
    case $OPT in
        d) # the directory where single JSON files are placed or collected relative to ./
            FILES_DIR=$OPTARG
            ;;
        j) # set the name of the JSON file that collects all data from FILES_DIR and that can reproduce FILES_DIR
            JSON_FILE=$OPTARG
            ;;
        m)
            if [ -n "$ACTION" ]; then
                echo "Error: -m and -s are mutually exclusive." >&2
                usage
            fi
            ACTION="merge";
            ;;
        s)
            if [ -n "$ACTION" ]; then
                echo "Error: -m and -s are mutually exclusive." >&2
                usage
            fi
            ACTION="split";
            ;;
        *)
            usage
            ;;
    esac
done

# Created by Google Gemini 2.5 PRO >>>>>>>>>

# --- DEPENDENCY CHECK ---
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq to use this script." >&2
    exit 1
fi

# --- VALIDATION ---
if [ -z "$ACTION" ]; then
    echo "Error: You must specify an action with -m (merge) or -s (split)." >&2
    usage
fi

# --- MAIN LOGIC ---

if [ "$ACTION" = "merge" ]; then
    echo "--- Starting Merge Operation ---"

    if [ ! -d "$FILES_DIR" ]; then
        echo "Error: Directory '$FILES_DIR' not found." >&2
        exit 1
    fi

    # Check if there are any .json files to merge
    if ! find "$FILES_DIR" -maxdepth 1 -name '*.json' -print -quit | grep -q .; then
        echo "Warning: No .json files found in '$FILES_DIR'. Creating an empty JSON object."
        echo "{}" > "$JSON_FILE"
        exit 0
    fi
    
    echo "Merging .json files from '$FILES_DIR' into '$JSON_FILE'..."
    
    # Use jq to perform the merge operation.
    # -s (slurp) reads all input JSON files into a single array.
    # 'map({(input_filename | split("/")[-1]): .})' creates an array of objects, where each object
    # has the filename as the key and the file's JSON content as the value.
    # '| add' then merges this array of single-key objects into one combined object.
    # 'map({(input_filename | split("/")[-1]): .}) | add'
    jq -n 'reduce inputs as $json ({}; . + { (input_filename | split("/")[-1]): $json })' "$FILES_DIR"/*.json > "$JSON_FILE"

    echo "Merge complete. Output written to '$JSON_FILE'."

elif [ "$ACTION" = "split" ]; then
    echo "--- Starting Split Operation ---"

    if [ ! -f "$JSON_FILE" ]; then
        echo "Error: Merged file '$JSON_FILE' not found." >&2
        exit 1
    fi

    # Create the output directory if it doesn't exist
    if [ ! -d "$FILES_DIR" ]; then
        echo "Creating directory '$FILES_DIR'..."
        mkdir -p "$FILES_DIR"
    fi

    echo "Splitting '$JSON_FILE' into individual files in '$FILES_DIR'..."

    # Use jq to extract keys (filenames) and then loop through them.
    # This is safer than trying to generate and execute shell commands from jq.
    # 'keys_unsorted[]' prints each key on a new line.
    # The while loop reads each key safely, even if it contains spaces.
    jq -r 'keys_unsorted[]' "$JSON_FILE" | while IFS= read -r filename; do
        echo "  -> Creating '$FILES_DIR/$filename'"
        
        # For each key (filename), extract its corresponding value (the JSON content)
        # and redirect it to the correct output file.
        jq ".[\"$filename\"]" "$JSON_FILE" > "$FILES_DIR/$filename"
    done

    echo "Split complete."
fi
