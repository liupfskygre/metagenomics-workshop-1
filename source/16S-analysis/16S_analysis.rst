==========================================
Community analysis using rRNA gene reads
==========================================
In this exercise we will analyse the taxonomic composition of your sample by utilising 16S rRNA 
encoding sequence reads. Partial 16S rRNA genes will be extracted from the reads using the program 
sortmeRNA and these will subsequenctly be classified using the RDP classifier. Finally, the results 
will be visualised with the interactive program KRONA.


SortmeRNA
=======
We will extract 16S rRNA encoding reads using sortmeRNA which is one of the fastest software for this. 
The program has built-in multithreading support that we will use for parallelization.
These are the commands to use::

    mkdir -p ~/metagenomics_workshop/sortmerna
    cd ~/metagenomics_workshop/sortmerna
    sortmerna -n 2 --db ~inod/glob/src/sortmerna-1.9/rRNA_databases/silva-arc-16s-database-id95.fasta ~inod/glob/src/sortmerna-1.9/rRNA_databases/silva-bac-16s-database-id85.fasta --I /proj/g2013206/metagenomics/reads/${s}_pe.fasta --accept ${s}_rrna --other ${s}_nonrrna --bydbs -a 8 --log ${s}_bilan -m 5242880; done


RDP classifier
=======
sortmeRNA outputs the reads or part of reads that encode rRNA in a fasta file. These rRNA 
sequences can be classified in many ways, blasting them against a suitable database is one option. 
Here we use a simple and fast method, the classifier tool at RDP (the ribosomal database project). 
This uses a naive bayesian classifier trained on kmer frequencies of many sequences of defined taxonomies. 
It gives bootstrap support values for each taxonomic level; usually the support gets lower the further 
down the hierarchy you go. Genus level is the lowest level provided. You can use the web service 
if you prefer, and upload each file individually, or you can use the uppmax installation of RDP 
classifier like this (~4m)::

    mkdir -p ~/metagenomics_workshop/rdp
    cd ~/metagenomics_workshop/rdp
    for s in ../sortmerna/*_rrna*.fasta; do 
    java -Xmx1g -jar /gulo/glob/inod/src/rdp_classifier_2.6/dist/classifier.jar classify -g 16srrna -b ${s}.bootstrap -h ${s}.hier.tsv -o ${s}.class.tsv ${s}; done


KRONA
=======
To get a graphical representation of the taxonomic classifications you can use KRONA, which is an 
excellent program for exploring data with hierarchical structures in general. The output file is an 
html file that can be viewed in a browser. 
Again make a directory for KRONA::

    mkdir -p ~/metagenomics_workshop/krona
    cd ~/metagenomics_workshop/krona


And run KRONA, concatenating the archaea and bacteria class files together at the same time like this 
and providing the name of the sample::

    /gulo/glob/inod/src/KronaTools-2.4/bin/bin/ktImportRDP <(cat ../rdp/0328_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0328_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0328 <(cat ../rdp/0403_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0403_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0403 <(cat ../rdp/0423_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0423_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0423 <(cat ../rdp/0531_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0531_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0531 <(cat ../rdp/0619_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0619_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0619 <(cat ../rdp/0705_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0705_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0705 <(cat ../rdp/0709_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/0709_rrna.silva-bac-16s-database-id85.fasta.class.tsv),0709 <(cat ../rdp/1001_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/1001_rrna.silva-bac-16s-database-id85.fasta.class.tsv),1001 <(cat ../rdp/1004_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/1004_rrna.silva-bac-16s-database-id85.fasta.class.tsv),1004 <(cat ../rdp/1028_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/1028_rrna.silva-bac-16s-database-id85.fasta.class.tsv),1028 <(cat ../rdp/1123_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/1123_rrna.silva-bac-16s-database-id85.fasta.class.tsv),1123

The <() in bash can be used for process substitution (http://tldp.org/LDP/abs/html/process-sub.html). Just for your information, the above command was actually generated with the following commands:

cmd=`echo /gulo/glob/inod/src/KronaTools-2.4/bin/bin/ktImportRDP; for s in ${samplenames[*]}; do echo '<('cat ../rdp/${s}_rrna.silva-arc-16s-database-id95.fasta.class.tsv ../rdp/${s}_rrna.silva-bac-16s-database-id85.fasta.class.tsv')',$s; done`
echo $cmd

Copy the resulting file rdp.krona.html to your local computer with scp and open it in firefox.











