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
    --form to=epub \
    --form test_mode=true \
    --form input_files[]=@chapter1.md \
    --form input_files[]=@chapter2.md \
    --form other_files[]=@metadata.xml \
    --form other_files[]=@document-open.png \
    --form other_files[]=@stylesheet.css \
    --form epub_metadata=metadata.xml \
    --form epub_cover_image=document-open.png \
    --form epub_stylesheet=stylesheet.css \
    $DOCVERTER_API_URL > markdown_to_epub.epub

echo markdown_to_epub.epub