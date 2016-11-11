========================================
Taxonomic annotation
========================================


DIAMOND
=========
DIAMOND_ is a fast alternative to BLAST for homology searches of DNA or protein sequences.

First get the files ready::

    mkdir -p ~/mg-workshop/results/annotation/mapping/$SAMPLE/
    cd ~/mg-workshop/results/annotation/mapping/$SAMPLE
    ln -s ~/mg-workshop/results/annotation/functional_annotation/$SAMPLE/PROKKA_${date}.faa $SAMPLE.faa


Run DIAMOND on your protein fasta file::

    diamond blastp --threads 8 --query $SAMPLE.faa --db $DIAMOND_CUSTOMDB --daa $SAMPLE.search_result



.. _DIAMOND: http://ab.inf.uni-tuebingen.de/software/diamond/
