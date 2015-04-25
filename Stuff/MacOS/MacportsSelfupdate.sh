#!/bin/sh

# To install this script:
#
# sudo /bin/ln -s /Users/pd72/Stuff/bin/MacportsSelfupdate.sh /etc/periodic/daily/900.macports
#
# This places it where the "periodic" utility can find it (it is in-turn run by
# launchd).  This saves you the trouble of configuring it yourself in launchd,
# which can be a pain, and which also isn't necessary if you're okay with this
# running in the wee hours anyway.  Pull up the manpage for "periodic" for more
# details.
#
# Naturally, the target link can be named anything, as long as it's in that
# directory.  But play nice and follow the prevailing conventions, especially
# if you want this to get run in a specific point in the sequence of the run of
# periodic-daily.  You could also run this in the "weekly" section if you so
# desired, but that might not be frequent enough for some (e.g., me).
#
# Append "noemail" to the name if you want to suppress the normal sending of
# email (does not suppress emails about errors).  The "exec" line below is
# commented-out, because I discovered that "periodic" handles the logging for
# you.  Uncomment it if you prefer to do this directly in launchd instead.

set -x

ADDRESS=pd72@nyu.edu
MAIL=/usr/bin/mail
PORT=/opt/local/bin/port

#REPORT=/tmp/MacportsSelfupdate
#exec > ${REPORT}.out 2> ${REPORT}.err

/bin/date

case $(/bin/date +%u) in 6|7) exit ;; esac # weekend

sleep 60 # it seems that my laptop isn't getting it's IP quickly enough

$PORT -v selfupdate

test $? -ne 0 && $MAIL -s "MacPorts self-update failed - see /var/log/daily.out for details" $ADDRESS < /dev/null

case "$(/usr/bin/basename $0)" in *noemail) exit ;; esac

$PORT list outdated | $MAIL -E -s "sudo port upgrade outdated" $ADDRESS
