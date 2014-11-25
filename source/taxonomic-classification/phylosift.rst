===========================================
Phylogenetic Classification using Phylosift
===========================================
In this section investigate our contigs with Phylosift to see which species they originate from.

Phylosift
=========
Phylosift is software created for the purpose of determining the phylogenetic composition of your metagenomic data. It uses a defined set of genes to predict the taxonomy of each sequence in your dataset. You can read more about how this works here: http://phylosift.wordpress.com. Lets prepare for the phylosift run::


    mkdir -p ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    cd ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    ln -s ~/mg-workshop/results/assembly/$SAMPLE/${SAMPLE}_31/contigs.fa .

You can run phylosift using the following command:: 
    
    cd ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE
    phylosift all -f --output phylosift_output contigs.fa &

You can check the progress of the phylosift run by running the following command (You can repeat this)::
    
    cat ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output/run_info.txt

*Unfortunately, the phylosift run is taking a long time.* So if you don't have time to wait for it, in order to have some nice results to study, we'll copy the results from the project directory::

    cp -r /proj/g2014180/nobackup/metagenomics-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/

When the phylosift run is completed, browse the output directory::

    ls ~/mg-workshop/results/phylogeny/phylosift/$SAMPLE/phylosift_output/

All of these files are interesting, but the most fun one is the html file, so lets download this to your own computer and have a look.
**Again, switch to a terminal where you're not logged in to UPPMAX**::

    mkdir ~/mg-workshop/
    scp username@milou.uppmax.uu.se:~/mg-workshop/results/phylogeny/phylosift/phylosift_output/*.html ~/mg-workshop/


**Question: Compare with the taxonomic results from the 16S analysis. Do the results match? If not, what could be the explanation for the differences?**

