===========================================
Phylogenetic Classification using Phylosift
===========================================
In this section, we will investigate our contigs with Phylosift, to investigate from which species they originate.

Phylosift
=========
Phylosift is software created for the purpose of determining the phylogenetic composition of metagenomic data. 
It uses a defined set of genes to predict the taxonomy of each sequence in your dataset. 
You can read more about how this works here: http://phylosift.wordpress.com.
Let's prepare for the phylosift run in the usual way::


    mkdir -p ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    cd ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    ln -s ~/mg-workshop/results/assembly/$SAMPLE/${SAMPLE}_N/contigs.fa .

Phylosift can be run using raw sequencing reads directly, but it excels at classifying contigs.
Classification is performed in several sequential steps_, starting with a search for conserved 
marker genes in the data. We will run phylosift in parallel (8 cores), in the background::
    
    phylosift search --threads 8 --debug --output phylosift_output contigs.fa > phylosift.log 2> phylosift.err &

You can check the progress of the run by having a look at the file **phylosift_output/run_info.txt** or, if you want more detailed info, **phylosift.log**. 
    
When the run finishes you will have a directory called 'blastDir' inside the main phylosift
output directory. Phylosift uses a program called `LAST <http://last.cbrc.jp/>`_, which is similar to 
BLAST but much faster, to identify sequences matching a set of marker genes among your sequences.

In the subsequent steps these sequences are aligned to reference marker alignments using **hmmalign**
of the `HMMER suite <http://hmmer.janelia.org/>`_. 
Alignments are then used to place each identified sequence into a phylogenetic reference tree using
the program `pplacer <http://matsen.fhcrc.org/pplacer/>`_.
Finally, all placements are evaluated and summarized.

Notice that we give the --continue flag to phylosift, telling it to continue from the previous step in the analysis.::

    phylosift align --threads 8 --debug --continue --output phylosift_output contigs.fa >> phylosift.log 2> phylosift.err &

When this step is complete the main output directory will contain an 'alignDir' with alignments from
**hmmalign** and a 'treeDir' with placement files from **pplacer**.

*Unfortunately, the phylosift takes a failry long time.* So if you can't afford to wait for it, 
you can choose to copy the results from the project directory::

    cp -r /proj/g2015028/nobackup/metagenomics-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/

When all phylosift runs are completed (or copied), browse the output directory::

    ls ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output/

All of these files are interesting, but the most fun one is the html file, so let's download this 
to your own computer and have a look.
**Again, switch to a terminal where you're not logged in to UPPMAX**::

    mkdir ~/mg-workshop/
    scp username@milou.uppmax.uu.se:~/mg-workshop/results/phylogeny/phylosift/phylosift_output/*.html ~/mg-workshop/


**Question: Compare with the taxonomic results from the 16S analysis. Do the results match? If not, what could be the explanation for the differences?**

.. _steps: https://docs.google.com/presentation/d/1zKQtiErPjH9qA5EBjWGH5QhNhxpUxksex16__H0DB8g/edit#slide=id.g438af782d_325
