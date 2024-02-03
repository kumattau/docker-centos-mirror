#!/bin/bash
set -eu -o pipefail

HTTPSRV=$(perl -nle 'if(/^my \$HTTPSRV = .*"(.*)";$/){print $1}' centos-mirror.pl)
REPOURL=$(perl -nle 'if(/^my \$REPOURL = .*"(.*)";$/){print $1}' centos-mirror.pl)

URL1=http://mirrorlist.centos.org
URL2=http://mirror.centos.org/centos

sig=
idx=0
atexit() {
    rc=$?
    echo
    if [ "$sig" != "" ]; then
        echo "interrupted by SIG$sig"
    fi
    echo "Tests=$idx"
    if [ "$rc" = "0" ]; then
        echo "Result: PASS"
    else
        echo "Result: FAIL"
    fi
    exit "$rc"
}
trap 'atexit' EXIT
for s in INT TERM; do
    trap 'rc=$?; sig='$s'; exit $rc' $s
done

testeq() {
    try=$1
    ans="OK rewrite-url=$2"
    got=$(echo "$try" | ./centos-mirror.pl)

    if [ "$got" != "$ans" ]; then
        cat <<EOT

#   Failed test $idx
#          try: $try
#          got: $got
#          ans: $ans
EOT
        return 1
    fi
    if [ "$idx" != "0" ] && [ "$((idx % 50))" = "0" ]; then
        printf "\n"
    fi
    printf "%d" $((idx % 10))
    idx=$((idx + 1))
}

testeq "$URL1/?release=3.8&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/3.8/os/x86_64/"
testeq "$URL1/?release=3.9&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/3.9/os/x86_64/"
testeq "$URL1/?release=3&arch=x86_64&repo=os"                        "$HTTPSRV?$URL2/3/os/x86_64/"
testeq "$URL1/?release=4.0&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/4.0/os/x86_64/"
testeq "$URL1/?release=4.8&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/4.8/os/x86_64/"
testeq "$URL1/?release=4.9&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/4.9/os/x86_64/"
testeq "$URL1/?release=4&arch=x86_64&repo=os"                        "$HTTPSRV?$URL2/4/os/x86_64/"
testeq "$URL1/?release=5.0&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/5.0/os/x86_64/"
testeq "$URL1/?release=5.10&arch=x86_64&repo=os"                     "$HTTPSRV?$URL2/5.10/os/x86_64/"
testeq "$URL1/?release=5.11&arch=x86_64&repo=os"                     "$HTTPSRV?$URL2/5.11/os/x86_64/"
testeq "$URL1/?release=5&arch=x86_64&repo=os"                        "$HTTPSRV?$URL2/5/os/x86_64/"
testeq "$URL1/?release=6.0&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/6.0/os/x86_64/"
testeq "$URL1/?release=6.9&arch=x86_64&repo=os"                      "$HTTPSRV?$URL2/6.9/os/x86_64/"
testeq "$URL1/?release=6.10&arch=x86_64&repo=os"                     "$HTTPSRV?$URL2/6.10/os/x86_64/"
testeq "$URL1/?release=6&arch=x86_64&repo=os"                        "$HTTPSRV?$URL2/6/os/x86_64/"

testeq "$URL1/?release=7.0.1406&arch=x86_64&repo=os"                 "$HTTPSRV?$URL2/7.0.1406/os/x86_64/"
testeq "$URL1/?release=7.8.2003&arch=x86_64&repo=os"                 "$HTTPSRV?$URL2/7.8.2003/os/x86_64/"
testeq "$URL1/?release=7.9.2009&arch=x86_64&repo=os"                 "$HTTPSRV?$URL2/7.9.2009/os/x86_64/"
testeq "$URL1/?release=7&arch=x86_64&repo=os"                        "$HTTPSRV?$URL2/7/os/x86_64/"

testeq "$URL1/?release=8.0.1905&arch=x86_64&repo=BaseOS&infra=stock" "$HTTPSRV?$URL2/8.0.1905/BaseOS/x86_64/os/"
testeq "$URL1/?release=8.4.2105&arch=x86_64&repo=BaseOS&infra=stock" "$HTTPSRV?$URL2/8.4.2105/BaseOS/x86_64/os/"
testeq "$URL1/?release=8.5.2111&arch=x86_64&repo=BaseOS&infra=stock" "$HTTPSRV?$URL2/8.5.2111/BaseOS/x86_64/os/"
testeq "$URL1/?release=8&arch=x86_64&repo=BaseOS&infra=stock"        "$HTTPSRV?$URL2/8/BaseOS/x86_64/os/"

testeq "$URL2/3.8/os/x86_64/"                                        "$REPOURL/3.8/os/x86_64/"
testeq "$URL2/3.9/os/x86_64/"                                        "$REPOURL/3.9/os/x86_64/"
testeq "$URL2/3/os/x86_64/"                                          "$REPOURL/3.9/os/x86_64/"
testeq "$URL2/4.0/os/x86_64/"                                        "$REPOURL/4.0/os/x86_64/"
testeq "$URL2/4.8/os/x86_64/"                                        "$REPOURL/4.8/os/x86_64/"
testeq "$URL2/4.9/os/x86_64/"                                        "$REPOURL/4.9/os/x86_64/"
testeq "$URL2/4/os/x86_64/"                                          "$REPOURL/4.9/os/x86_64/"
testeq "$URL2/5.0/os/x86_64/"                                        "$REPOURL/5.0/os/x86_64/"
testeq "$URL2/5.10/os/x86_64/"                                       "$REPOURL/5.10/os/x86_64/"
testeq "$URL2/5.11/os/x86_64/"                                       "$REPOURL/5.11/os/x86_64/"
testeq "$URL2/5/os/x86_64/"                                          "$REPOURL/5.11/os/x86_64/"
testeq "$URL2/6.0/os/x86_64/"                                        "$REPOURL/6.0/os/x86_64/"
testeq "$URL2/6.9/os/x86_64/"                                        "$REPOURL/6.9/os/x86_64/"
testeq "$URL2/6.10/os/x86_64/"                                       "$REPOURL/6.10/os/x86_64/"
testeq "$URL2/6/os/x86_64/"                                          "$REPOURL/6.10/os/x86_64/"

testeq "$URL2/7.0.1406/os/x86_64/"                                   "$REPOURL/7.0.1406/os/x86_64/"
testeq "$URL2/7.8.2003/os/x86_64/"                                   "$REPOURL/7.8.2003/os/x86_64/"
testeq "$URL2/7.9.2009/os/x86_64/"                                   "$URL2/7.9.2009/os/x86_64/"
testeq "$URL2/7/os/x86_64/"                                          "$URL2/7/os/x86_64/"

testeq "$URL2/8.0.1905/BaseOS/x86_64/os/"                            "$REPOURL/8.0.1905/BaseOS/x86_64/os/"
testeq "$URL2/8.4.2105/BaseOS/x86_64/os/"                            "$REPOURL/8.4.2105/BaseOS/x86_64/os/"
testeq "$URL2/8.5.2111/BaseOS/x86_64/os/"                            "$REPOURL/8.5.2111/BaseOS/x86_64/os/"
testeq "$URL2/8/BaseOS/x86_64/os/"                                   "$REPOURL/8.5.2111/BaseOS/x86_64/os/"

