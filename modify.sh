#!/bin/bash
# Author: Michal Boniakowski


parameter1=$1
parameter2=$2
filesStartFrom=2

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

Use modify_examples to test

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


# first parrameter is change mode
iterate()
{
    #iterate over arguments / files
    #+1 cuz pattern or l|u passing
    for file in ${@:$filesStartFrom+1};
    do
        change_filename $1 $file
    done   
}

change_filename()
{
    if [ -e "$2" ] ; then
        if [ $1 = "-l" ] ; then
            change_name $2 ${2,,}
        elif [ $1 = "-u" ] ; then
            change_name $2 ${2^^}
        else
            nFilename=$(echo "$2" | sed $1)
            change_name $2 $nFilename
        fi        
    else
        echo "File doesn't exist"
    fi
}

change_name()
{
    if [ $1 = $2 ] ; then
        echo "File with given name allready exists"
    else
        mv -- "$1" "$2"
        echo "Changed $1 to $2"
    fi   
}

#"main" start
echo "START"

#first parameter check
case $parameter1 in
    "-h") display_help ;;
    "-r") check_following_parmeter $parameter2 ;;
    "-u") iterate "-u" $@ ;;
    "-l") iterate "-l" $@ ;;
    *) display_error_flag ;;
esac

#first parameter determine from what pos statrt itteration(first poss is that parmeter so use i+1)
#iter 3 $@

#change_filename "take" "lolz" $3

#iterate $1 $@ 

#echo "take" | sed 's/ta/OP/'
#fname="take"
#expl=$(echo "$fname" | sed 's/ta/OP/')
#echo $expl
#mv -- "$fname" "$expl"



#echo $parameter1
#echo $parameter2
echo "END"

#"main" end