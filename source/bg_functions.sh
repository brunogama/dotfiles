#!/usr/bin/env bash
# bg_functions.sh


ss() {
	__project=$(find . -iname "*.sublime-project" -d 1)
	if [ -n "$__project" ]; then
		echo "Opening ${__project}"
		o $__project
	else
		echo "s $(dirname $0)"
		s $(dirname $0)
	fi
	unset __project
}


ox() {
	open  $(basename $(pwd)).xcodeproj
}

# Django function to runserver for a given interface OR if no parameters passed it
runserver() {
	# localip is a alias to a miniscript wrote in python to solve
	# the localip which have access to the internet

	internalIP=$(localip)
	open "http://${internalIP}:8000"
	python manage.py runserver ${internalIP}:8000
}

runserver_plus() {
	# localip is a alias to a miniscript wrote in python to solve
	# the localip which have access to the internet

	internalIP=$(localip)
	open "http://${internalIP}:8000"
	python manage.py runserver_plus ${internalIP}:8000
}

# run simple server
server() {
	local port="${1:-8000}"
	open "http://localhost:${port}/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

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

# Force Purge $1 times
spurge() {
	echo "Purging ..."
	for i in  $(seq ${1}); do
	    echo "Purge ${i}/${1}"
	    purge
	done
}

# search for tvshow in piratebay
# parameter 1 is the season
# parameter 2 the number of episodes from 1 to the parameter
# tvshow name
tvshow() {
    for i in $(seq $2)
    do
        open -a "Safari" "`printf "http://thepiratebay.se/search/$3 s%02de%02d" $1 $i`"
    done
}

# wipe_builds() {
# 	if [ -d "../builds" ]; then
# 		echo "Wiping builds"
# 		pkill -9 -fi xcode
# 		m -rf ../builds/*
# 		wipe_xcode_deriveddata
# 	fi
# }

_workon_project() { reply=($(ls -ld ~/Projects/* | while read i; do basename "$i" 2> /dev/null ; done | awk '$0 != "'Inactive'"')); }

workon_project() { cd "${HOME}/Projects/${1}" }

compctl -K _workon_project workon_project
alias wp="workon_project"
new_project() {
	mkdir -p "${HOME}/Projects/$1/Project"
	mkdir -p "${HOME}/Projects/$1/Design"
	mkdir -p "${HOME}/Projects/$1/Docs"
	cd "${HOME}/Projects/$1"
}
alias np="new_project"


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



function new_chrome_window() {
    osascript -e "tell application \"/Applications/Google Chrome.app\"
        make new window
        activate
    end tell"
}

function close_chrome_active_window() {
    osascript -e "tell application \"/Applications/Google Chrome.app\"
        activate
        close window 0
    end tell"
}
function addpod() {
    echo "$(echo $(pbpaste))" >> Podfile
}