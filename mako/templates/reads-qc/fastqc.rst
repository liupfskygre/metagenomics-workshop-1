==========================================
Quality Control with fastqc
==========================================
In this excercise you will use fastqc to investigate the quality of your sequences 
using a nice graphical summary output. 

This file needs to be written
============================


Downloading a test set
======================
Today we'll be working on a small metagenomic data set from the anterior nares
(http://en.wikipedia.org/wiki/Anterior_nares).

.. image:: https://raw.github.com/inodb/2013-metagenomics-workshop-gbg/master/images/nostril.jpg


So get ready for your first smell of metagenomic assembly - pun intended. Run
all these commands in your shell::
    
    # Download the reads and extract them
    mkdir -p ~/asm-workshop
    mkdir -p ~/asm-workshop/data
    cd ~/asm-workshop/data
    wget http://downloads.hmpdacc.org/data/Illumina/anterior_nares/SRS018585.tar.bz2
    tar -xjf SRS018585.tar.bz2

If successfull you should have the files::

    $ ls -lh ~/asm-workshop/data/SRS018585/
    -rw-rw-r-- 1 inod inod  36M Apr 18  2011 SRS018585.denovo_duplicates_marked.trimmed.1.fastq
    -rw-rw-r-- 1 inod inod  36M Apr 18  2011 SRS018585.denovo_duplicates_marked.trimmed.2.fastq
    -rw-rw-r-- 1 inod inod 6.4M Apr 18  2011 SRS018585.denovo_duplicates_marked.trimmed.singleton.fastq

If not, try to find out if one of the previous commands gave an error.

Look at the top of the one of the pairs::

    cat ~/asm-workshop/data/SRS018585/SRS018585.denovo_duplicates_marked.trimmed.1.fastq | head

**Question: Can you explain what the different parts of this header mean @HWI-EAS324_102408434:5:100:10055:13493/1?**

Fastqc
======


