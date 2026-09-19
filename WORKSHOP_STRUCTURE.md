# Workshop package structure

This file documents the exact package structure used by the tested Steam Workshop build.

```text
OmniSight/
├── preview.png
├── workshop.txt
└── Contents/
    └── mods/
        └── OmniSight/
            ├── common/
            └── 42/
                ├── mod.info
                ├── media/
                │   ├── registries.lua
                │   ├── scripts/
                │   │   └── OmniSight_Items.txt
                │   └── lua/
                │       └── client/
                │           └── OmniSight.lua
                └── zombie/
                    └── iso/
                        └── LightingJNI.dat
```

## Java patch installation

After subscribing and allowing Steam to download the mod:

1. Open the downloaded Workshop mod folder.
2. Navigate to `Contents/mods/OmniSight/42/`.
3. Copy the entire `zombie` folder.
4. Paste it into the Project Zomboid installation directory.
5. Rename `zombie/iso/LightingJNI.dat` to `LightingJNI.class`.
6. Enable OmniSight in the in-game Mods menu.

Final runtime path:

```text
<ProjectZomboid>/zombie/iso/LightingJNI.class
```

The original `projectzomboid.jar` is not modified.

## Uninstall

Disable/unsubscribe from OmniSight, then delete:

```text
<ProjectZomboid>/zombie/iso/LightingJNI.class
```

Restart Project Zomboid and the game will use the original class from `projectzomboid.jar` again.

## Packaging note

The local archive supplied for review used the filename `workshop.txt.txt`. For future Workshop staging, use the actual filename `workshop.txt` so Windows file-extension hiding cannot create ambiguity.
