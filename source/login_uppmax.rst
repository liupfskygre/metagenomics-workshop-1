Connecting to UPPMAX
================================

Connecting to UPPMAX
-------------------------------
The first step of this lab is to open a ssh connection to UPPMAX. If you have a Mac, start the terminal 
(black screen icon). If you work on a PC, download and start MobaXterm (http://mobaxterm.mobatek.net).
Now type (change username to your own username)::

  ssh -X username@milou.uppmax.uu.se

and give your password when prompted. As you type the password, nothing will show on screen. 
No stars, no dots. It is supposed to be that way. Just type the password and press enter, it will be fine.
You should now get a welcoming message from Uppmax to show that you have successfully logged in.

Getting a node of your own
-------------------------------
Usually you would do most of the work in this lab directly on one of the login nodes at uppmax, 
but we have arranged for you to have half of one node (=8 cores) each to avoid disturbances. To get this 
reservation you need to use the salloc command like this::

  salloc -A g2014180 -t 08:00:00 -p core -n 8 --no-shell --reservation=g2014180_tue &


Now check which node you got (replace username with your uppmax user name) like this::

  squeue -u username

The nodelist column gives you the name of the node that has been reserved for you (starts with "q").
Connect to that node using::

  ssh -X nodename

Note: there is a uppmax specific tool called jobinfo that supplies the same kind of information as 
squeue that you can use as well ( $ jobinfo -u username). You are now logged in to your reserved node, 
and there is no need for you to use the SLURM queuing system. You can now continue with the specific 
exercise instructions.

Load virtual environment
----------------------------
We have already installed all programs for you, all you have to do is load the virtual
environment for this workshop. Once you are logged in to the server run::

    source /proj/g2014180/metagenomics/virtenv/bin/activate

You deactivate the virtual environment with::
    
    deactivate

NOTE: This is a python virtual environment. The binary folder of the virtual
environment has symbolic links to all programs used in this workshop so you
should be able to run those without problems.

Set sample variables
----------------------------
You will now have to make your decision on which kind of dataset you want to work with during this workshop. 
The choices you have are three different sampling sites on or within the human body:
    - Gut
    - Skin
    - Teeth

**Run only *one* of these commands in the terminal**

Gut
^^^
::

    SAMPLE=gut
    SAMPLE_ID=SRS011405

Teeth
^^^^^
::

    SAMPLE=teeth
    SAMPLE_ID=SRS014690

Skin
^^^^
::
    
    SAMPLE=skin
    SAMPLE_ID=SRS015381

After you have chosen a sample you will create the file structure continuously throughout the 
workshop. `Here <https://drive.google.com/file/d/0B-ktNmaBM1yrMUZxbV9CZHdWLUU/view?usp=sharing>`_ you 
can see an overview of what this structure should look like at the end of the day (the "results" part).

