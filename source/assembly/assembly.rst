============================
Assembling reads with Velvet
============================
In this exercise you will learn how to perform an assembly with Velvet. Velvet
takes your reads as input and turns them into contigs. It consists of two
steps. In the first step, ``velveth``, the de Bruijn graph is created.
Afterwards the graph is traversed and contigs are created with ``velvetg``.
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
Fill in which kmer you want to do in the `Google doc`_. Later we will compare the results
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

The reads need to be interleaved for ``velveth``::

    interleave-reads.py -o pair.fastq pair1.fastq pair2.fastq

Run velveth, **replacing N with the kmer length you chose**::

    velveth ${SAMPLE}_N N -fastq -shortPaired pair.fastq

Check what directories have been created::

    ls

velvetg
=======
To get the actual contigs you will have to run ``velvetg`` on the created
graph. You can vary options such expected coverage and the coverage cut-off if
you want, but we do not do that in this tutorial. We only choose not to do
scaffolding. Again **replace N for your current kmer length**::

    velvetg ${SAMPLE}_N -scaffolding no


assemstats
==========
After the assembly one wants to look at the length distributions of the
resulting assemblies. You can use the ``assemstats`` script for that::

    assemstats 100 ${SAMPLE}_N/contigs.fa

Try to find out what each of the stats represent by varying the cut-off. One of
the most often used statistics in assembly length distribution comparisons is
the *N50 length*, a weighted median of the length, where you weigh each contig by its
length. This way, you assign more weight to larger contigs. Fifty per cent of all
the bases in the assembly are contained in contigs shorter or equal to N50
length. Add your results to the `Google doc`_.

**Question: What are the important length statistics? Do we prefer sum over
length? Should it be a combination?**

(Optional) Ray
==============
Try to use the Ray assembler instead. Ray was made to play well with metagenomics. Furthermore it
uses `MPI <http://en.wikipedia.org/wiki/Message_Passing_Interface>`_ to distribute the computation
over multiple computational nodes and/or cores. You can run Ray on 16 cores with the command::
    
    mkdir -p ~/mg-workshop/results/assembly/ray/$SAMPLE/
    module unload intel
    module load gcc openmpi/1.7.5
    time mpiexec -n 16 Ray -k N -p ~/mg-workshop/data/$SAMPLE/reads/1M/${SAMPLE_ID}_1M.{1,2}.fastq \
        -o ~/mg-workshop/results/assembly/ray/$SAMPLE/${SAMPLE}_N
    module unload gcc
    module load intel
    
Replace N again with your chosen kmer. There is another `sheet`_ where you can add the Ray assembly results.

**Question: How do Ray's results compare to those from Velvet?**

.. _Google doc: https://docs.google.com/spreadsheets/d/10rOJKgCQct5jwupi_0L44WwgGxg3thYPQlnTJEpXBoY
.. _sheet: https://docs.google.com/spreadsheets/d/10rOJKgCQct5jwupi_0L44WwgGxg3thYPQlnTJEpXBoY/edit#gid=864082853
