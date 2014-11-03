#!/usr/bin/env python
from __future__ import print_function
from mako.template import Template
from mako.lookup import TemplateLookup
import yaml
import argparse
import os
import glob

def main(args):
    with open(args.config) as settings_file:
        settings = yaml.load(settings_file)

    lookup = TemplateLookup(directories=[args.template_path])
    for t in glob.glob(os.path.join(args.template_path, "*.rst")): 
        template = Template(filename=t)
        template_filename = os.path.basename(t)
        print(template.render(**settings), 
                file=open(os.path.join(args.output_path, template_filename), 'w'))

def sanitize_input(args):
    assert os.path.isdir(args.output_path)
    assert os.path.isdir(args.template_path)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output_path', default='source/',
        help=('Path to where rendered templates will be written.'
            ' Any existing files with the same file names will '
            'be over written. Default = sources'))
    parser.add_argument('-t', '--template_path', default=None,
        help=('Path where the raw mako templates are stored. '))
    parser.add_argument('--config',
            help="The yaml file containing config variables for templates.")
    args = parser.parse_args()
    sanitize_input(args)
    main(args)
