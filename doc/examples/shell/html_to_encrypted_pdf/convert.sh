#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=http://localhost:9595/convert
fi

curl  --form from=html \
      --form to=pdf \
      --form test_mode=true \
      --form pdf_username=test \
      --form pdf_password=some_password \
      --form input_files[]=@input.html \
      --form other_files[]=@stylesheet.css \
      --form other_files[]=@marcellus.ttf \
      --form other_files[]=@imfeldoublepica.ttf \
      $DOCVERTER_API_URL > html_to_encrypted_pdf.pdf
