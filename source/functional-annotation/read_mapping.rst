==================
Mapping reads and quantifying genes
==================

Overview
======================
So far we have only got the number of genes and annotations in the sample. Because these annotations are predicted from assembled reads we have lost the quantitatve information for the annotations. So to actually quantify the genes we will map the input reads back to the assembly.

There are many different mappers available to map your reads back to the
assemblies. Usually they result in a SAM or BAM file
(http://genome.sph.umich.edu/wiki/SAM). Those are formats that contain the
alignment information, where BAM is the binary version of the plain text SAM
format. In this tutorial we will be using bowtie2
(http://bowtie-bio.sourceforge.net/bowtie2/index.shtml).


The SAM/BAM file can afterwards be processed with Picard
(http://picard.sourceforge.net/) to remove duplicate reads. Those are likely to
be reads that come from a PCR duplicate (http://www.biostars.org/p/15818/).


BEDTools (http://code.google.com/p/bedtools/) can then be used to retrieve
coverage statistics.


There is a script available that does it all at once. Read it and try to
understand what happens in each step::
    
    less `which map-bowtie2-markduplicates.sh`
    map-bowtie2-markduplicates.sh -h

Bowtie2 has some nice documentation: http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml

**Question: what does bowtie2-build do?**

Picard's documentation also exists! Two bioinformatics programs in a row with
decent documentation! Take a moment to celebrate, then have a look here:
http://sourceforge.net/apps/mediawiki/picard/index.php 

**Question: Why not just remove all identitical pairs instead of mapping them
and then removing them?**

**Question: What is the difference between samtools rmdup and Picard MarkDuplicates?**

Mapping reads with bowtie2
==========================

Use this command to run the actual mapping of reads.

    # Create a new directory and link files
    
    mkdir -p ~/mg-workshop/mapping/bowtie2
    
    cd ~/mg-workshop/mapping/bowtie2
    
    map-bowtie2-markduplicates.sh -t 2 -c ~/mg-workshop/data/reads/$SAMPLE_ID.1.fastq ~/mg-workshop/data/reads/$SAMPLE_ID.1.fastq $SAMPLE ~/mg-workshop/assembly/$SAMPLE/contigs.fa all ~/mg-workshop/mapping/bowtie2/ > map.log 2>map.err
