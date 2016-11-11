========================================
Taxonomic annotation
========================================

In this part we will add taxonomic information to the identified protein sequences in our sample. We will do this by searching for homologs to our sequences in a reference database, then add the taxonomic information of the best matching reference sequences 


DIAMOND
=========
DIAMOND_ is a program for finding homologs of protein and DNA sequences in a reference database. It claims to be up to 20,000 times faster than Blast, especially when dealing with short reads such as those produced by Illumina sequencing. Like Blast, DIAMOND requires a formatted database. There are several pre-formatted databases available on Uppmax and you can access these directly with environmental variables such as:

    - $DIAMOND_NR           (/sw/data/uppnex/diamond_databases/Blast/latest/nr.dmnd)

These databases are usually rather large and therefore take a lot of time to search, even at 20,000 times the speed of Blast. For this workshop we have created a light-weight database using sequences from UniRef90_. This database contains sequences from UniRef but is clustered at the 90% amino acid identity level which reduces the number of sequences to search through by **a lot**, and thereby also the search time. However, for real-world cases we recommend that you use more comprehensive databases such as **nr**.

The custom database is stored at /sw/courses/metagenomicsAndSingleCellAnalysis/nobackup/metagenomics-workshop/reference_db/uniprot/uniref90_nr.dmnd but as part of the activate script this path has been saved in the variable $DIAMOND_CUSTOMDB.

First get the files ready::

    mkdir -p ~/mg-workshop/results/annotation/mapping/$SAMPLE/
    cd ~/mg-workshop/results/annotation/mapping/$SAMPLE
    ln -s ~/mg-workshop/results/annotation/functional_annotation/prokka/$SAMPLE/PROKKA_${date}.faa $SAMPLE.faa

Run DIAMOND on your protein fasta file::

    diamond blastp --threads 8 --query $SAMPLE.faa --db $DIAMOND_CUSTOMDB --daa $SAMPLE.search_result

The results are stored in a binary format so to see it in plain text you need to convert with `diamond view`::

    diamond view -a $SAMPLE.search_result.daa > $SAMPLE.search_result.tab

Now you can have a look at the result with `less`::

    less $SAMPLE.search_result.tab

You'll find that the output format is identical to the Blast tabular output.


MEGAN
=========
Assign taxonomy to sequences using MEGAN_.

.. _DIAMOND: http://ab.inf.uni-tuebingen.de/software/diamond/
.. _UniRef90: ftp://ftp.uniprot.org/pub/databases/uniprot/uniref/uniref90/README
.. _MEGAN: http://ab.inf.uni-tuebingen.de/software/megan6/
