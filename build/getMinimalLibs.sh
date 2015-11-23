#! /bin/sh
# This script is the minimal package we need install
#
echo "=========================================================="
echo "install cos build packages we need"
echo "Y" | apt-get install vim
echo "Y" | apt-get install git-core
echo "Y" | apt-get install gnupg
echo "Y" | apt-get install flex
echo "Y" | apt-get install bison
echo "Y" | apt-get install gperf
echo "Y" | apt-get install build-essential
echo "Y" | apt-get install zip
echo "Y" | apt-get install curl
echo "Y" | apt-get install zlib1g-dev
echo "Y" | apt-get install libc6-dev
echo "Y" | apt-get install lib32ncurses5-dev
echo "Y" | apt-get install ia32-libs
echo "Y" | apt-get install x11proto-core-dev
echo "Y" | apt-get install libx11-dev
echo "Y" | apt-get install lib32readline5-dev
echo "Y" | apt-get install lib32z-dev
echo "Y" | apt-get install libgl1-mesa-dev
echo "Y" | apt-get install g++-multilib
echo "Y" | apt-get install mingw32
echo "Y" | apt-get install tofrodos
echo "Y" | apt-get install python-markdown
echo "Y" | apt-get install libxml2-utils
echo "Y" | apt-get install xsltproc
echo "install complete!"
echo "=========================================================="
