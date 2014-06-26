#!/bin/bash
# build_gh-pages.sh
#
# A simple script to build github webpages on a local ubuntu/debian machine
# AGPL 3.0 licensed
#
# SCRIPT MUST RUN IN THE DIRECTORY YOU WANT THE GIT REPO TO CLONE TO AND BUILD
#
# Version 0.001 Pre-Alpha
# First Release 6/25/14
#
# Written by Joe White (https://FreiCoin.US - joe@FreiCoin.US)
#
# FRC and BTC donation address (I'll take any currency fiat or crypto for donation)
# 1FRCJoeWXbYe47cmuW3do8VoqAr9HuWbpJ
#
#

DEFAULT=default

githubPageUser () {

	read -p "What is the username of the person with the github page, not the repository, you want to clone?" pageUser

	if [ -z $pageUser ]; then
		echo "You need to type in something, please try again"
		githubPageUser
	fi
}

githubPageRepo () {

	read -p "What is the github repository name, not the github user, you wish to clone?" githubRepo

	if [ -z $githubRepo ]; then
                echo "You need to type in something, please try again"
		githubPageRepo
	fi
}

trashRepo () {
        rm -rfv "$githubRepo"
	echo "Old repo folder trashed. Cloning new repo"
	git clone http://github.com/"$pageUser"/"$githubRepo"
	echo "Repo cloned from default github commit on master branch"
}


buildPage () {
        cd "$githubRepo"

	echo "Building page"
	echo "source 'https://rubygems.org'" > "Gemfile"
	echo "gem 'github-pages'" >> "Gemfile"
	echo "Final build, once the process has run, you can connect via localhost port 4000"
	bundle exec jekyll serve
	clear
	echo "Cool! You are done, thanks for using this script - Written by Joe White joe@freicoin.us FreiCoin.US"
	exit
}


yesOrNo () {
# main function, considering rewriting yesOrNo function to simply return a response but this is easier as I already started writing the script
read -p "Do you want to try and delete the current repo and rebuild from the latest code? y/n/c " yesOrNo
yesOrNo=$(echo $yesOrNo | tr '[A-Z]' '[a-z]')

if [ "$yesOrNo" = "n" ] ; then
	echo "You selected to NOT trash the current folder but to just build what is there now."
	buildPage
elif [ "$yesOrNo" = "y" ]; then
	read -p "You selected TO TRASH the current repo folder and restart from the latest github repo available. Is this correct? y/n/c " trashIt
	trashIt=$(echo $trashIt | tr '[A-Z]' '[a-z]')

	if [ "$trashIt" = "n" ] ; then
		echo "Let's try this again!"
		yesOrNo
        elif [ "$trashIt" = "y" ] ; then
		echo "Trashing old repo!"
		trashRepo
		buildPage
        elif [ "$trashIt" = "c" ] ; then
		echo "Canceling and KILLING script!"
		exit
	fi

elif [ "$yesOrNo" = "c" ]; then
	echo "Canceling and KILLING script!"
	exit
else
	echo "Please submit a response."
fi
}

clear
echo "Welcome, thanks for using this script by Joe White joe@FreiCoin.US FreiCoin.US"
githubPageUser
githubPageRepo
yesOrNo
