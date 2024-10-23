#!/usr/bin/python3

import argparse
from pathlib import Path

parser = argparse.ArgumentParser(description="haha lol")
parser.add_argument('binfile', help='bin file to convert')
args = parser.parse_args()

file_bytes: list = []

try:
    file_bytes = Path(args.binfile).read_bytes()
except FileNotFoundError:
    print(f"File {args.binfile} doesn't exist")
    exit(1)

if file_bytes is None:
    print("file_bytes not populated")
    exit(1)

txt_file = ""
for byte in file_bytes:
    txt_file += f"{byte:08b}\n"

with open(f"{args.binfile[:-4]}.txt", 'w') as f:
    f.write(txt_file)

print(f"Wrote to {args.binfile[:-4]}.txt")
