#!/bin/sh
# Handle by extension
case "$(echo "${1##*.}" | tr '[:upper:]' '[:lower:]')" in
    # Archive
    a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip|zst)
        atool --list -- "$1" && exit
        bsdtar --list --file "$1" && exit ;;
    rar)
        unrar lt -p- -- "$1" && exit ;;
    7z)
        7z l -p -- "$1" && exit ;;

    # PDF
    pdf) # Convert pdf file to texts
        pdftotext -l 10 -nopgbrk -q -- "$1" - && exit ;;

    # BitTorrent
    torrent)
        transmission-show -- "$1" && exit ;;

    # OpenDocument
    odt|ods|odp|sxw) # Preview as text conversion
        odt2txt "$1" && exit ;;

    # HTML
    htm|html|xhtml)
        # Preview as text conversion
        w3m -dump "$1" ||
        lynx -dump -- "$1" ||
        elinks -dump "$1" && exit ;;

    *) ;; # Go on to handle by mime type
esac

# Handle by mime types
case "$(file -Lb --mime-type -- "$1")" in
    # Text
    text/*|*/xml|*/csv|*/json)
        # try to detect the charactor encodeing
        enc=$(head -n20 "$1" | uchardet)
        highlight -O ansi --force -- "$1" |\
        iconv -f "${enc:-UTF-8}" -t UTF-8 && exit ;;

    # Image
    # image/*)
        # Preview as text conversion
        # img2txt --gamma=0.6 -- "$1" && exit 1
        # exiftool "$1" && exit ;;

    # Video and audio
    video/*|audio/*|application/octet-stream)
        mediainfo "$1" && exit ;;

    *) ;; # Go on to fall back
esac

# None of above exits, this is the fall back
echo '----- File Type Classification -----'
file --dereference --brief -- "$1"
