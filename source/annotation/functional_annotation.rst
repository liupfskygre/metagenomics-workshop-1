=======================================================
Functional Annotation
=======================================================
This part of the workshop has the following exercises:

1. Gene annotation pipeline - PROKKA
2. Predict metabolic pathways using MinPath
3. Quantify genes by mapping reads to the assembly
4. Explore gene annotation using KRONA

PROKKA
=========
Now that you have assembled the data into contigs the next natural step to do is
annotation of the data, i.e. finding the genes and doing functional annotation
of those. A range of programs are available for these tasks but here we will use
`PROKKA <http://www.vicbioinformatics.com/software.prokka.shtml>`_, 
which is essentially a pipeline_ comprising several open source bioinformatic tools and databases. 

PROKKA automates the process of locating open reading frames (ORFs) and RNA regions on contigs, 
translating ORFs to protein sequences, searching for protein homologs and producing standard output files. 
For gene finding and translation, PROKKA makes use of the program `Prodigal <http://prodigal.ornl.gov/>`_.
Homology searching (via BLAST and HMMER) is then performed using the translated protein sequences as queries 
against a set of public databases (`CDD <http://www.ncbi.nlm.nih.gov/cdd/>`_, 
`PFAM <pfam.xfam.org/>`_, `TIGRFAM <http://www.jcvi.org/cgi-bin/tigrfams/index.cgi>`_)
as well as custom databases that come with PROKKA.

Set up the necessary files and run PROKKA, replacing **N** below with the kmer you chose for the assembly step.::
    
    mkdir -p ~/mg-workshop/results/functional_annotation/prokka/
    cd ~/mg-workshop/results/functional_annotation/prokka/
    ln -s ~/mg-workshop/results/assembly/$SAMPLE/${SAMPLE}_N/contigs.fa .
    prokka contigs.fa --outdir $SAMPLE --norrna --notrna --metagenome --cpus 8
    cd $SAMPLE

PROKKA produces several types of output, such as:

- a `GFF <http://genome.ucsc.edu/FAQ/FAQformat.html>`_ file, which is a standardised, tab-delimited, format for genome annotations
- a `Genbank <http://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html>`_ (**GBK**) file, which is a more detailed description of nucleotide sequences and the genes encoded in these.

When your dataset has been annotated you can view the annotations directly in the GFF file. PROKKA names the resulting files according to the current date
like so: ``PROKKA_mmddyyyy``. So if you're following this workshop on a different date than 11222016 or running PROKKA on your own later on you will
have to modify the following commands to match.

Now, take a look at the GFF file by doing::
    
    less -S PROKKA_11222016.gff

You will notice that the first lines in the GFF file show the annotated sequence regions. To skip these and get directly to the annotations you can do::

    grep -v "^#" PROKKA_11222016.gff | less -S

The caret (^) symbol tells grep to match at the beginning of each line and the '-v' flag means that these lines are skipped. The remaining lines are then piped to ``less``.

**Question: How many coding regions were found by Prodigal? Hint: use grep -c to count lines**

Some genes in your dataset should now contain annotations from several databases, such as
`enzyme comission <http://enzyme.expasy.org/>`_ and `COG <http://www.ncbi.nlm.nih.gov/COG/>`_ 
(Clusters of Orthologous Groups) identifiers. 

**Question: How many of the coding regions were given an enzyme identifier? How many were given a COG identifier?**

In the downstream analyses we will quantify and compare the abundance of enzymes and metabolic pathways, as well as COGs in the different samples. To do this, we will first extract lists of the genes with enzyme and COG IDs from the GFF file that was produced by PROKKA.
First we find lines containing enzyme numbers using pattern matching with grep and then reformat the output using a combination of ``cut`` and ``sed`` ::
    
    grep "eC_number=" PROKKA_11222016.gff | cut -f9 | cut -f1,2 -d ';'| sed 's/ID=//g'| sed 's/;eC_number=/\t/g' > PROKKA.$SAMPLE.ec

Then we extract COG identifiers::
    
    egrep "COG[0-9]{4}" PROKKA_11222016.gff | cut -f9 | sed 's/.\+COG\([0-9]\+\);locus_tag=\(PROKKA_[0-9]\+\);.\+/\2\tCOG\1/g' > PROKKA.$SAMPLE.cog

**Make sure you understand what the different parts of these lines of code does. Try removing parts between the pipe ('|') symbols and see how this changes the output.**

The COG table we will save for later. Next up is to predict pathways in the sample based on the enzymes annotated by PROKKA.

.. _pipeline: https://docs.google.com/presentation/d/1zKQtiErPjH9qA5EBjWGH5QhNhxpUxksex16__H0DB8g/edit#slide=id.g438af782d_329
