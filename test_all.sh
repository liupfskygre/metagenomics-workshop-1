#!/bin/sh
# halt on error
set -e

# Get only code blocks from rst file, use like:
# rst2code index.rst
# or
# cat index.rst | rst2code -
# pipe to bash if it is bash code e.g.
# rst2code index.rst | bash -x
rst2code() {
    awk 'BEGIN {code=0}
    {
        if ($0 ~ "::" && $0 !~ "toctree") { code=1; lines=0; }
        else {
            if (code) {
                no_edit = $0
                gsub(" +","", $0)
                no_whitespace = $0
                if (length(no_whitespace) == 0 && lines > 0) { code=0 }
                else { print no_edit; lines +=1; }
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
    rst2code source/reads-qc/fastqc.rst | grep -v scp | bash -xe
    echo "quality trim"
    rst2code source/reads-qc/qtrim.rst | grep -v scp | bash -xe
    echo "16S analysis"
    rst2code source/16S-analysis/16S_analysis.rst | bash -xe
    echo "assembly"
    rst2code source/assembly/assembly.rst | sed 's/N/71/g' | bash -xe
    #echo "taxonomic-classification/phylosift"
    #rst2code source/taxonomic-classification/phylosift.rst | grep -v scp | bash -x
    echo "functional-annotation/prokka"
    rst2code source/functional-annotation/prokka.rst | grep -v scp | sed 's/PROKKA_11252014/PROKKA_*/g' | bash -xe
    echo "functional-annotation/minpath"
    rst2code source/functional-annotation/minpath.rst | grep -v scp | sed 's/PROKKA_11252014/PROKKA_*/g' | bash -xe
    echo "functional-annotation/read mapping"
    rst2code source/functional-annotation/read_mapping.rst | grep -v scp | sed 's/PROKKA_11252014/PROKKA_*/g' | bash -xe
    echo "functional-annotation/summarize"
    rst2code source/functional-annotation/summarize.rst | grep -v scp | sed 's/PROKKA_11252014/PROKKA_*/g' | bash -xe
done
