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

for i in $(seq 0 $((${#SAMPLES[@]}-1))); do
    export SAMPLE=${SAMPLES[$i]}
    export SAMPLE_ID=${SAMPLE_IDS[$i]}
    echo "SAMPLE" $SAMPLE "SAMPLE_ID" $SAMPLE_ID
    echo "fastqc"
    rst_to_code source/reads-qc/fastqc.rst | grep -v scp | bash -x
    echo "quality trim"
    rst_to_code source/reads-qc/qtrim.rst | grep -v scp | bash -x
done
