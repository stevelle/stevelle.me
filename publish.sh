#!/bin/sh
cd /workspace
pelican-themes -i themes/nest/
pelican content -s publishconf.py

