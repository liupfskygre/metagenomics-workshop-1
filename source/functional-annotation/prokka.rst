==================
Annotating the assembly using the PROKKA pipeline
==================
Now that you have assembled the data into contigs the next natural step to do is
annotation of the data, i.e. finding the genes and doing functional annotation
of those. A range of programs are available for these tasks but here we will use PROKKA, which is essentially a pipeline comprising several open source bioinformatic tools and databases. PROKKA automates the process of locating open reading frames (ORFs) and RNA regions on contigs, translating ORFs to protein sequences, searching for protein homologs and producing standard output files. For gene finding and translation, PROKKA makes use of the program Prodigal. Homology searching (BLAST, hmmscan) is then performed using the translated protein sequences as queries against a set of public databases (CDD, PFAM, TIGRFAM) as well as custom databases that come with PROKKA.

Set up the necessary files and run PROKKA::
    
    mkdir ~/mg-workshop/results/$SAMPLE/functional_annotation/prokka/
    cd ~/mg-workshop/results/$SAMPLE/functional_annotation/prokka/
    ln -s ~/mg-workshop/results/$SAMPLE/assembly/contigs.fa
    PROKKA COMMAND GOES HERE

PROKKA produces several types of output, such as:

- the **GFF** file, which is a standardised, tab delimited, file type for showing annotations
- the Genbank (**GBK**) file, which is a more detailed description of nucleotide sequences and the genes encoded on these.
An explanation of the gff format can be found at
http://genome.ucsc.edu/FAQ/FAQformat.html.

An explanation of the Genbank format can be found at
http://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html

When your dataset has been annotated you can view the annotations directly in the GFF and GBK files, for instance by doing::
    
    less -S PROKKA_11252014.gbk

**Question: How many coding regions were found by Prodigal? Hint: use grep -c**

Some genes in your dataset should now contain annotations from several databases, for instance enzyme and COG (Clusters of Orthologous Groups) identifiers. 

**Question: How many of the coding regions were given an enzyme identifier? How many were given a COG identifier?**

In the downstream analyses we will quantify and compare the abundance of enzymes and metabolic pathways, as well as COGs in the different samples. To do this, we will first extract lists of the genes with enzyme and COG IDs from the GFF file that was produced by PROKKA.
First we extract enzyme numbers for genes using pattern matching::
    
    grep "eC_number=" PROKKA_11252014.gff | cut -f9 | cut -f1,2 -d ';'| sed 's/ID=//g'| sed 's/;eC_number=/\t/g' > PROKKA.$SAMPLE.ec

Then we do the same for COG identifiers::
    
    egrep "COG[0-9]{4}" PROKKA_11252014.gff | cut -f9 | sed 's/.\+COG\([0-9]\+\);locus_tag=\(PROKKA_[0-9]\+\);.\+/\2\tCOG\1/g' > PROKKA.$SAMPLE.cog

The COG table we will save for later. Next up is to predict pathways in the sample based on the enzymes annotated by PROKKA.
