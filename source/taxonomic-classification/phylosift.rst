===========================================
Phylogenetic Classification using Phylosift
===========================================
In this workshop we'll extract interesting bins from the concoct runs and investigate which species they consists of. We'll start by using a plain'ol BLASTN search and later we'll try a more sophisticated strategy with the program Phylosift.

Phylosift
=========
Phylosift is a software created for the purpose of determining the phylogenetic composition of your metagenomic data. It uses a defined set of genes to predict the taxonomy of each sequence in your dataset. You can read more about how this works here: http://phylosift.wordpress.com. Running phylosift will take some time (roughly 45 min) so lets start running phylosift on the cluster you choose::

    mkdir -p ~/mg-workshop/phylogeny/phylosift/$SAMPLE
    cd ~/mg-workshop/phylogeny/phylosift/$SAMPLE
    ln -s ~/mg-workshop/assembly/$SAMPLE/contigs.fa .
    phylosift all -f --output phylosift_output contigs.fa

While this command is running, go to ncbi web blast service: 

http://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome

Upload your fasta file that you downloaded in the previous step and submit a blast search against the nr/nt database.
Browse through the result and try and see if you can do a taxonomic classification from these.

When the phylosift run is completed, browse the output directory::

    ls ~/binning-workshop/phylosift_output/

All of these files are interesting, but the most fun one is the html file, so lets download this to your own computer and have a look. Again, switch to a terminal where you're not logged in to UPPMAX::

    scp username@milou.uppmax.uu.se:~/binning-workshop/phylosift_output/x.fa.html ~/Desktop/

Did the phylosift result correspond to any results in the BLAST output?

