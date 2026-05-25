#!/usr/bin/env python3
"""
Copies block images dumped by the Fabric mod into the shulker-preview block images folder.

Usage:
    python3 process.py [minecraft_dir]

minecraft_dir defaults to the standard location for your OS:
  macOS:   ~/Library/Application Support/minecraft
  Windows: %APPDATA%\\.minecraft
  Linux:   ~/.minecraft
"""

import os
import shutil
import sys
from pathlib import Path


def default_mc_dir() -> Path:
    if sys.platform == 'darwin':
        return Path.home() / 'Library' / 'Application Support' / 'minecraft'
    if sys.platform == 'win32':
        appdata = os.environ.get('APPDATA', '')
        return Path(appdata) / '.minecraft'
    return Path.home() / '.minecraft'


def main():
    mc_dir = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else default_mc_dir()

    src = mc_dir / 'block-images'
    if not src.is_dir():
        print(f'ERROR: {src} does not exist.')
        print('Make sure you pressed F7 in a loaded Minecraft 26.1 world with the mod installed.')
        sys.exit(1)

    script_dir = Path(__file__).resolve().parent
    dest = (script_dir / '..' / '..' / 'block images').resolve()
    dest.mkdir(exist_ok=True)

    pngs = sorted(src.glob('*.png'))
    if not pngs:
        print(f'No PNG files found in {src}.')
        print('The mod should have created one file per registered item.')
        sys.exit(1)

    for png in pngs:
        shutil.copy2(png, dest / png.name)

    total = len(pngs)

    # Decoration overlays (F8 dump) live in subdirectories that script.py reads
    # as ../block images/{pot,banner,shield}/...  Copy each across if present.
    for sub in ('pot', 'banner', 'shield'):
        sub_src = src / sub
        if not sub_src.is_dir():
            continue
        sub_pngs = sorted(sub_src.glob('*.png'))
        if not sub_pngs:
            continue
        (dest / sub).mkdir(exist_ok=True)
        for png in sub_pngs:
            shutil.copy2(png, dest / sub / png.name)
        total += len(sub_pngs)
        print(f'  + {len(sub_pngs)} {sub} overlays')

    print(f'Copied {total} images  {src}  →  {dest}')
    print()
    print('Next: re-run script.py in 26.1/ to regenerate the resource packs with block renders.')
    print('  cd ../../26.1 && python3 script.py')


if __name__ == '__main__':
    main()
