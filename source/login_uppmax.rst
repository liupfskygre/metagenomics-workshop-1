Connecting to UPPMAX
================================

**IMPORTANT:** If it happens that you are logged out from your Uppmax session during the course
(for instance during lunch) you need to rerun all of the commands following on this page, **except** the ``salloc``
command.

Connecting to UPPMAX
-------------------------------
The first step of this lab is to open a ssh connection to the computer cluster Milou on `UPPMAX <http://www.uppmax.uu.se//milou-user-guide>`_. If you have a Mac or a PC running Linux, start the terminal (black screen icon). If you work on a PC running Windows, download and start MobaXterm (http://mobaxterm.mobatek.net).
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

  salloc -A g2015028 -t 08:00:00 -p core -n 8 --no-shell --reservation=g2015028_1 &


Now check which node you got (replace username with your uppmax user name) like this::

  squeue -u username

The nodelist column gives you the name of the node that has been reserved for you (starts with "m").
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

    source /proj/g2015028/metagenomics/virtenv/bin/activate

If you would have to, you deactivate the virtual environment with the command `deactivate`, but you don’t have to do that yet.

NOTE: This is a `python virtual environment <http://www.sitepoint.com/virtual-environments-python-made-easy/>`_. The binary folder of the virtual environment has symbolic links to all programs used in this workshop so you should be able to run those without problems.

Set sample variables
----------------------------
You will now have to make your decision on which kind of dataset you want to work with during this workshop. 
The choices you have are three different sampling sites on or within the human body:
    - Gut
    - Skin
    - Teeth

**Run only *one* of the following commands in the terminal**

This will set the ``SAMPLE`` and ``SAMPLE_ID`` variables that will be used in the commands in the next steps
of the tutorial. If for some reason you have to restart the terminal you will have to set these variable names
again.

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
workshop. This will make it possible for us to only use '$SAMPLE' in the commands, and it will 
automatically be changed to the sample type that you chose. 
`Here <https://drive.google.com/file/d/0B-ktNmaBM1yrMUZxbV9CZHdWLUU/view?usp=sharing>`_ you 
can see an overview of what this structure should look like at the end of the day (the "results" part 
of this structure).

