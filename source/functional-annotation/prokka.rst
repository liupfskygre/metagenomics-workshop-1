==================
PROKKA annotation pipeline
==================
Now that you have assembled the data into contigs the next natural step to do is
annotation of the data, i.e. finding the genes and doing functional annotation
of those. A range of programs are available for these tasks but here we will use PROKKA, which is essentially a pipeline comprising several open source bioinformatic tools and databases. PROKKA automates the process of locating open reading frames (ORFs) and RNA regions on contigs, translating ORFs to protein sequences, searching for protein homologs and producing standard output files. For gene finding and translation, PROKKA makes use of the program Prodigal. Homology searching (BLAST, hmmscan) is then performed using the translated protein sequences as queries against a set of public databases (CDD, PFAM, TIGRFAM) as well as custom databases that come with PROKKA.

    /proj/g2014180/

PROKKA produces several types of output, such as:

- the **GFF** file, which is a standardised, tab delimited, file type for showing annotations
- the Genbank (**GBK**) file, which is a more detailed description of nucleotide sequences and the genes encoded on these.

When your dataset has been annotated you can view the annotations directly in the GFF and GBK files, for instance by doing

    less -S PROKKA_*.gbk

**Question: What could be a possible advantage/disadvantage for the assembly
process when assembling multiple samples at one time?**

.. Advantage: more coverage. Disadvantage: more related strains/species makes
.. graph traversal harder

**Question: Can you think of other approaches to get a coassembly?**

.. Maybe map contigs against each other in merge them in that way. Preferably
.. taking coverages into account

Note that all solutions (i.e. the generated outputs) for the exercises are also in::

    /proj/g2014113/metagenomics/cfa/

In all the following exercises you should again use the virtual environment to
get all the necessary programs (unless you already loaded it ofc)::

    source /proj/g2014113/metagenomics/virt-env/mg-workshop/bin/activate

It’s time to run Prodigal. First create an output directory with a copy of the
contig file::

    mkdir -p ~/metagenomics/cfa/prodigal
    cd ~/metagenomics/cfa/prodigal
    cp /proj/g2014113/metagenomics/cfa/assembly/baltic-sea-ray-noscaf-41.1000.fa .

Then run Prodigal on the contig file (~2m20)::

    prodigal -a baltic-sea-ray-noscaf-41.1000.aa.fa \
             -d baltic-sea-ray-noscaf-41.1000.nuc.fa \
             -i baltic-sea-ray-noscaf-41.1000.fa \
             -f gff -p meta \
             > baltic-sea-ray-noscaf-41.1000.gff

This will produce 3 files:

    * ``-d`` a fasta file with the gene sequences (nucleotides)
    * ``-a`` a fasta file with the protein sequences (aminoacids)
    * ``stdout`` a gff file

The gff format is a standardised file type for showing annotations.It’s a tab
delimited file that can be viewed by e.g. ::

    less baltic-sea-ray-noscaf-41.1000.gff

Pass the option -S to less if you don’t want lines to wrap

An explanation of the gff format can be found at
http://genome.ucsc.edu/FAQ/FAQformat.html

**Question: How many coding regions were found by Prodigal? Hint: use grep -c**

.. less *.gff | grep -c 'CDS'
.. 23577

**Question: How many contigs have coding regions? How many do not?**

.. less *.gff | grep '^contig' | grep 'CDS' | awk '{print $1}' | sort -u | wc -l
.. 8517
.. grep -c '^>cont' baltic-sea-ray-noscaf-41.1000.fa 
.. 8533
.. 8533-8517=16
