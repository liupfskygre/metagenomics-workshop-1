========================================
Community analysis using rRNA gene reads
========================================
In this exercise we will analyse the taxonomic composition of your sample by utilising 16S rRNA 
encoding sequence reads. Partial 16S rRNA genes will be extracted from the reads using the program 
sortmeRNA and these will subsequenctly be classified using the RDP classifier. Finally, the results 
will be visualised with the interactive program KRONA.


SortmeRNA
=========
We will extract 16S rRNA encoding reads using sortmeRNA_ which is one of the fastest software for this. 
We start by making the necessary folders and assigning all necessary databases to a variable called DB::

	mkdir -p ~/mg-workshop/results/phylogeny/16S/$SAMPLE
	cd ~/mg-workshop/results/phylogeny/16S/$SAMPLE
	ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.1.fastq reads.1.fastq
	ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.2.fastq reads.2.fastq
		DB=/proj/g2013206/metagenomics/src/sortmerna-1.9/rRNA_databases/silva-arc-16s-database-id95.fasta,/proj/g2014180/nobackup/metagenomics-workshop/reference_db/sortmerna/silva-arc-16s-database-id95.fasta.index:/proj/g2013206/metagenomics/src/sortmerna-1.9/rRNA_databases/silva-bac-16s-database-id85.fasta,/proj/g2014180/nobackup/metagenomics-workshop/reference_db/sortmerna/silva-bac-16s-database-id85.fasta.index:/proj/g2013206/metagenomics/src/sortmerna-1.9/rRNA_databases/silva-euk-18s-database-id95.fasta,/proj/g2014180/nobackup/metagenomics-workshop/reference_db/sortmerna/silva-euk-18s-database-id95.fasta.index

SortMeRNA has built-in multithreading support that we will use for parallelization (-a).
We still have to launch one sample at a time, though::

	for readfile in reads.*.fastq; 
	do sortmerna --reads $readfile --ref $DB --fastx --aligned ${readfile}_rrna -v -a 2;
	done

.. _sortmeRNA: http://bioinfo.lifl.fr/RNA/sortmerna/

RDP classifier
==============
sortmeRNA outputs the reads, or part of reads, that encode rRNA in a fasta file. These rRNA 
sequences can be classified in many ways. One option is blasting them against a suitable database. 
Here we use a simple and fast method, the classifier tool at RDP_ (the Ribosomal Database Project). 
This uses a naïve bayesian classifier trained on kmer frequencies of many sequences of defined taxonomies. 
It gives bootstrap support values for each taxonomic level - usually, the support gets lower the further 
down the hierarchy you go. Genus level is the lowest level provided. You can use the web service 
if you prefer, and upload each file individually, or you can use the uppmax installation of RDP 
classifier like this::

    for file in *_rrna*.fastq; do 
		name = $(basename $file)
	    java -Xmx1g -jar /proj/g2014180/metagenomics/virtenv/rdp_classifier_2.6/dist/classifier.jar classify -g 16srrna -b $name.bootstrap -h $name.hier.tsv -o $name.class.tsv $file
	done

.. _RDP: http://rdp.cme.msu.edu/

Krona
=======
To get a graphical representation of the taxonomic classifications you can use Krona_, which is an 
excellent program for exploring data with hierarchical structures in general. The output file is an 
html file that can be viewed in a browser. Again make a directory for Krona

.. _KRONA: http://sourceforge.net/p/krona/home/krona/

And run Krona, specifycing the name of the output file (-o), the minimum bootstrap support to use (-m)
and that the two input files should be treated as only one (-c)::

	ktImportRDP -o 16S.tax.html -m 50 -c SRS011405_10M.1.fastq.fastq.class.tsv  SRS011405_1M.2.fastq.fastq.class.tsv

The <() in bash can be used for process substitution: http://tldp.org/LDP/abs/html/process-sub.html.

Copy the resulting file rdp.krona.html to your local computer with scp and open it a browser,
like you did for the FastQC output.
	
