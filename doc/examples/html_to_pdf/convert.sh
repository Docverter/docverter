#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=http://localhost:9595/convert
fi

curl --form from=html \
     --form to=pdf \
     --form test_mode=true \
     --form input_files[]=@input.html \
     --form other_files[]=@stylesheet.css \
     --form other_files[]=@marcellus.ttf \
     --form other_files[]=@imfeldoublepica.ttf \
     $DOCVERTER_API_URL > html_to_pdf.pdf

echo html_to_pdf.pdf