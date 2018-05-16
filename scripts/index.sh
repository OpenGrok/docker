#!/bin/bash

date +"%F %T Indexing starting"
/opengrok/bin/OpenGrok index /src
date +"%F %T Indexing finishing"
