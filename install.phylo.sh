#!/bin/bash

#Run this to :
#Download and install NCBI BLAST
#Install pip
#use pip to install Dendropy
#Download a reference genome
#download scripts from vinson's guthub
#download Biopython tools


date
sudo apt-get install -y software-properties-common
sudo apt-get -y update
sudo apt-get -y install ncbi-blast+
sudo apt-get -y install python-pip
sudo pip install -U dendropy
wget https://github.com/vinsondoyle/genbankProcessing/archive/master.zip
unzip master.zip
sudo cp genbankProcessing-master/*py /usr/local/bin
pip install biopython
sudo apt-get install -y ncbi-blast+
#Install efetch (ncbi tools) by pasting install.efetch.txt into terminal
date

