#!/bin/bash
# Author: Michal Boniakowski

#first param mode then at 2 or 3 files start
filesStartFrom=2

#stores info about foldernamechange
name_changed=""

display_help()
{
#display help as free text till next EOF appear
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

#information when invalid flag was found on input
display_error_flag()
{
    echo "Inappropraite flag/sed used"
    echo "Try again"
    exit 1
}

#check what follows -r parameter
recursive_follow()
{
    if [ "$1" == "-u" ] ; then
        reucursion_iter $@
    elif [ "$1" == "-l" ] ; then
        reucursion_iter $@
    elif [ -z "$1" ] ; then
        display_error_flag
    else
        reucursion_iter $@
    fi
}

#iterate over initial files/folders
reucursion_iter()
{

    for file in ${@:3};
    do
        recursion $2 $file       
    done   
}

# $1 changetype $2 filename
recursion()
{
        change_filename $1 $2
        #check if file is folder using temp filename for valid folder
        if [ -d "$name_changed" ] ; then
            for entry in "$name_changed"/*
            do               
                if [ -d "$entry" ] ; then
                    #if another folder call itself with same parameter but new foldername as file parameter
                    recursion $1 $entry
                else
                    change_filename $1 $entry
                fi
            done
        else
        change_filename $1 $2
        fi
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

# decide what to do with filename $2
# $1 is flag what to do (l,u,seed)
change_filename()
{
    #checking if file exists
    if [ -e "$2" ] ; then
        if [ $1 = "-l" ] ; then
        #${2,,} changes $2 to upper
            change_name $2 ${2,,}
        elif [ $1 = "-u" ] ; then
        #${2^^} changes $2 to upper
            change_name $2 ${2^^}
        else
            #get file $2 as stream and then chenge it by sed $1
            nFilename=$(echo "$2" | sed $1)
            change_name $2 $nFilename
        fi        
    else
        echo "File doesn't exist"
    fi
}

#check if filename already exists
#change filename $1 to $2
change_name()
{
    if [ $1 = $2 ] ; then
        echo "File with given name allready exists"
    else
    #move filename $1 to $2
        mv -- "$1" "$2"
    #saved to temp filename for folders and recursion
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

echo "END"
#"main" end