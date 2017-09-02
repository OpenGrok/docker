#!/bin/bash 
#INDEXING OF OPENGROK
date +"%R Indexing starting">>/opengrok/indexing.log
/opengrok/bin/OpenGrok index /src >>/opengrok/indexing.log
date +"%R Indexing finishing">>/opengrok/indexing.log
