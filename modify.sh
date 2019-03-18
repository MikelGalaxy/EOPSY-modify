#!/bin/bash
# Author: Michal Boniakowski
echo "TEST"

parameter1=$1
parameter2=$2


display_help()
{
cat <<EOF

Help
modify [-r] [-l|-u] <dir/file names...>
modify [-r] <sed pattern> <dir/file names...>

Modify change file names. It can lowerize (-l) or upercase (-u)
filenames. It can also use sed pattern for that purpose.
Changes can be done with recursion (-r)(changing name for all files in folder)
or without it(just file or folder name)

modify [1-9] is used for testing purpose where digit represent test number

EOF
}

display_error_flag()
{
    echo "Inappropraite flag/sed used"
    echo "Try again"
    exit 1
}

check_following_parmeter()
{
    #check of 2nd parameter
    if [ "$1" == "-u" ] ; then
        echo "Upp"
    elif [ "$1" == "-l" ] ; then
        echo "Low"
    elif [ -z "$1" ] ; then
        display_error_flag
    else
        check_pattern $1
    fi
}

check_pattern()
{
     echo "Check if pattern"
}


check_filename()
{
    echo $1
}

iter()
{
    #iterate over arguments / files
    for var in ${@:$1};
    do
        echo "$var"
    done
}


change_filename()
{
    if [ -z "$3" ] ; then
        mv -- "$1" "$2"
    else
        echo "Pattern change"
    fi
}

#first parameter check
case $parameter1 in
    "-h") display_help ;;
    "-r") check_following_parmeter $parameter2 ;;
    "-u") check_filename "-u" ;;
    "-l") check_filename "-l" ;;
    *) display_error_flag ;;
esac

#first parameter determine from what pos statrt itteration(first poss is that parmeter so use i+1)
#iter 3 $@

#change_filename "take" "lolz" $3

#echo $parameter1
#echo $parameter2
echo "END"