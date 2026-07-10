# Shulker Preview

A vanilla **data pack + resource pack** that shows a live preview of a shulker box's contents directly in its tooltip — item icons, stack counts, durability bars, banner patterns, armor trims, and more, rendered with a custom font trick. No mods required, works in singleplayer and on vanilla servers. Ender chest previews are included and can be toggled.

### Downloads

|Version|Download|
|---|---|
|Minecraft 26.2|• [Data Pack](26.2/Shulker%20Preview%20Data%20Pack%20(26.2).zip?raw=1)<br>• [Resource Pack](26.2/Shulker%20Preview%20Resource%20Pack%20(26.2).zip?raw=1)<br>• [Dark Theme](26.2/Shulker%20Preview%20Dark%20Theme%20(26.2).zip?raw=1) (optional, on top of the resource pack)|
|Minecraft 26.1|• [Data Pack](26.1/Shulker%20Preview%20Data%20Pack%20(26.1).zip?raw=1)<br>• [Resource Pack](26.1/Shulker%20Preview%20Resource%20Pack%20(26.1).zip?raw=1)|

Only the newest release is actively supported. Packs for Minecraft 1.14–1.21 were released by [tryashtar's original project](https://github.com/tryashtar/shulker-preview) and can be downloaded there; they are not supported here.

---

### How to use
<ol>
   <li>Download the data pack and resource pack for your Minecraft version.</li>
   <li>
      <details>
         <summary><ins>Add the data pack to your world.</ins></summary>
         <ul>
            <li>Open your world's folder.</li>
            <img src="https://i.imgur.com/4RE3CG9.png" height="60" alt="Select your world"/> <br/>
            <img src="https://i.imgur.com/2Va0DRj.png" height="30" alt="Edit"/> <br/>
            <img src="https://i.imgur.com/KtjQMXo.png" height="30" alt="Open World Folder"/> <br/>
            <li>Drag the data pack zip from your <code>Downloads</code> folder to the <code>datapacks</code> folder in your world.</li>
            <img src="https://i.imgur.com/alG9zB8.png" height="120"/> <br/>
         </ul>
      </details>
   </li>
   <li>
      <details>
         <summary><ins>Equip the resource pack.</ins></summary>
         <ul>
            <li>Go to the resource packs screen.</li>
            <img src="https://i.imgur.com/ervUIn9.png" height="30" alt="Options..."/> <br/>
            <img src="https://i.imgur.com/AotNu07.png" height="30" alt="Resource Packs..."/> <br/>
            <li>Drag the resource pack zip from your <code>Downloads</code> folder onto the screen.</li>
            <img src="https://i.imgur.com/9sTaNUQ.png" height="160" alt="Yes"/> <br/>
            <li>Move the pack from <code>Available</code> to <code>Selected</code></li>
            <img src="https://i.imgur.com/P5F8mqW.png" height="60" alt="Select the pack">
         </ul>
      </details>
   </li>
   <li>Enter your world and enjoy!</li>
</ol>

---

### FAQ
* How do I change settings (ender chest previews, colored tooltips)?
   * Run `/function ethan-arrowood.shulker_preview:config/show_settings` and toggle the options in the dialog.
   * On 26.1 the namespace is `tryashtar.shulker_preview` instead.
* Does this work with Bukkit/Spigot/Paper?
   * No guarantees. These modded servers can break vanilla behavior that this pack requires.
* Does this work with other resource packs?
   * Yes — put Shulker Preview above them. Items in the preview will look as they do in your personal resource pack, but blocks will appear with vanilla textures.
* What happens if players don't have the resource pack?
   * They will see the vanilla shulker box tooltip, though it may contain a few extra lines.
* How do I completely uninstall the pack?
   * After disabling or removing the pack, the following artifacts will remain and must be cleared manually:
      * The `shulker_preview` scoreboard objective. This can be removed with `/scoreboard objectives remove shulker_preview`.
      * The temporary values saved to NBT storage. This can be removed by deleting the `command_storage_ethan-arrowood.shulker_preview.dat` file from your world's `data` folder (`command_storage_tryashtar.shulker_preview.dat` on 26.1).
      * Any existing shulker boxes will still show the preview in the tooltip. To remove it, simply place and break the shulker box after the pack has been disabled.
* It's not working for me!
   * First, please [follow these instructions](https://imgur.com/a/rBukto5) to diagnose and solve some very common issues.
   * If that didn't fix your problem, please [open an issue](https://github.com/Ethan-Arrowood/shulker-preview/issues) on this repository.

### Credits

This is a fork of [tryashtar's Shulker Preview](https://github.com/tryashtar/shulker-preview), who designed and built the original pack (and its remarkable font-rendering trick) for Minecraft 1.14 through 1.21 — those releases live in their repository, and in this fork's git history. Everything from 26.1 onward is maintained and published by [Ethan Arrowood](https://github.com/Ethan-Arrowood) — the 26.1 update still shipped under the original `tryashtar.shulker_preview` namespace, and 26.2+ uses `ethan-arrowood.shulker_preview`.

### Changelog

For the 1.14–1.21 history, see the [original project](https://github.com/tryashtar/shulker-preview).

```diff
Current 26.2 version
+ All 26.2 items (cinnabar and sulfur block families, sulfur cube, new music disc)
+ Updated pack formats: data pack 107.1, resource pack 88.0
+ Pack namespace renamed from tryashtar.shulker_preview to ethan-arrowood.shulker_preview
+ Boxes processed by the old pack show the plain tooltip until placed and broken once

Current 26.1 version
+ All 26.1 items (copper tools/armor, spears, nautilus armor, shelves, copper golem statues, etc.)
+ Updated pack formats: data pack 101.1, resource pack 84.0
```

---

### Development

This project targets vanilla data packs and resource packs only — no mods required to use. A mod may occasionally be needed as a development tool (e.g. the [block image dumper](https://github.com/Ethan-Arrowood/block-image-dumper), whose repo-side integration lives in `tools/`), but the outputs are always pack files.

If you hit issues with the pack behavior or need to understand how a similar feature is implemented, the [ShulkerBoxTooltip](https://github.com/MisterPeModder/ShulkerBoxTooltip) Fabric mod is a good reference — it solves the same problem as a mod and the source may clarify edge cases.

#### Regenerating the packs

Each `<version>/` folder is regenerated by its own `script.py`. Prerequisites:

1. **Python 3 with numpy + Pillow** — `python3 -m venv .venv && .venv/bin/pip install -r requirements.txt` at the repo root.
2. **The target Minecraft version installed locally** (launched at least once), because `script.py` reads item models straight out of `~/Library/Application Support/minecraft/versions/<v>/<v>.jar`.
3. **`block images/` populated.** This directory is **gitignored** — a fresh clone does not have it, and `script.py` degrades hard without it (every 3D block item renders as missing). Regenerate it by running the [block image dumper](https://github.com/Ethan-Arrowood/block-image-dumper) mod in-game (F7 for items, F8 for pot/banner/shield overlays) and copying the output with `tools/block-image-dumper/process.py`. The `cache/` directory is also gitignored but self-repopulates (registry downloads from misode/mcmeta).

Then `cd <version> && python3 script.py` rewrites the generated files and the three zips in place. Test locally with `tools/deploy-packs.sh`.

#### Generated vs. hand-written files

`script.py` **overwrites** these paths — don't hand-edit them:

- `datapack/.../function/render/row_{0,1,2}/**` (all per-row render functions)
- `datapack/.../function/meta/initialize_data.mcfunction`
- `datapack/.../tags/item/special_render.json` and `tags/item/special_render/*.json`
- `resourcepack/assets/.../lang/en_us.json`, `font/preview.json`, `textures/block_sheet.png`

Everything else in `datapack/` (detection advancements, `shulker_box/`, `ender_chest/`, `config/`, `analyze`/`process`/`start_render`, the color-conversion helpers under `render/`) and the static textures (`durability.png`, `missingno.png`, tooltip themes) is hand-maintained source.

#### Upgrading to a new Minecraft version

1. Port the [block image dumper](https://github.com/Ethan-Arrowood/block-image-dumper) mod first (see its CONTRIBUTING) — the pack can't regenerate without fresh dumps.
2. Copy the previous version folder (without its zips): `rsync -a --exclude='*.zip' <old>/ <new>/`.
3. In `<new>/script.py`, set `target_version` / `jar_target` / `export_version`.
4. Bump all three `pack.mcmeta` files by hand (`script.py` does not write them). The format numbers are in `version.json` inside the new version's game jar (`pack_version` → `data_major.minor` / `resource_major.minor`).
5. Dump images in-game (F7 + F8), run `tools/block-image-dumper/process.py`, then `python3 script.py` and triage its `WARNING:` lines — new block items missing renders show up here.
6. Deploy with `tools/deploy-packs.sh <new>`, verify in-game, then update the README downloads table and changelog.

#### Known issues (26.1)

- **Creative mode previews going stale (fixed).** Editing a box's contents
  normally produces a fresh item without the `processed` custom_data flag, so it
  gets re-scanned. But breaking a shulker box in creative goes through
  `ShulkerBoxBlock.playerWillDestroy`, which applies the block entity's full
  `collectComponents()` to the drop instead of the loot table's restricted copy
  list — so the stale `processed` flag and old lore survive a place→break edit,
  and the box is never re-detected (showing the old preview). Survival is
  unaffected because its drop uses the loot table (copies only
  `custom_name`/`container`/`lock`/`container_loot`). Fixed in
  `shulker_box/check_dropped`: dropped boxes are now reprocessed regardless of
  the flag. A dropped item is a ground entity (10-tick pickup delay), so the
  refresh is flicker-free, and the lore modifiers `replace_all` so reprocessing
  can't duplicate lines.
  - *Remaining edge case:* creative **pick-block** on a placed box produces the
    item directly in the hotbar with no drop, so it bypasses this path; such a
    box can still show a stale preview until it is next dropped.
- **Pot / banner / shield pattern overlays (implemented).** The block image
  dumper's F8 "decoration dump" produces the per-face overlay images
  (`block images/pot/`, `banner/`, `shield/`) by rendering two icons side by
  side and diffing them: pots compare a plain pot against one sherd face to
  isolate the motif; banners/shields render the pattern in white dye over a
  black base so the brightness difference becomes a tintable white mask. If the
  images are absent, `script.py` still degrades gracefully (base item, no
  overlay) rather than corrupting the tooltip.
