Extracting rRNA encoding reads
Taxonomic composition of a sample can be based on e.g. BLASTing the contigs against a database of reference genomes, like you will learn how to do tomorrow, or by utilising rRNA sequences. Usually assembly doesn’t work well for rRNA genes due to their highly conserved regions, therefore extracting rRNA from contigs will miss a lot of the taxonomic information that can be obtained by analysing the reads directly. Analysing the reads also has the advantage of being quantitative, i.e. we don’t need to calculate coverages by the mapping procedure we applied for the functional genes above. We will extract rRNA encoding reads with the program sortmeRNA which is one of the fastest softwares for this (the program rnammer that you will use tomorrow is not good for partial rRNA sequences as those on short reads). The program sortmeRNA has built-in multithreading support so this time we use that for parallelization instead of gnu parallel. These are the commands to run:

mkdir -p ~/metagenomics_workshop2/sortmerna
cd ~/metagenomics_workshop2/sortmerna
for s in ${samplenames[*]}; do sortmerna -n 2 --db ~inod/glob/src/sortmerna-1.9/rRNA_databases/silva-arc-16s-database-id95.fasta ~inod/glob/src/sortmerna-1.9/rRNA_databases/silva-bac-16s-database-id85.fasta --I /proj/g2013206/metagenomics/reads/${s}_pe.fasta --accept ${s}_rrna --other ${s}_nonrrna --bydbs -a 8 --log ${s}_bilan -m 5242880; done

Again, this command takes rather long to run (~5m per sample) so just copy the results if you don’t feel like waiting:

cp /proj/g2013206/metagenomics/sortmerna/* ~/metagenomics_workshop2/sortmerna
 
It outputs the reads or part of reads that encode rRNA in a fasta file. These rRNA 
