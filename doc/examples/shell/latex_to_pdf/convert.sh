#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=http://localhost:9595/convert
fi

curl --form from=latex \
     --form to=pdf \
     --form test_mode=true \
     --form input_files[]=@latex.latex \
     $DOCVERTER_API_URL > latex_to_pdf.pdf

echo latex_to_pdf.pdf