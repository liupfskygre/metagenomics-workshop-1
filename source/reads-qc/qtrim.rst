====================================================
Optional: Quality trimming Illumina paired-end reads
====================================================
In this excercise you will learn how to quality trim Illumina paired-end reads.
The most common Next Generation Sequencing (NGS) technology for metagenomics.
The reads from the HMP are already quality trimmed. However, if you have time
and want to try it out for yourself, you can run some more stringent quality 
trimming on them and see what happens.

Running sickle on a paired end library
======================================
For quality trimming Illumina paired end reads we use the library sickle which
trims reads from 3' end to 5' end using a sliding window. If the mean quality
drops below a specified number the remaining part of the read will be trimmed.

As a default, sickle trims a read at the point needed to maintain its average
quality over 20. It also discards reads that are shorter than 20 bp. These are
very good default values, but in this extra exercice you're welcome to change the
values of these parameters using the -q and -l flags.

You can use the same qc directory as before for this step, since these reads 
won't be further processed.

Run sickle::

	sickle pe -f reads/reads.1.fastq -r reads/reads.2.fastq -t sanger -o qc/qtrim.1.fastq -p qtrim.2.fastq -s qtrim.unpaired.fastq -q <minqual> -l <minlen>


Chek what files have been generated. Do you understand each of them?

**Question: How many paired reads are left after trimming? How many singletons?**

**Question: What are the different quality scores that sickle can handle? Why do we specify -t sanger here?**

Run fastqc again
================
We would like to see if sickle has done a good job, we do so by asserting the quality of the
reads again with fastqc. Please refer to the FastQC exercise for instructions on how to do this.

