function dumplog()
{
cat $1 | while read onelinelog
do
onelinelog=`echo ${onelinelog##*#}`
pc=`echo $onelinelog |  awk  '{print $(2)}'`
if [ x$pc == "xpc" ];
then
so=`echo $onelinelog |  awk  '{print $(4)}' | tr '\r' ' ' | tr '\n' ' ' | tr '\n\r' ' '`
num=`echo $onelinelog |  awk  '{print $(1)}'`
addr=`echo $onelinelog |  awk  '{print $(3)}'`
code=`${TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-addr2line -f -C -e ${OUT}/symbols/$so $addr`
line1=`echo $code | awk '{print $(NF)}' | sed "s:${TOP}/::g"| awk -F, '{printf("%-65s"),$1}'`
line2=`echo $code | awk '{$NF="";print}'`
echo -e "\033[;32m#${num}\033[0m " "\033[;35m${line1}\033[0m " "\033[;33m${line2}\033[0m"
fi
done
}

function aobjdump()
{
    local ARCH=$(get_build_var TARGET_ARCH)
    local OBJDUMP
    case "$ARCH" in
        x86) OBJDUMP=i686-android-linux-objdump;;
        arm) OBJDUMP=arm-linux-androideabi-objdump;;
        *) echo "Unknown arch $ARCH"; return 1;;
    esac
    $ANDROID_TOOLCHAIN/$OBJDUMP $@
}

function astyleformat()
{
    local ASTYLE=`which astyle`
    local FINDCMD=`which find`
    local OLDFOLDER=`pwd`
    if [ "x$ASTYLE" == "x" ] ; then
        mkdir -p /tmp/astyle
        local CMD_DLOAD="Y3VybCBmdHA6Ly8xMC4yNy4xNi45NS9hc3R5bGVfMi4wNF9saW51eC50YXIuZ3ogLXUgdWJ1bnR1OjEyMzQ1NiAtbyAvdG1wL2FzdHlsZS9hc3R5bGVfMi4wNF9saW51eC50YXIuZ3oK"
        `echo "${CMD_DLOAD}" | base64 -d --wrap=0`
        cd /tmp/astyle && tar xf astyle_2.04_linux.tar.gz && cd astyle/build/gcc && make && sudo make install
        cd $OLDFOLDER
        rm -rf /tmp/astyle
    fi
    cd $OLDFOLDER
    ASTYLE=`which astyle`
    local PATH="$1"
    if [ "$PATH" ] ; then
        PATH=$1
    else
        PATH="."
    fi
    $ASTYLE -A2 -c -C -U -p -xd -H `$FINDCMD $PATH -name '*.cpp' -o -name '*.h' -o -name '*.c' `
}

function stylecheck()
{
    local OLDPWD=`pwd`
    rm temp.txt
    astyleformat $@
    local autocpplint="$(gettop)/sdk/tools/cpplint_forgaia/autoexec_cpplint.py"
    local autofixpy="$(gettop)/sdk/tools/cppfix_forgaia/cppfix_forgaia.py"
    python $autocpplint $@
    python $autofixpy "$(gettop)/sdk/tools/cpplint_forgaia/temp.txt"
    python $autocpplint $@
    cp "$(gettop)/sdk/tools/cpplint_forgaia/temp.txt" $OLDPWD
    echo "Coding Style Checking success, Please view the result in ./temp.txt"
}

function findmakefile()
{
    TOPFILE=build/core/envsetup.mk
    # We redirect cd to /dev/null in case it's aliased to
    # a command that prints something as a side-effect
    # (like pushd)
    local HERE=$PWD
    T=
    while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
        T=$PWD
        if [ -f "$T/Android.mk" ]; then
            echo $T/Android.mk
            cd $HERE > /dev/null
            return
        fi
        cd .. > /dev/null
    done
    cd $HERE > /dev/null
}

function armldd()
{
    local ARCH=$(get_build_var TARGET_ARCH)
    local ARMLDD
    case "$ARCH" in
        x86) ARMLDD=i686-android-linux-readelf;;
        arm) ARMLDD=arm-linux-androideabi-readelf;;
    esac
    $ANDROID_TOOLCHAIN/$ARMLDD -a $@ | grep "Shared library" --color
}
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias llh='ls -alFh'
alias adbs='adb shell'

function dumptrace(){
    arm-linux-androideabi-addr2line -f -C -e ${OUT}/symbols/$2 $1
}

function ffind(){
    find * -name "$@"
}

function sgrep() {
    find . -name .repo -prune -o -name .git -prune -o  -type f -iregex '.*\.\(c\|h\|cpp\|S\|java\|xml\|sh\|mk\)' -print0 | xargs -0 grep --color -n "$@"
}

function jgrep() {
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

function cgrep() {
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@"
}

function resgrep() {
    for dir in `find . -name .repo -prune -o -name .git -prune -o -name res -type d`; do find $dir -type f -name '*\.xml' -print0 | xargs -0 grep --color -n "$@"; done;
}

function mgrep()
{    
   find . -name .repo -prune -o -name .git -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -print0 | xargs -0 grep --color -n "$@"
}    

function treegrep()
{    
   find . -name .repo -prune -o -name .git -prune -o -regextype posix-egrep -iregex '.*\.(c|h|cpp|S|java|xml)' -type f -print0 | xargs -0 grep --color -n -i "$@" 
}

