#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
    # display Help
    echo "Script for deploying blog."   
    echo 
    echo "Syntax: deploy.sh [-h] [-g string] [-t string] [-s string]"
    echo "options:"
    echo "h     Print this Help."
    echo "g     Set the commit for hosting site with the commit string."
    echo "t     Set the commit for theme with the commit string."
    echo "s     Set the commit for blog soource with the commit string."
    echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# define variables
FOLDER_GH="visionbike.github.io"
FOLDER_THEME="LoveIt"
MSG_SITE="rebuilding site `date`"
MSG_GH="rebuilding site `date`"
MSG_THEME=""

# process the input options. Add options as needed.
# get the options
if [ $# -eq 0 ]; then
    echo -e "\033[0;32mError: No input arguments. Please execute \"deploy.sh -h\" for getting help.\033[0m"
else
    while getopts ":h:g:t:s" option; do
        case $option in
            h) # display Help
                Help
                exit;;
            g) # set the hosting site commit
                MSG_SITE=$OPTARG;;
            t) # set the theme commit
                MSG_THEME=$OPTARG;;
            s) # set the site commit
                MSG_SITE=$OPTARG;;
            \?) # invalid option
                echo -e "\033[0;32mError: Invalid option.\033[0m"
                exit;;
        esac
    done
fi


# build the project
# if using a theme, replace with `hugo -t <YOURTHEME>`
hugo

if [ -n "$MSG_GH" ]; then
    # Go to public folder
    cd $FOLDER_GH
    # Add changes to git
    git add .
    # commit changes
    git commit -m "$MSG_GH"
    #
    cd ../
else
    echo -e "\033[0;32mNo changes in submodule \"public\" or commit string is given.\033[0m"
fi

if [ -n "$MSG_THEME" ]; then
    # go to the theme folder
    cd themes/$THEME_FOLDER
    # add changes to git
    git add .
    # commit changes
    git commit -m "$MSG_THEME"
    #
    cd ../
else
    echo -e "\033[0;32mNo changes in submodule \"theme\" or no commit string is given.\033[0m"
fi

if [ -n "$MSG_SITE" ]; then
    # add changes to git
    git add .
    # commit channges
    git commit -m "$MSG_SITE"
    # push source and build repos
    git push -u origin master --recurse-submodules=on-demand
else
    echo -e "\033[0;32mNo commit string is given.\033[0m"
fi