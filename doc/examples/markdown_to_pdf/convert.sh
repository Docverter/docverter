#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=https://api.docverter.com/v1/convert
fi

api_key=$1

if [[ $api_key == '' ]]; then
    echo Usage: convert.sh API_KEY
    exit 1
fi

curl -u "$api_key:" \
    --form from=markdown \
    --form to=pdf \
    --form test_mode=true \
    --form input_files[]=@chapter1.md \
    --form input_files[]=@chapter2.md \
    --form other_files[]=@stylesheet.css \
    --form other_files[]=@imfeldoublepica.ttf \
    --form other_files[]=@marcellus.ttf \
    --form css=stylesheet.css \
    $DOCVERTER_API_URL > markdown_to_pdf.pdf

echo markdown_to_pdf.pdf