#usr/bin/perl
# Anders Andersson 2013

$in_file[0] = "0328_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[1] = "0403_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[2] = "0423_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[3] = "0531_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[4] = "0619_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[5] = "0705_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[6] = "0709_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[7] = "1001_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[8] = "1004_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[9] = "1028_rrna.silva-bac-16s-database-id85.fasta.class.tsv";
$in_file[10] = "1123_rrna.silva-bac-16s-database-id85.fasta.class.tsv";

$cutoff = 0.80;
	
for ($i = 0; $i < @in_file; $i++) {
	$in_file = $in_file[$i];
	&read_rdp_file;		
}

sub read_rdp_file {
	local($i);
	open (INFILE, $in_file) || die ("Can't open $in_file");
	while (<INFILE>) {
		$_ =~ s/\R//g;
        @fields = split(/\t/,$_);
        $id = $fields[0];
        $i = 2; 
        $this_taxon = $fields[$i];
        $this_bootstrap = $fields[$i+2];
        $taxon = undef;
        while ($this_bootstrap >= $cutoff) {
        	$taxon = $taxon.";".$this_taxon; 
        	$i = $i + 3;
	        $this_taxon = $fields[$i];
    	    $this_bootstrap = $fields[$i+2];        	
        }
        #print"$taxon\n";
       	if (!$taxon) {
       		die ("\nError: no taxonomic level fulfilled your bootstrap criteria for $id.\n\n");
       	}
        substr($taxon, 0, 1) = "";
        #$taxon =~ s/"//g;
        #print"$taxon\n";
		$counts{$taxon}{$in_file}++;
	}
	close (INFILE);
	#die;
}

print"Taxon";
for ($i = 0; $i < @in_file; $i++) {
	$in_file = $in_file[$i];
	print"\t$in_file";			
}
print"\n";

@taxa = (keys %counts);
@taxa = sort @taxa;
foreach $taxon (@taxa) {
	print"$taxon";
	for ($i = 0; $i < @in_file; $i++) {
		$in_file = $in_file[$i];
		if (defined $counts{$taxon}{$in_file}) {
			print"\t$counts{$taxon}{$in_file}";
		} else {
			print"\t0";
		}
	}
	print"\n";
}


