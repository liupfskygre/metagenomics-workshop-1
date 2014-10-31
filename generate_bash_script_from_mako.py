#!/usr/bin/env python
"""Extract commands from settings.yaml and put into a file meant for submitting to uppmax. """
from __future__ import print_function
from mako.template import Template
import yaml
import argparse
import sys

# Stolen from http://stackoverflow.com/a/21912744
from collections import OrderedDict

def ordered_load(stream, Loader=yaml.Loader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass
    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping)
    return yaml.load(stream, OrderedLoader)

## usage example:
#ordered_load(stream, yaml.SafeLoader)


bash_template = """#!/usr/bin/env bash

"""

def add_new_key(key, bash_script):
    return bash_script

def insert_bash_cmd(cmd, bash_script):
    """Add cmd to bash_script."""
    return "\n".join([bash_script, cmd])

def parse_settings(key, value, bash_script):
    if key:
        #Skip all download commands
        if key.startswith('download'):
            return bash_script
        bash_script = add_new_key(key, bash_script)
    if isinstance(value, basestring):
            bash_script = insert_bash_cmd(value, bash_script)
    else:
        try:
            for name, cmd in value.iteritems():
                bash_script = parse_settings(name, cmd, bash_script) 
        except AttributeError:
            # Not a dict but a list
            for cmd in value:
                bash_script = parse_settings(None, cmd, bash_script)
    return bash_script 

def main(args):
    #import ipdb; ipdb.set_trace()
    settings = ordered_load(args.settings_file)
    bash_script = bash_template
    
    for key, value in settings['commands'].iteritems():
        bash_script = parse_settings(key, value, bash_script)

    print(bash_script, file=sys.stdout)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = __doc__)
    parser.add_argument('config_file', type=argparse.FileType('r'),
            help = ("The yaml file where all values under "
            "'commands' will be added to the bash script."))
    args = parser.parse_args()
    main(args)
