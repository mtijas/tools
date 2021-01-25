#!/bin/bash

fileList=`ls *.{docx,odt,txt} 2> /dev/null`

OIFS="$IFS"
IFS=$'\n'
for file in $fileList
do
  # Convert spaces to underscores with sh
  outName="${file// /_}"
  # Convert uppercase to lowercase with sh
  outName="${outName,,}"
  # Remove file type suffix and add .md with sh
  outName="${outName%.*}.md"

  echo "Converting $file to $outName"
  eval pandoc --extract-media=media -o $outName '$file'
done
IFD="$OIFS"
