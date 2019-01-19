#!/bin/bash


function MD2HTML
{
  echo Creating $HTML_FILE from markdown file.
  TEMPLATE=pandoc-html-template.html
  pandoc                                          \
    --standalone                                  \
    --from gfm+hard_line_breaks                   \
    --section-divs                                \
    --to html                                     \
    -c $CSS_FILE                                  \
    --self-contained                              \
    --email-obfuscation none                      \
    --template $TEMPLATE                          \
    --data-dir $CUR_DIR                           \
    --metadata title:"Nicolas Jeanmonod"          \
    --metadata generator-meta:"Nicolas Jeanmonod" \
    --metadata author-meta:"Nicolas Jeanmonod"    \
    --metadata date-meta:"$DATE"                  \
    --metadata lang:"$LANG"                       \
    --output $HTML_FILE                           \
    $MD_FILE
}


function HTML2PDF
{
  # If $FILE_OUT exists and is not writable then check it out from P4 depot.
  if [[ -e "$FILE_OUT" && ! -w "$FILE_OUT" ]]
  then
    p4 open $FILE_OUT
  fi

  time(
    prince                \
      --input=HTML        \
      --javascript        \
      --disallow-modify   \
      --verbose           \
      -o $PDF_FILE        \
      $HTML_FILE
  )

  echo "*** Checking Embedded Fonts ***"
  pdffonts $PDF_FILE

  open $PDF_FILE
}


function CV_FR
{
  LANG=fr
  MD_FILE=cv_njeanmon_fr.md
  HTML_FILE=cv_njeanmon_fr.html
  PDF_FILE=cv_njeanmon_fr.pdf
  CSS_FILE="style_cv.css"
  MD2HTML
  HTML2PDF
  echo "*** CV FR DONE ***"
}


function CV_EN
{
  LANG=en
  MD_FILE=cv_njeanmon_en.md
  HTML_FILE=cv_njeanmon_en.html
  PDF_FILE=cv_njeanmon_en.pdf
  CSS_FILE="style_cv.css"
  MD2HTML
  HTML2PDF
  echo "*** CV EN DONE ***"
}


function LETTRE_FR
{
  LANG=fr
  MD_FILE=lettre_njeanmon_fr.md
  HTML_FILE=lettre_njeanmon_fr.html
  PDF_FILE=lettre_njeanmon_fr.pdf
  CSS_FILE="style_letter.css"
  MD2HTML
  HTML2PDF
  echo "*** LETTRE FR DONE ***"
}


function LETTER_EN
{
  LANG=en
  MD_FILE=letter_njeanmon_en.md
  HTML_FILE=letter_njeanmon_en.html
  PDF_FILE=letter_njeanmon_en.pdf
  CSS_FILE="style_letter.css"
  MD2HTML
  HTML2PDF
  echo "*** LETTER EN DONE ***"
}


function DEBUG_GITHUB
{
  LANG=en
  MD_FILE=debug-github-pages.md
  HTML_FILE=debug-github-pages.html
  PDF_FILE=debug-github-pages.pdf
  CSS_FILE="style.css"
  MD2HTML
  HTML2PDF
  echo "*** LETTER EN DONE ***"
}


TIMEFORMAT='time : %3R s'
SCRIPT=`realpath $0`
CUR_DIR=`dirname $SCRIPT`
DATE=`date -u "+%Y-%m-%dT%H:%M:%SZ"`
ERR_MSG="\nUsage: $0 \n\n  1: CV_FR \n  2: LETTRE_FR \n  3: CV_EN \n  4: LETTER_EN"
if [ $# -eq 0 ]; then echo -e "$ERR_MSG"; exit 1; fi

osascript <<END
tell application "Preview"
  close windows
end tell
END

for PARAM in "$@"
  do case "$PARAM" in
    "1") CV_FR ;;
    "2") LETTRE_FR ;;
    "3") CV_EN ;;
    "4") LETTER_EN ;;
    "5") DEBUG_GITHUB ;;
    *) echo "$ERR_MSG"
  esac
done
