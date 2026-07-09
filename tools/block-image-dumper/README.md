# Block image dumper — integration

The block-image dumper is now its own project:

**https://github.com/Ethan-Arrowood/block-image-dumper**

It's a Fabric client mod for Minecraft 26.2 that renders item icons (F7) and
decorated-pot / banner / shield pattern overlays (F8) to PNGs. This directory
keeps only the glue that copies those dumps into this repo.

## Workflow

1. **Build & install the mod** from the dumper repo (see its README), then run
   Minecraft 26.2 with it installed.
2. **Dump the images** in any loaded world:
   - **F7** — every item's inventory icon → `<minecraft>/block-images/*.png`
   - **F8** — pot / banner / shield overlays → `<minecraft>/block-images/{pot,banner,shield}/`
3. **Copy them into this repo** with the script here:
   ```sh
   python3 process.py            # or: python3 process.py /path/to/minecraft
   ```
   This copies every PNG (including the `pot/`, `banner/`, `shield/`
   subdirectories) from `<minecraft>/block-images/` into `../../block images/`.
4. **Regenerate the packs:**
   ```sh
   cd ../../26.2 && python3 script.py
   ```
   The three output ZIPs are rewritten in place with the new renders.
