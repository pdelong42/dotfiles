#!/bin/sh

exec > ${HOME}/Stuff/log/MacportsList.out 2> ${HOME}/Stuff/log/MacportsList.err

case $(/bin/date +%u) in
   6|7) exit ;; # Saturday or Sunday
esac

/opt/local/bin/port list clisp | /usr/bin/mail -E -s "run output: port list outdated" pd72@nyu.edu
