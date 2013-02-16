#!/bin/bash

if [[ "$DOCVERTER_API_URL" == "" ]]; then
    export DOCVERTER_API_URL=http://localhost:9595/convert
fi

curl --form from=markdown \
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