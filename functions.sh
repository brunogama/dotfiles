#!/usr/bin/env bash

iso_to_utf8() {
	file_input=$1
	file_output="utf8_${file_input}"
	original_charset=$(file -I ${file_input} | awk '{print substr($3,9,length($3))}')
	iconv -f ${original_charset} -t UTF-8 ${file_input} > ${file_output}
	unset file_output file_input original_charset
}

git-version() {
	version=`git describe --abbrev=0 --tags`
	short_hash=`git rev-parse --short HEAD`
	echo "Version: $version ($short_hash)"
}

# search for tvshow in piratebay
# parameter 1 is the season
# parameter 2 the number of episodes from 1 to the parameter
# tvshow name
tvshow() {
    for i in $(seq $2)
    do
        open -a "Google Chrome" "`printf "http://thepiratebay.se/search/$3 s%02de%02d" $1 $i`"
    done
}


# http://onethingwell.org/post/14669173541/any
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/
path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

function mkcd() {
    mkdir -p $*
    cd $*
};
