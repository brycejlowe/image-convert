#!/usr/bin/env python3
import os
import argparse
import pathlib
import shutil
import subprocess

parser = argparse.ArgumentParser(description="Mass convert images")
parser.add_argument('input',metavar='<src path>',nargs='+',help="Source folder")
parser.add_argument('output',metavar='<dst path>',nargs='+',help="Destination folder")
parser.add_argument('--target',metavar='png',nargs=1,help='Target format',required=True)
parser.add_argument('--source',metavar='jpeg',nargs=1,help='Source format',required=True)

args = parser.parse_args()

# clean input and output dir paths
args.input[0] = args.input[0].rstrip('/')
args.output[0] = args.output[0].rstrip('/')

args.source[0] = args.source[0].split(",")

if not os.path.isdir(args.input[0]):
    raise Exception(f"Invalid Input Directory {args.input[0]}")

if not os.path.isdir(args.output[0]):
    os.mkdir(args.output[0])

for source_path, subdirs, files in os.walk(args.input[0]):
    destination_path = source_path.replace(args.input[0], args.output[0])
    
    for file in files:
        if file == '.DS_Store':
            continue

        file_name, extension = os.path.splitext(file)
        extension = extension.lstrip('.')
        pathlib.Path(destination_path).mkdir(parents=True, exist_ok=True)

        if extension.lower() in args.target:
            print(f"File Name: {file} - File Type Match: {extension}")
            shutil.copy(f"{source_path}/{file}", f"{destination_path}/{file}")
        else:
            print(f"File Name: {file} - Converting to {args.target[0]}")
            subprocess.call(["/usr/local/bin/convert", f"{source_path}/{file}", f"{destination_path}/{file_name}.{args.target[0]}"])