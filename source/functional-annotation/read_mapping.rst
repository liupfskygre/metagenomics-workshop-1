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
(http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). You can take a look at the Bowtie2 documentation at: http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml.


The SAM/BAM file can afterwards be processed with Picard
(http://broadinstitute.github.io/picard/) to remove duplicate reads. Those are likely to
be reads that come from a PCR duplicate (http://www.biostars.org/p/15818/).


BEDTools (http://code.google.com/p/bedtools/) can then be used to retrieve
coverage statistics.


Mapping reads with bowtie2
==========================
First set up the files needed for mapping::
    
    mkdir -p ~/mg-workshop/results/functional_annotation/mapping/$SAMPLE/
    cd ~/mg-workshop/results/functional_annotation/mapping/$SAMPLE/
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.1.fastq pair1.fastq
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.2.fastq pair2.fastq
    ln -s /proj/g2015028/nobackup/metagenomics-workshop/results/assembly/$SAMPLE/${SAMPLE}_31/contigs.fa

Then run the ``bowtie2-build`` program on your assembly::

    bowtie2-build contigs.fa contigs.fa

**Question: What does bowtie2-build do? (Refer to the documentation)**

Next we run the actual mapping using ``bowtie2``::

    bowtie2 -p 16 -x contigs.fa -1 pair1.fastq -2 pair2.fastq -S $SAMPLE.map.sam

The output SAM file needs to be converted to BAM format. For this we will use ``samtools``. First we create an index of the assembly for samtools::

    samtools faidx contigs.fa

Then the SAM file is converted to BAM format (``view``), sorted by left most alignment coordinate (``sort``) and indexed (``index``) for fast random access in these steps::
    
    samtools view -bt contigs.fa.fai $SAMPLE.map.sam > $SAMPLE.map.bam
    samtools sort $SAMPLE.map.bam $SAMPLE.map.sorted
    samtools index $SAMPLE.map.sorted.bam

We will now use **MarkDuplicates** from the Picard tool kit to identify and remove duplicates in the sorted and indexed BAM file::

    java -Xms2g -Xmx32g -jar $MRKDUP INPUT=$SAMPLE.map.sorted.bam OUTPUT=$SAMPLE.map.markdup.bam \
    METRICS_FILE=$SAMPLE.map.markdup.metrics AS=TRUE VALIDATION_STRINGENCY=LENIEN \
    MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 REMOVE_DUPLICATES=TRUE

Picard's documentation also exists! Two bioinformatics programs in a row with
decent documentation! Take a moment to celebrate, then have a look here:
http://sourceforge.net/apps/mediawiki/picard/index.php 

**Question: Why not just remove all identical pairs instead of mapping them
and then removing them?**

**Question: What is the difference between samtools rmdup and Picard MarkDuplicates?**
   
Then run the script that performs the mapping::
    
    map-bowtie2-markduplicates.sh -t 16 -c pair1.fastq pair2.fastq $SAMPLE contigs.fa all map > map.log 2>map.err

Calculating coverage
==========================
We have now mapped reads back to the assembly and have information on how much of the assembly that is covered by the reads in the sample. What we are interested in is the coverage of the genes annotated in the previous steps by the PROKKA pipeline. To extract this information from the BAM file we first need to define the regions to calculate coverage for. This we will do by creating a custom BED file defining the regions of interest (the PROKKA genes)::

    prokkagff2bed.sh ~/mg-workshop/results/functional_annotation/prokka/$SAMPLE/PROKKA_11242015.gff > $SAMPLE.map.bed
    
Next we extract coverage information from the BAM file for each gene in the GFF file we just created. We will use the bedtools coverage command within the BEDTools suite (https://code.google.com/p/bedtools/) that can parse a SAM/BAM file and a gff file to extract coverage information for every gene::

    bedtools coverage -hist -abam map/all_$SAMPLE-smds.bam -b $SAMPLE.map.bed > $SAMPLE.map.hist

Have a look at the output file with less again. The final four columns give you the histogram i.e. coverage, number of bases with that coverage, length of the contig/feature/gene, bases with that coverage expressed as a ratio of the length of the contig/feature/gene.

To summarize the coverage for each gene we will use a script that calculates coverage from the histogram file you just produced::

    get_coverage_for_genes.py -i <(echo $SAMPLE.map.hist) > $SAMPLE.coverage

We now have coverage values for all genes predicted and annotated by the PROKKA pipeline. Next, we will use the annotations and coverage values to summarize annotations for the sample and produce interactive plots.
