==========================================
Quality Control with fastqc
==========================================
In this excercise you will use fastqc to investigate the quality of your sequences 
using a nice graphical summary output. 

Retrieving your data
====================
For the first step, make a workshop folder in your home directory and move into it::

	mkdir metagen
	cd metagen

Inside it, make a folder for your input files::

	mkdir reads

Now make a copy of the files you want to work on: gut, skin or teeth datasets. These
files were originally taken from the `Human Microbiome Project <http://hmpdacc.org/>`_ and then subsampled
to include only 1 million reads each. You can copy these files from the project directory::

	cp /proj/g2014180/nobackup/metagenomics-workshop/data/<sample>/reads/1M/*1.fastq reads/reads.1.fastq
	cp /proj/g2014180/nobackup/metagenomics-workshop/data/<sample>/reads/1M/*2.fastq reads/reads.2.fastq

Please notice that you have to replace <sample> for either gut, skin or teeth to get the
right files. You will now have two files in your reads directory: one for the forward reads
(reads.1.fastq) and one for the reverse reads (reads.2.fastq).

Fastqc
======
We will now use FastQC to generate a report about the quality of our sequencing reads.
For most programs and scripts in this workshop, you can see their instructions by typing
their name in the terminal followed by the flag -h. There are many options available,
and we'll show you only a few of those.

First, make a folder to keep your quality control results::

	mkdir qc

Now, run fastqc for each file::

	fastqc -o qc/ --nogroup reads/reads.1.fastq reads/reads.2.fastq

FastQC will generate two files for each input file, one compressed, and one not. To view
your files, copy the html results into your local computer and open them with a browser.
From your own shell (not inside Uppmax!)::

	scp -r username@milou.uppmax.uu.se:~/metagen/qc/*html .

Instead of username, type your own username!

Now open the reports. Make sure you understand the results. Do they look ok? Is there a 
difference between forward and reverse? Are there any warnings or errors? What do they mean?
