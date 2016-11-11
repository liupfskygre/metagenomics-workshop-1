========================================
Summarize and explore the annotation
========================================
Now that we have annotated genes and quantified them in the sample using read mapping we will summarize and explore the annotations. This we will do by producing interactive plots detailing the proportion of functional categories such as metabolic pathways and orthologous gene families.

KRONA interactive plots
=========
KRONA is a tool that takes as input a table of abundance values and several hierarchical categories and produces HTML files that can be explored interactively. The enzyme annotations from PROKKA are particularly suited for this purpose because these annotations can be grouped into higher functional categories such as pathways (e.g. glycolysis) and pathway classes (e.g. energy metabolism) for enzymes. Similarly, COG annotations can be summed up into higher categories such as "Carbohydrate transport and metabolism" and "Metabolism".

First we will create a new directory for the krona output and link to the necessary files::

  mkdir -p ~/mg-workshop/results/annotation/functional_annotation/krona/$SAMPLE
  cd ~/mg-workshop/results/annotation/functional_annotation/krona/$SAMPLE/
  ln -s ~/mg-workshop/results/annotation/mapping/$SAMPLE/$SAMPLE.coverage
  ln -s ~/mg-workshop/results/annotation/functional_annotation/prokka/$SAMPLE/PROKKA.$SAMPLE.ec
  ln -s ~/mg-workshop/results/annotation/functional_annotation/prokka/$SAMPLE/PROKKA.$SAMPLE.cog
  ln -s ~/mg-workshop/results/annotation/functional_annotation/minpath/$SAMPLE/PROKKA.$SAMPLE.kegg.minpath
  ln -s ~/mg-workshop/results/annotation/functional_annotation/minpath/$SAMPLE/PROKKA.$SAMPLE.metacyc.minpath
  
Next, use the in-house genes.to.kronaTable.py_ script to produce the tabular output needed for KRONA.

For Metacyc pathways (from enzymes, only considering pathways predicted by MinPath)::

  genes.to.kronaTable.py -i PROKKA.$SAMPLE.ec -m ~/mg-workshop/reference_db/metacyc/ec.to.pwy -H ~/mg-workshop/reference_db/metacyc/pwy.hierarchy -n $SAMPLE -l <(grep "minpath 1" PROKKA.$SAMPLE.metacyc.minpath) -c $SAMPLE.coverage -o $SAMPLE.krona.metacyc.minpath.tab
  
For KEGG pathways (from enzymes, only considering pathways predicted by MinPath)::

  genes.to.kronaTable.py -i PROKKA.$SAMPLE.ec -m ~/mg-workshop/reference_db/kegg/ec.to.pwy -H ~/mg-workshop/reference_db/kegg/pwy.hierarchy -n $SAMPLE -l <(grep "minpath 1" PROKKA.$SAMPLE.kegg.minpath) -c $SAMPLE.coverage -o $SAMPLE.krona.kegg.minpath.tab

For COG annotations::

  genes.to.kronaTable.py -i PROKKA.$SAMPLE.cog -m ~/mg-workshop/reference_db/cog/cog.to.cat -H ~/mg-workshop/reference_db/cog/cat.hierarchy -n $SAMPLE -c $SAMPLE.coverage -o $SAMPLE.krona.COG.tab
  
Finally, use Kronatools ktImportText script to generate the HTML files::

  ktImportText -o $SAMPLE.krona.metacyc.minpath.html $SAMPLE.krona.metacyc.minpath.tab
  ktImportText -o $SAMPLE.krona.kegg.minpath.html $SAMPLE.krona.kegg.minpath.tab
  ktImportText -o $SAMPLE.krona.COG.html $SAMPLE.krona.COG.tab

Copy the resulting html files to your local computer with scp as before and open it a browser, 
like you did for the FastQC output.

**Question: What are the main differences between the databases you have worked with: COG, Metacyc and KEGG? Which one do you prefer and why?**

**Question: What are the main differences between the different samples (gut, skin and teeth)? Compare with results from other groups. Can you, for instance, find differences in degradation of compounds?**

.. _genes.to.kronaTable.py: https://github.com/EnvGen/metagenomics-workshop/blob/master/in-house/genes.to.kronaTable.py
