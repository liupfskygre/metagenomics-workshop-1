===============================
Building a phylogenetic tree with Phyloplan
===============================
To get a graphical representation of the taxonomic classifications you can use
KRONA, which is an excellent program for exploring data with hierarchical
structures in general. The output file is an html file that can be viewed in a
browser. Again make a directory for KRONA::

    mkdir -p ~/metagenomics/cta/krona
    cd ~/metagenomics/cta/krona

And run KRONA, concatenating the archaea and bacteria class files together at the same time like this and providing the name of the sample::

The ``<()`` in bash can be used for process substitution
(http://tldp.org/LDP/abs/html/process-sub.html ). Just for your information,
the above command was actually generated with the following commands::

Copy the resulting file rdp.krona.html to your local computer with scp and open it in firefox.

