#!/bin/bash
# Author: Michal Boniakowski

#first param mode then at 2 or 3 files start
filesStartFrom=2
#stores info about foldernamechange
name_changed=""

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

recursive_follow()
{
    #check of 2nd parameter
    if [ "$1" == "-u" ] ; then
        reucursion_check $@
    elif [ "$1" == "-l" ] ; then
        reucursion_check $@
    elif [ -z "$1" ] ; then
        display_error_flag
    else
        reucursion_check $@
    fi
}


reucursion_check()
{
   
    for file in ${@:3};
    do
        change_filename $2 $file

        if [ -d "$name_changed" ] ; then
            for entry in "$name_changed"/*
            do
                change_filename $2 $entry
            done

        else
        change_filename $2 $file
        fi
    done   
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
        name_changed=$2
        echo "Changed $1 to $2"
    fi   
}

#"main" start
echo "START"

#first parameter check
case $1 in
    "-h") display_help ;;
    "-r") recursive_follow $@ ;;
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

echo "END"
#"main" end