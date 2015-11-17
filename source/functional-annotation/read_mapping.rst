==================
Mapping reads and quantifying genes
==================

Overview
======================
So far we have only got the number of genes and annotations in the sample. 
Because these annotations are predicted from assembled reads we have lost the quantitatve 
information for the annotations. So to actually **quantify** the genes, we will map the input 
reads back to the assembly.

There are many different mappers available to map your reads back to the
assemblies. Usually they result in a `SAM or BAM file <http://genome.sph.umich.edu/wiki/SAM>`_.
Those are formats that contain the alignment information, where BAM is the binary version of the plain text SAM
format. In this tutorial we will be using `bowtie2 <http://bowtie-bio.sourceforge.net/bowtie2/index.shtml>`_.
You can also take a look at the `Bowtie2 documentation <http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml>`_.

The SAM/BAM file can afterwards be processed with `Picard <http://broadinstitute.github.io/picard/>`_
to remove duplicate reads. Those are likely to
be reads that come from a `PCR duplicate <http://www.biostars.org/p/15818/>`_.

`BEDTools <http://code.google.com/p/bedtools/>`_ can then be used to retrieve
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

    bowtie2 -p 8 -x contigs.fa -1 pair1.fastq -2 pair2.fastq -S $SAMPLE.map.sam

The output SAM file needs to be converted to BAM format. For this we will use
`samtools <http://samtools.sourceforge.net/>`_.
First we create an index of the assembly for samtools::

    samtools faidx contigs.fa

Then the SAM file is converted to BAM format (``view``), sorted by left most alignment 
coordinate (``sort``) and indexed (``index``) for fast random access in these steps::
    
    samtools view -bt contigs.fa.fai $SAMPLE.map.sam > $SAMPLE.map.bam
    samtools sort $SAMPLE.map.bam $SAMPLE.map.sorted
    samtools index $SAMPLE.map.sorted.bam

Removing duplicates
==========================
We will now use **MarkDuplicates** from the Picard tool kit to identify and remove 
duplicates in the sorted and indexed BAM file::

    java -Xms2g -Xmx32g -jar /sw/apps/bioinfo/picard/1.92/milou/MarkDuplicates.jar INPUT=$SAMPLE.map.sorted.bam OUTPUT=$SAMPLE.map.markdup.bam \
    METRICS_FILE=$SAMPLE.map.markdup.metrics AS=TRUE VALIDATION_STRINGENCY=LENIENT \
    MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 REMOVE_DUPLICATES=TRUE

Picard's documentation also exists! Two bioinformatics programs in a row with
decent documentation! Take a moment to celebrate, then take a look `at it 
<http://sourceforge.net/apps/mediawiki/picard/index.php>`_.

**Question: Why not just remove all identical pairs instead of mapping them
and then removing them?**

**Question: What is the difference between samtools rmdup and Picard MarkDuplicates?**

Calculating coverage
==========================
We have now mapped reads back to the assembly and have information on how much of the assembly that is covered by the reads in the sample.
We are interested in the coverage of each of the genes annotated in the previous steps by the PROKKA pipeline. 
To extract this information from the BAM file we first need to define the regions to calculate coverage for. 
This we will do by creating a custom BED file defining the regions of interest (the PROKKA genes).
Here we use an in-house bash script called prokkagff2bed.sh_ that searches for the gene regions in the PROKKA output
and then prints them in a suitable format::

    prokkagff2bed.sh ~/mg-workshop/results/functional_annotation/prokka/$SAMPLE/PROKKA_11242015.gff > $SAMPLE.map.bed
    
We then use `bedtools <https://code.google.com/p/bedtools/>`_ to extract coverage information from the BAM file
for the regions defined in the BED file we just created ::

    bedtools coverage -hist -abam $SAMPLE.map.markdup.bam -b $SAMPLE.map.bed > $SAMPLE.map.hist

Have a look at the output file with ``less`` again. The final four columns give you the 
histogram i.e. coverage, number of bases with that coverage, 
length of the contig/feature/gene, bases with that coverage expressed as a ratio of the
length of the contig/feature/gene.
For each gene, we calculate coverage as c_gene = sum(depth*fraction_at_depth).

This calculation is performed using the in-house script get_coverage_for_genes.py_ ::

    get_coverage_for_genes.py -i <(echo $SAMPLE.map.hist) > $SAMPLE.coverage

We now have coverage values for all genes predicted and annotated by the PROKKA pipeline. Next, we will use the annotations and coverage values to summarize annotations for the sample and produce interactive plots.

**Question: Coverage can also be calculated for each contig. Do you expect the coverage to differ for a contig and for the genes encoded on the contig? When might it be a good idea to calculate the latter?**

.. _get_coverage_for_genes.py: https://github.com/EnvGen/metagenomics-workshop/blob/master/in-house/get_coverage_for_genes.py
.. _prokkagff2bed.sh: https://github.com/EnvGen/metagenomics-workshop/blob/master/in-house/prokkagff2bed.sh
