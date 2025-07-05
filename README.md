# VintageApothecaryLabels
Bash scripts to create Vintage Apothecary Labels as SVG from mustache templates for printing labels. 

Requires mustache (https://mustache.github.io/) template command. Optionally have ImageMagick ready to create a pdf.

## USAGE

Create a JSON file in ./jsons containing: {"label":"Folia Lauri", "sublabel":"folia integra", $FONT} or a two-line version {"label1":"Schinus", "label2":"Terebinthifolia", "sublabel":"grana integra", $FONT}. 
The Filename will be used to create the SVG from the template ./ApothecaryLabel.mustache
The font can be globally configured in the script.
Simply run ./make-labels.sh to create the SVGs and drop them e.g. on a Mac into Pages.app to scale and print them. A Webbrowser can display them too.  
make-labels.sh takes options to reconfigure input-, output-directory and template.
make-pdf.sh puts 10 svgs on one pdf page

Hint: Get PostIt full-page paper and print the labels onto it. They can be easily be changed later. Coat the labels using a clear paint spray.

## INSTALLATION

Download a precompiled binary mustache release (easiest) and put it on your path: https://github.com/cbroglie/mustache/releases

ImageMagick install instructions: see make-pdf.sh comment by Gemini.

Get https://www.dafontfree.io/copperplate-font/ or use a different one.

## HELP

If you want to help/improve, make a new label design, please make a new mustache template as pull-request. make-labels.sh -t NewDesign.mustache should do the trick. Be aware that ImageMagick has some rendering issues with SVGs.
