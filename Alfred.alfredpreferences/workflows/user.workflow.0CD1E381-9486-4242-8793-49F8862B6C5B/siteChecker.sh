#!/bin/bash
. workflowHandler.sh

# create temporary directory if it doesn't exist
if [ ! -d ~/"Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/com.danieljchen.sitechecker/" ]; then
	mkdir ~/"Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/com.danieljchen.sitechecker"
fi
 
# grab website and store in temp file
curl -s "http://isup.me/$1" > ~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/com.danieljchen.sitechecker/temp.html 

curlResponse=$?

# added result in the case that curl fails
if [ $curlResponse -gt 0 ]; then
	addResult "$1" "Search failed. Curl exit code: $curlResponse" "Input: $1" "icon.png" "no" "$1"
	getXMLResults
fi

# if greater than one, then the website is up.
upValue=`grep "It's just you." ~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/com.danieljchen.sitechecker/temp.html | wc -l`
extraCheck=`grep "it's just you." ~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/com.danieljchen.sitechecker/temp.html | wc -l` # for isup.me
let upValue+=extraCheck 

notWebsite=`grep "site on the interwho" ~/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow\ Data/com.danieljchen.sitechecker/temp.html | wc -l`

if [ $upValue -ge 1 ]; then
		addResult "$1" "The site is up." "Input: $1" "icon.png" "yes" ""
	elif [ $notWebsite -ge 1 ]; then
		addResult "$1" "Not a valid site." "Input: $1" "icon.png" "no" "$1"
	else
		addResult "$1" "The site is down." "Input: $1" "icon.png" "no" "$1"
fi

getXMLResults