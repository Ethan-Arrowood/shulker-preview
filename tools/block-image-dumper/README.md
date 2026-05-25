# Block Image Dumper

A Fabric client mod that renders every registered item's inventory icon to a 64×64 PNG. Used to populate the `block images/` folder that `26.1/script.py` needs for block-type items.

## Prerequisites

| Requirement | Version |
|---|---|
| Java | 25 |
| Minecraft Java Edition | 26.1 |
| Gradle | 9.4.x |

### Install Java 25

Download from [Adoptium](https://adoptium.net/temurin/releases/?version=25) or via Homebrew:

```sh
brew install --cask temurin@25
```

### Install Gradle 9.4

```sh
brew install gradle   # installs latest; confirm with: gradle --version
```

Or download from [gradle.org/releases](https://gradle.org/releases/) and add to `PATH`.

### Install Fabric Loader for Minecraft 26.1

1. Download the Fabric Installer from [fabricmc.net/use/installer](https://fabricmc.net/use/installer/).
2. Run it and select:
   - Game version: **26.1**
   - Loader version: **0.18.4** (or latest for 26.1)
3. Click **Install** — this creates a `fabric-loader-0.18.4-26.1` profile in the Minecraft Launcher.

## Build

From the `tools/block-image-dumper/` directory:

```sh
gradle wrapper --gradle-version 9.4.0   # one-time: creates gradlew and gradle/
./gradlew build
```

The JAR is written to `build/libs/block-image-dumper-1.0.0.jar`.

## Install the mod

Copy the JAR into Minecraft's `mods/` folder:

```sh
cp build/libs/block-image-dumper-1.0.0.jar \
   ~/Library/Application\ Support/minecraft/mods/
```

> **Note:** You need Fabric API installed too. Download `fabric-api-0.149.1+26.1.2.jar` from
> [Modrinth](https://modrinth.com/mod/fabric-api) and drop it in the same `mods/` folder.

## Dump item images

1. Open the Minecraft Launcher, select the **fabric-loader-0.18.4-26.1** profile, and launch.
2. Create or load any world (the dump requires a loaded world and player).
3. Press **F7**. A chat message confirms the dump has started; another appears when it finishes.
4. Images are saved to `~/Library/Application Support/minecraft/block-images/` (one PNG per item).

The dump takes a few seconds and may briefly freeze the game.

## Copy images into the repo

```sh
python3 process.py
```

This copies all dumped PNGs from the Minecraft `block-images/` folder into `../../block images/` (the `shulker-preview/block images/` repo directory).

Pass a custom Minecraft directory as the first argument if needed:

```sh
python3 process.py /path/to/minecraft
```

## Regenerate the resource packs

```sh
cd ../../26.1
python3 script.py
```

Warnings about missing block images should now be gone. The three output ZIPs are updated in place.
