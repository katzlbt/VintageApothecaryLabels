#!/bin/bash

# ==============================================================================
#           ImageMagick SVG Print Sheet Generator
#
# Description:
#   This script finds all SVG files in a directory and uses ImageMagick's
#   'montage' command to arrange them on a single page for printing.
#
# Dependencies:
#   - ImageMagick: Must be installed on your system.
#     - On Debian/Ubuntu: sudo apt-get install imagemagick
#     - On Fedora/CentOS: sudo dnf install imagemagick
#     - On macOS (Homebrew): brew install imagemagick
#
# ==============================================================================

# --- CONFIGURATION ---
# --- You can change these variables to fit your needs ---

# Directory where your 10 SVG files are located.
# Use $1 or default "svgs" for the current directory.
INPUT_DIR="svgs"

# The name of the final output file. PDF is great for printing.
# You can also use .png or .jpg if you prefer.
OUTPUT_FILE="2print.pdf"

# The layout of the images on the page (columns x rows).
TILE_GEOMETRY="3x8"

# The resolution (in DPI) to use when rendering the SVGs.
# 300 is a standard for good print quality. 150 is good for proofs.
DENSITY=600

# The background color of the page.
BACKGROUND_COLOR="white"

# The spacing (in pixels) to add around each image tile.
SPACING=50

# --- END OF CONFIGURATION ---

# --- OPTIONS ---

while getopts i:g:f: OPT; do
    case $OPT in
        i)
            INPUT_DIR=$OPTARG
            ;;
        g)
            TILE_GEOMETRY=$OPTARG
            ;;
        f) # select specific files
            SVG_FILES=(${OPTARG//,/ });
            ;;
        *)
            echo $0 "-i input directory (default: svgs, eg. 2print.nogit)"
            echo $0 "-g tile geometry (default: 3x8 or try -g 2x5 for bigger labels)"
            echo $0 "-f file1.svg,file2.svg,file3.svg (optionally select files)"
            exit 0
            ;;
    esac
done

# --- SCRIPT LOGIC ---

if [ ${#SVG_FILES[@]} -eq 0 ]; then

    # 1. Inform the user what the script is doing.
    echo "Searching for SVG files in: $INPUT_DIR"
    
    # change to INPUT_DIR for getting filenames without path
    cd "$INPUT_DIR"
    
    # 2. Find all .svg files in the input directory.
    # We use an array to handle filenames with spaces correctly.
    # The 'shopt -s nullglob' ensures that if no files are found, the array is empty.
    shopt -s nullglob
    SVG_FILES=(*.svg)
    shopt -u nullglob # Turn off nullglob to restore default behavior
    
    # 3. Check if any SVG files were found.
    if [ ${#SVG_FILES[@]} -eq 0 ]; then
      echo "Error: No SVG files found in '$INPUT_DIR'."
      exit 1
    fi

fi

echo "Using ${SVG_FILES[@]} SVG files. Creating montage..."

# 4. The core ImageMagick 'montage' command.
#    -density "$DENSITY": Sets the rendering resolution for the input SVGs.
#      This is VERY important for getting high-quality output from vectors.
#    -tile "$TILE_GEOMETRY": Specifies the grid layout (e.g., 2 columns, 5 rows).
#    -geometry +$SPACING+$SPACING: This adds a border around each tile.
#      The images are resized to fit within their tile while preserving aspect ratio.
#    "${SVG_FILES[@]}": The list of input files. Quoting handles spaces.
#    -background "$BACKGROUND_COLOR": Sets the page background.
#    "$OUTPUT_FILE": The name of the file to save.
montage \
  -density "$DENSITY" \
  -tile "$TILE_GEOMETRY" \
  -geometry "+$SPACING+$SPACING" \
  "${SVG_FILES[@]}" \
  -background "$BACKGROUND_COLOR" \
  "$OUTPUT_FILE"

# 5. Check if the command was successful and provide feedback.
if [ $? -eq 0 ]; then
  echo "--------------------------------------------------"
  echo "Success! Your print sheet is ready."
  echo "Output file: $INPUT_DIR/$OUTPUT_FILE"
  echo "--------------------------------------------------"
else
  echo "--------------------------------------------------"
  echo "Error: ImageMagick failed to create the montage."
  echo "Please check that ImageMagick is installed and that your SVG files are valid."
  echo "--------------------------------------------------"
  exit 1
fi