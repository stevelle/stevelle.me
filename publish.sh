#!/bin/sh
cd /workspace
pip install typogrify
pelican-themes -i themes/nest/
pelican content -s publishconf.py

