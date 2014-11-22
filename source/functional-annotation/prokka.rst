==================
Functional annotation
==================
Now that you have assembled the data into contigs the next natural step to do is
annotation of the data, i.e. finding the genes and doing functional annotation
of those. A range of programs are available for these tasks but here we will use PROKKA, which is essentially a pipeline comprising several open source bioinformatic tools and databases. PROKKA automates the process of locating open reading frames (ORFs) and RNA regions on contigs, translating ORFs to protein sequences, searching for protein homologs and producing standard output files. For gene finding and translation, PROKKA makes use of the program Prodigal. Homology searching (BLAST, hmmscan) is then performed using the translated protein sequences as queries against a set of public databases (CDD, PFAM, TIGRFAM) as well as custom databases that come with PROKKA.

    PROKKA COMMAND GOES HERE

PROKKA produces several types of output, such as:

- the **GFF** file, which is a standardised, tab delimited, file type for showing annotations
- the Genbank (**GBK**) file, which is a more detailed description of nucleotide sequences and the genes encoded on these.
An explanation of the gff format can be found at
http://genome.ucsc.edu/FAQ/FAQformat.html.

An explanation of the Genbank format can be found at
http://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html

When your dataset has been annotated you can view the annotations directly in the GFF and GBK files, for instance by doing

    less -S PROKKA_11252014.gbk

**Question: How many coding regions were found by Prodigal? Hint: use grep -c**

Some genes in your dataset should now contain annotations from several databases, for instance enzyme and COG (Clusters of Orthologous Groups) identifiers. 

**Question: How many of the coding regions were given an enzyme identifier? How many were given a COG identifier?**

In the downstream analyses we will quantify and compare the abundance of enzymes and metabolic pathways, as well as COGs in the different samples. To do this, we will first extract lists of the genes with enzyme and COG IDs from the GFF file that was produced by PROKKA.
First we extract enzyme numbers for genes using pattern matching:

    grep "eC_number=" PROKKA_11252014.gff | cut -f9 | cut -f1,2 -d ';'| sed 's/ID=//g'| sed 's/;eC_number=/\t/g' > PROKKA.$SAMPLE.ec

Then we do the same for COG identifiers:

    egrep "COG[0-9]{4}" PROKKA_11252014.gff | cut -f9 | sed 's/.\+COG\([0-9]\+\);locus_tag=\(PROKKA_[0-9]\+\);.\+/\2\tCOG\1/g' > PROKKA.$SAMPLE.cog

The COG table we will save for later. Next up is to predict pathways in the sample based on the enzymes annotated by PROKKA. 

===============
Predicting metabolic pathways using MinPath
===============
Metabolic pathways are made up of enzymes that catalyze various reactions. Depending on how pathways are defined, they may contain any number of enzymes. A single enzyme may also be part of one or several pathways. One way of predicting metabolic pathways in a sample is to simply consider all the pathways that a set of enzymes are involved in. This may however overestimate pathways, for instance if only a few of the enzymes required for a pathway are annotated in the sample. 

Here we will predict pathways using the program MinPath to get conservative estimate of the pathways present. MinPath only considers the minimum number of pathways required to explain the set of enzymes in the sample. As input, MinPath requires 1) a file with gene identifiers and enzyme numbers, separated by tabs, and 2) a file that links each enzyme to one or several pathways. The first of these we produced above using pattern matching from the PROKKA gff file. The second file exist in two versions, one that links enzymes to pathways defined in the Metacyc database and one that links enzymes to pathways defined in the KEGG database.

Metacyc file

    data/db/metacyc/ec.to.pwy
    
KEGG file

    data/db/kegg/ec.to.pwy

Run MinPath with this command to predict Metacyc pathways

    MinPath1.2.py -any PROKKA.$SAMPLE.ec -map data/db/metacyc/ec.to.pwy -report PROKKA.$SAMPLE.metacyc.minpath

And to predict KEGG pathways

    MinPath1.2.py -any PROKKA.$SAMPLE.ec -map data/db/kegg/ec.to.pwy -report PROKKA.$SAMPLE.kegg.minpath
