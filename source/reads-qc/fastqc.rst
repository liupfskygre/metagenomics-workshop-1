==========================================
Quality Control with fastqc
==========================================
In this excercise you will use fastqc to investigate the quality of your sequences 
using a nice graphical summary output. 

Retrieving your data
====================
For the first step, make a workshop folder in your home directory and move into it::

	mkdir mg-workshop
	cd mg-workshop

Inside it, make a folder for your input files:

	mkdir -p data/$SAMPLE/reads/1M/
	cd data/$SAMPLE/

Now make a copy of the files you want to work on: gut, skin or teeth datasets. These
files were originally taken from the `Human Microbiome Project <http://hmpdacc.org/>`_ and then subsampled
to include only 1 million reads each. You can copy these files from the project directory:

	cp /proj/g2014180/nobackup/metagenomics-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1.fastq reads/1M/
	cp /proj/g2014180/nobackup/metagenomics-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_2.fastq reads/1M/

You will now have two files in your reads directory: one for the forward reads
(\*_1.fastq) and one for the reverse reads (\*_2.fastq).

Fastqc
======
We will now use FastQC to generate a report about the quality of our sequencing reads.
For most programs and scripts in this workshop, you can see their instructions by typing
their name in the terminal followed by the flag -h. There are many options available,
and we'll show you only a few of those.

First, make a folder to keep your quality control results:

	mkdir -p ~/mg-workshop/results/quality_check/$SAMPLE/

Now, run fastqc for each file:

	fastqc -o ~/mg-workshop/results/quality_check/$SAMPLE/ --nogroup reads/1M/${SAMPLE_ID}_1.fastq reads/1M/${SAMPLE_ID}_2.fastq

FastQC will generate two files for each input file, one compressed, and one not. To view
your files, copy the html results into your local computer and open them with a browser.
From your own shell (not inside Uppmax!):

	scp -r username@milou.uppmax.uu.se:~/mg-workshop/results/quality_check/$SAMPLE/\*html .

Instead of username, type your own username!

Now open the reports. Make sure you understand the results. Do they look ok? Is there a 
difference between forward and reverse? Are there any warnings or errors? What do they mean?
