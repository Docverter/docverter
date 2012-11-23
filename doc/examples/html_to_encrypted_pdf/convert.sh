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
    --form from=html \
    --form to=pdf \
    --form test_mode=true \
    --form pdf_username=test \
    --form pdf_password=some_password \
    --form input_files[]=@input.html \
    --form other_files[]=@stylesheet.css \
    --form other_files[]=@marcellus.ttf \
    --form other_files[]=@imfeldoublepica.ttf \
    $DOCVERTER_API_URL > html_to_encrypted_pdf.pdf

echo html_to_encrypted_pdf.pdf