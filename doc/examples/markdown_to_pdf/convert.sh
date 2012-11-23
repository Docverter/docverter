#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=http://localhost:9595/convert
fi

curl --form from=markdown \
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