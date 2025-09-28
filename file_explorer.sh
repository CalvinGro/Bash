# Title:       file_explorer.sh
# Auther:      Calvin Gross
# Date:        9/6/25
# Description: This program prints out the file pathway, file type,
#              file size, and mime of each file in a given directory.


  # $1 is the argument, a directory.
for i in $1*
do
  # Finds the size of the file.
  # $() turns the output of whats inside into a str.
  # stat prints out statistics, -c formats it, %s returns only the size stat.
  # it is piplined into numfmt --to=si which makes it humanreadable.
  size=$(stat -c %s $i | numfmt --to=si)

  # Finds what the file is (video, text, image, etc) and the file type (pgn, pdf, txt, etc).
  # It is piped into cut -d" " (delimiter = " ") -f2- (return the second and beyond fields).
  # This cut is necessary to remove the first field of output in file --mime-type.
  mime=$(file --mime-type $i | cut -d" " -f2-)

  # If else block to check if the file is a directory or else a file.
  if [ -d $i ]; then
    type="dir"
  else
    type="file"
  fi # terminate if/else block
  
  # print results
  echo " $i   $type   $size   $mime"
done