============================
Assembling reads with Velvet
============================
In this exercise you will learn how to perform an assembly with `Velvet <https://www.ebi.ac.uk/~zerbino/velvet/>`_. Velvet takes your reads as input and assembles them into contigs. It consists of two
steps. In the first step, ``velveth``, the de Bruijn graph is created.
In the second one, the graph is traversed and contigs are created with ``velvetg``.
When constructing the de Bruijn graph, a *kmer* has to be specified. Reads are
cut up into pieces of length *k*, each representing a node in the graph, edges
represent an overlap (some de Bruijn graph assemblers do this differently, but
the idea is the same). The advantage of using kmer overlap instead of read
overlap is that the computational requirements grow with the number of unique
kmers instead of unique reads. A more detailed explanation can be found in
`this paper <http://www.nature.com/nbt/journal/v29/n11/full/nbt.2023.html>`_.

You can test different kmer lengths, as long as they're odd numbers. A good margin
is to have the kmer length between 21 and 51. We'll then look at a few statistics
on the assembly; if you're choice of kmer wasn't good, you might have to run another
assembly (but this is very fast).

Pick your kmer
==============
Fill in which value for k you want to do in the `Google doc`_. The value should be odd and somewhere in the range between maybe 19 and 99. Later we will compare the results
from the different kmers for each group.

velveth
=======
Create the graph data structure with ``velveth``. First create a directory with symbolic links to the pairs that you
want to use::

    mkdir -p ~/mg-workshop/results/assembly/$SAMPLE/
    cd ~/mg-workshop/results/assembly/$SAMPLE/
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.1.fastq pair1.fastq
    ln -s ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.2.fastq pair2.fastq

Create a directory for the kmer of your choice. **Replace N with the kmer length below**::

    mkdir ${SAMPLE}_N

The reads need to be interleaved (forward and reverse read from the same fragment following each other in one file)
for ``velveth``. There are many tools available for performing this simple task. We'll be using one borrowed from 
`khmer <http://khmer.readthedocs.org/en/latest/>`_, but really anything will do::

    interleave-reads.py -o pair.fasta pair1.fastq pair2.fastq

Run velveth, **replacing N with the kmer length you chose**::

    velveth ${SAMPLE}_N N -fasta -shortPaired pair.fasta

Check what directories have been created::

    ls

velvetg
=======
To get the actual contigs you will have to run ``velvetg`` on the created
graph. You can vary options such as the expected coverage and the coverage cut-off if
you want, but we do not do that in this tutorial. We only choose not to do
scaffolding. Again **replace N for your current kmer length**::

    velvetg ${SAMPLE}_N -scaffolding no


assemstats
==========
After the assembly, one wants to look at the length distributions of the
resulting assemblies. We have written the ``assemstats`` script for that::

    assemstats 100 ${SAMPLE}_N/contigs.fa

Try to find out what each of the stats represent by trying other cut-off values than 100.
One of the most often used statistics in assembly length distribution comparisons is
the *N50 length*, a weighted median of the length, where you weigh each contig by its
length. This way, you assign more weight to larger contigs. Fifty per cent of all
the bases in the assembly are contained in contigs shorter or equal to N50
length. Add your results to the `Google doc`_.

**Question: What are the important length statistics? Do we prefer sum over
length? Should it be a combination?**


(Optional) Megahit
==================
The `Megahit <https://github.com/voutcn/megahit>`_ is a recent improvement to assembly algorithms that can assemble large and complex metagenomes in an efficient manner.
It runs on a single node and runs multiple values for k in a predefined or custom sequence. The default sequence is 21, 41, 61, 81 and 99. Here is how to run megahit for a specified list of kmer lengths, using up to 8 cores (threads) and maximum half the available memory on the node. ::
    
    mkdir -p ~/mg-workshop/results/assembly/megahit/$SAMPLE/
    rm -rf ~/mg-workshop/results/assembly/megahit/$SAMPLE/megahit_output
    time megahit -1 ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.1.fastq \
        -2 ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.2.fastq -t 8 -m 0.5 \
        -o ~/mg-workshop/results/assembly/megahit/$SAMPLE/megahit_output/ --k-list 21,41,61,81,99
    
There is another `sheet_megahit`_ where you can add the Megahit assembly results.

**Question: How do Megahit's results compare to those from Velvet? When would you choose one assembler over the other?**

(Optional) Ray
==============
The `Ray <http://denovoassembler.sourceforge.net/>`_ assembler was made to play well with metagenomics. 
Furthermore, it uses `MPI <http://en.wikipedia.org/wiki/Message_Passing_Interface>`_ to distribute the computation
over multiple computational nodes and/or cores. You can run Ray on 8 cores with the command::
    
    mkdir -p ~/mg-workshop/results/assembly/ray/$SAMPLE/
    module unload intel
    module load gcc openmpi/1.7.5
    rm -rf ~/mg-workshop/results/assembly/ray/$SAMPLE/${SAMPLE}_N
    time mpiexec -n 8 Ray -k N -p ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.{1,2}.fastq \
        -o ~/mg-workshop/results/assembly/ray/$SAMPLE/${SAMPLE}_N
    module unload gcc
    module load intel
    

Replace N again with your chosen kmer. There is another `sheet_ray`_ where you can add the Ray assembly results.

**Question: How do Ray's results compare to those from Velvet? When would you choose one assembler over the other?**

.. _Google doc: https://docs.google.com/spreadsheets/d/1t2omtuDUGFdm4-V_W2GWOrJaf34_6scYyVxI7SHl2AE/edit?usp=sharing
.. _sheet_ray: https://docs.google.com/spreadsheets/d/1Cu5de351swo7G1ZGYn8Dy0jKnHvTP1l4mGdslVaCwLg/edit#gid=587968813
.. _sheet_megahit: https://docs.google.com/spreadsheets/d/1Cu5de351swo7G1ZGYn8Dy0jKnHvTP1l4mGdslVaCwLg/edit#gid=1744332060
