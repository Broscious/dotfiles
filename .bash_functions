#!/bin/sh

# bash_functions help
#
# help_funcs - summary of custom user functions
# usage: help-funcs
functions()
{
    cat "${HOME}/.bash_functions" | grep -B 1 usage
}

#
# navigation and basic operations
#
# mkcd - makedir and cd in it
# usage: mkcd <file>
mkcd()
{
    mkdir $1 && cd $1
}

# cpcd - cp and cd to destination
# usage: cpcd <cp-arguments>
cpcd()
{
    cp $@ && cd ${!#}
}

# mvcd - mv and cd to destination
# usage: mvcd <mv-arguments>
mvcd ()
{
    mv $@ && cd ${!#}
}

# swap - switch 2 filenames around
# usage: swap <file1> <file2>
swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# bak - backup selected file
# usage: bak <filename>
bak()
{
    cp $1{,.bak}
}

# mang - search in man page
# usage: mang <manpage> <word>
mang()
{
    man $1 | grep --color=auto $2 -C 5
}

# publicip - get the current public ip address
# usage: publicip
myip()
{
    curl ifconfig.me/ip
}

# extract - extract compressed files
# usage: extract <files>
extract()
{
    local e=0 i c
    for i; do
	if [ -f $i ] && [ -r $i ]; then
	c=
	case $i in
	    *.tar.bz2) c='tar xjf'    ;;
	    *.tar.gz)  c='tar xzf'    ;;
	    *.bz2)     c='bunzip2'    ;;
	    *.gz)      c='gunzip'     ;;
	    *.tar)     c='tar xf'     ;;
	    *.tbz2)    c='tar xjf'    ;;
	    *.tgz)     c='tar xzf'    ;;
	    *.7z)      c='7z x'       ;;
	    *.Z)       c='uncompress' ;;
	    *.exe)     c='cabextract' ;;
	    *.rar)     c='unrar x'    ;;
	    *.xz)      c='unxz'       ;;
	    *.zip)     c='unzip'      ;;
	    *)     echo "$0: cannot extract \`$i': Unrecognized file extension" >&2; e=1 ;;
	esac
	[ ! -z "$c" ] && command $c "$i"
    else
	echo "$0: cannot extract \`$i': File is unreadable" >&2; e=2
    fi
    done
    return $e
}

# compress - archive wrapper
# usage: compress <foo.tar.gz> ./foo ./bar
compress()
{
  FILE=$1
  case $FILE in
    *.tar.bz2) shift && tar cjf $FILE $* ;;
    *.tar.gz) shift && tar czf $FILE $* ;;
    *.tgz) shift && tar czf $FILE $* ;;
    *.zip) shift && zip $FILE $* ;;
    *.rar) shift && rar $FILE $* ;;
    *.7z)  shift && 7za a $FILE $* ;;
  esac
}


# notes - show notes
# usage: notes
notes()
{
    cat ~/.notes
}

# mknote - add a line to the notes
# usage: addnote <note>
mknote()
{
    echo $1 >> ~/.notes
}

# rmnote - remove note line
# usage: rmnote <case insensitive pattern to remove>
rmnote()
{
    sed -i "/$1/Id" ~/.notes
}

# trusthost - add certs from a site to a java keystore
# usage: trusthost <host> <keystore> <keystore password>
trusthost()
{
    HOST="$1"
    KEYSTOREFILE="$2"
    KEYSTOREPASS="$3"

    # get the SSL certificate
    openssl s_client -connect ${HOST} </dev/null \
        | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${HOST}.cert

    # create a keystore and import certificate
    keytool -import -noprompt -trustcacerts \
        -alias ${HOST} -file ${HOST}.cert \
        -keystore ${KEYSTOREFILE} -storepass ${KEYSTOREPASS}

    # verify we've got it.
    keytool -list -v -keystore ${KEYSTOREFILE} -storepass ${KEYSTOREPASS} -alias ${HOST}
}

# getjavatrust - retrieves the path to the java truststore
# usage: getjavatrust
getjavatrust()
{
    JAVA=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    CACERTS=${JAVA}lib/security/cacerts
    JSSECERTS=${JAVA}lib/security/jssecacerts

    if [ -f $JSSECERTS ]; then
	echo $JSSECERTS
    else
	echo $CACERTS
    fi
}
