===========================================
Phylogenetic Classification using Phylosift
===========================================
In this section investigate our contigs with Phylosift to see which species they originate from.

Phylosift
=========
Phylosift is software created for the purpose of determining the phylogenetic composition of your metagenomic data. It uses a defined set of genes to predict the taxonomy of each sequence in your dataset. You can read more about how this works here: http://phylosift.wordpress.com. Running phylosift will take some time (roughly 45 min) so lets start running phylosift::

    mkdir -p ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    cd ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    ln -s ~/mg-workshop/results/assembly/$SAMPLE/${SAMPLE}_31/contigs.fa .
    phylosift all -f --output phylosift_output contigs.fa

You can check the progress of the phylosift run by browsing the file*::
    
    cat ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output/run_info.txt

*If the phylosift run is taking too long time*, copy the results from the project directory::

    cp -r /proj/g2014180/nobackup/metagenomics-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/

When the phylosift run is completed, browse the output directory::

    ls ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output/

All of these files are interesting, but the most fun one is the html file, so lets download this to your own computer and have a look.
**Again, switch to a terminal where you're not logged in to UPPMAX**::

    mkdir ~/mg-workshop/
    scp username@milou.uppmax.uu.se:~/mg-workshop/results/phylogeny/phylosift/phylosift_output/*.html ~/mg-workshop/

