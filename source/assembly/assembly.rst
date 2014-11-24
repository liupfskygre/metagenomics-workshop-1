==========================================
Assembling reads with Velvet
==========================================
In this exercise we will learn how to perform an assembly with Velvet. Velvet
takes your reads as input and turns them into contigs. It consists of two
steps. In the first step, ``velveth``, the de Bruijn graph is created.
Afterwards the graph is traversed and contigs are created with ``velvetg``.
When constructing the de Bruijn graph, a *kmer* has to be specified. Reads are
cut up into pieces of length *k*, each representing a node in the graph, edges
represent an overlap (some de Bruijn graph assemblers do this differently, but
the idea is the same). The advantage of using kmer overlap instead of read
overlap is that the computational requirements grow with the number of unique
kmers instead of unique reads. A more detailled explanation can be found at
http://www.nature.com/nbt/journal/v29/n11/full/nbt.2023.html.
For this workshop we will work with the kmer length of 31.

velveth
=======
Create the graph data structure with ``velveth``. First create a directory with symbolic links to the pairs that you
want to use::

    mkdir -p ~/mg-workshop/results/assembly/$SAMPLE/
    cd ~/mg-workshop/results/assembly/$SAMPLE/
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.1.fastq pair1.fastq
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.2.fastq pair2.fastq

The reads need to be interleaved for ``velveth``::

    shuffleSequences_fastq.pl pair1.fastq pair2.fastq pair.fastq

Run velveth, using 31 as the kmer length::

    velveth $SAMPLE 31 -fastq -shortPaired pair.fastq

Check what directories have been created::

    ls

velvetg
=======
To get the actual contigs you will have to run ``velvetg`` on the created
graph. You can vary options such expected coverage and the coverage cut-off if
you want, but we do not do that in this tutorial. We only choose not to do
scaffolding::

    velvetg $SAMPLE -scaffolding no


assemstats
==========
After the assembly one wants to look at the length distributions of the
resulting assemblies. You can use the ``assemstats`` script for that::

    assemstats 100 $SAMPLE/contigs.fa

Try to find-out what each of the stats represent by varying the cut-off. One of
the most often used statistics in assembly length distribution comparisons is
the *N50 length*, a weighted median, where you weight each contig by it's
length. This way you assign more weight to larger contigs. Fifty procent of all
the bases in the assembly are contained in contigs shorter or equal to N50
length.

**Question: What are the important length statistics? Do we prefer sum over
length? Should it be a combination?**
