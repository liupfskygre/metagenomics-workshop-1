#!/bin/sh
# Get only code blocks from rst file, use like:
# rst_to_code index.rst
rst_to_code() {
    awk 'BEGIN {code=0}
    {
        if ($0 ~ "::") { code=1; lines=0; }
        else {
            if (code) {
                if (length($0) == 0 && lines > 0) { code=0 }
            else { print $0; lines +=1; }
            }
        }
    }' $1
}


SAMPLES=(gut teeth skin)
SAMPLE_IDS=(SRS011405 SRS014690 SRS015381)


#rm -Irf ~/mg-workshop
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/sbin:/bin/
source /proj/g2014180/metagenomics/virtenv/bin/activate

for i in 0; do #$(seq 0 $((${#SAMPLES[@]}-1))); do
    export SAMPLE=${SAMPLES[$i]}
    export SAMPLE_ID=${SAMPLE_IDS[$i]}
    echo "SAMPLE" $SAMPLE "SAMPLE_ID" $SAMPLE_ID
    echo "fastqc"
    rst_to_code source/reads-qc/fastqc.rst | grep -v scp | bash -x
    echo "quality trim"
    rst_to_code source/reads-qc/qtrim.rst | grep -v scp | bash -x
    echo "16S analysis"
    rst_to_code source/16S-analysis/16S_analysis.rst | bash -x
    echo "assembly"
    rst_to_code source/assembly/assembly.rst | sed 's/N/71/g' | bash -x
    #echo "taxonomic-classification/phylosift"
    #rst_to_code source/taxonomic-classification/phylosift.rst | grep -v scp | bash -x
    echo "functional-annotation/prokka"
    rst_to_code source/functional-annotation/prokka.rst | grep -v scp | bash -x
    echo "functional-annotation/minpath"
    rst_to_code source/functional-annotation/minpath.rst | grep -v scp | bash -x
    echo "functional-annotation/read mapping"
    rst_to_code source/functional-annotation/read_mapping.rst | grep -v scp | bash -x
    echo "functional-annotation/summarize"
    rst_to_code source/functional-annotation/summarize.rst | grep -v scp | bash -x
done
