# VintageApothecaryLabels
Very simple bash scripts to create Vintage Apothecary Labels (or actually any other labels, too) as SVG from mustache templates for printing labels. If you also install ImageMagick the second script can combine the SVGs into a PDF.

Requires mustache (https://mustache.github.io/) template command. Optionally have ImageMagick ready to create a pdf.

![bottle](https://github.com/user-attachments/assets/0c9f8601-6c00-4098-9bcd-5c426af4709f)

## USAGE

Create a JSON file in ./jsons containing: ```{"label":"Folia Lauri", "sublabel":"folia integra", "font": 1} or a two-line version {"label1":"Schinus", "label2":"Terebinthifolia", "sublabel":"grana integra", "font": 1}```. 
The Filename will be used to create the SVG from the template ./ApothecaryLabel.mustache
The font can be globally configured in the script and is replaced with sed (which is a hack that needs the space, or adjusted individually).
Simply run ./make-labels.sh to create the SVGs and drop them e.g. on a Mac into Pages.app to scale and print them. A Webbrowser can display them too. If you have ImageMagick, make-pdf.sh can create a PDF sheet.  

### make-labels.sh 

Creates SVG files for each JSON input file using a mustache template.

    -i directory ... change input directory from default jsons
    -o directory ... change output directory from default svgs
    -t file ... change mustache template from default ApothecaryLabel.mustache

### make-pdf.sh

Puts SVGs into a PDF file for printing. The resulting PDF needs to be scaled to fit a printer page. I cannot get montage to do this correctly. MacOS auto-scales the PDF to fit the page when printing.

    -g specifies ... the geometry e.g. 2x 3x 4x for how many columns of labels. This determines the resulting size.
    -i directory ... changes the input directory from ./jsons to your choice
    -f file1,file2,... optionally manually select files to (re)print

    3x8 fits 24 labels perfectly (6x3 cm) per page (adding pages if needed)
    2x5 fits 10 labels (8.5x4.25 cm) per page
    2x6 fits 12 labels per page
    4x  makes rather small labels

### split-merge-json.sh

Optional: This script can merge (-m) all json files of a directory into a single file for translation/processing with an AI and split (-s) it again into single files for template processing. Requires jq installed.

### Hints

Get PostIt full-page paper and print the labels onto it. Use a paper cutter to split them. They can easily be changed later. Coat the labels using a clear paint spray (e.g. Nigrin Klarlack Spray) to fixate the toner and make them washable.

## INSTALLATION

Download a precompiled binary mustache release (easiest) and put it on your path: https://github.com/cbroglie/mustache/releases

ImageMagick install instructions: see make-pdf.sh comment by Gemini.

Download and install the Copperplate font or use a different one.

## HELP

If you want to help/improve, make a new label design, please make a new mustache template as pull-request. ```make-labels.sh -t NewDesign.mustache``` should do the trick. Be aware that ImageMagick has some rendering issues with SVGs.
