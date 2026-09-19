# OmniSight – 360° Player Vision (Project Zomboid Build 42.20.4)

Source and transparency repository for **OmniSight**, a Project Zomboid mod that gives the **player** optional 360° vision while leaving zombie perception untouched.

## What OmniSight changes

The vanilla `zombie.iso.LightingJNI.calculateVisionCone(IsoGameCharacter player)` method is left intact except for one early check:

```java
if (isOmniSightActive(player)) {
    return degreesToCone(360.0F);
}
```

The helper only returns `true` when all three conditions are met:

1. the character is an `IsoPlayer` — zombies and other characters are excluded,
2. Lua ModData contains `OmniSightEnabled = true`, set by the Mod Options checkbox,
3. the invisible `OmniSight.OmniVisionImplant` is currently equipped.

If any condition is false, Project Zomboid continues through the original vanilla vision calculation.

## Zombie vision is not modified

OmniSight does **not** modify `IsoZombie`, `spottedNew()`, zombie sight radius, facing checks, hearing, detection chance, or zombie AI.

The Java guard explicitly requires:

```java
character instanceof IsoPlayer
```

So the 360° override is player-only.

## Runtime mod behavior

The Lua side:

- registers the hidden `omnisight:vision` body-location ID,
- creates an invisible `Omni Vision Implant` if the character doesn't already have one,
- creates the matching Human body slot at runtime with `getOrCreateLocation(...)`,
- equips the implant automatically on existing characters, new characters and respawns,
- writes the Mod Options checkbox state to player ModData as `OmniSightEnabled`.

The effect can be toggled at any time under **Options → Mods → OmniSight**.

## Source repository layout

```text
mod/
└── 42/
    ├── mod.info
    └── media/
        ├── registries.lua
        ├── scripts/
        │   └── OmniSight_Items.txt
        └── lua/
            └── client/
                └── OmniSight.lua

LightingJNI.patch
OmniSightLightingCode.java.txt
workshop.txt
WORKSHOP_STRUCTURE.md
CHECKSUMS.md
```

The repository keeps the mod source easy to inspect. The actual Steam Workshop package wraps the mod under `Contents/mods/OmniSight`.

## Actual Workshop package layout

The tested Workshop package is structured as:

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

See `WORKSHOP_STRUCTURE.md` for the install flow.

## Why the full LightingJNI.java is not included

This repository intentionally does **not** redistribute the full decompiled Project Zomboid `LightingJNI.java` class. Instead, it shows only the minimal OmniSight-specific changes in:

- `LightingJNI.patch`
- `OmniSightLightingCode.java.txt`

That makes it straightforward to inspect exactly what OmniSight adds without publishing the rest of the game's decompiled class.

## Java patch installation

The Workshop download contains:

```text
Contents/mods/OmniSight/42/zombie/iso/LightingJNI.dat
```

Copy the included `zombie` folder into the Project Zomboid installation directory, then rename:

```text
LightingJNI.dat
→ LightingJNI.class
```

The final runtime path is:

```text
<ProjectZomboid>/zombie/iso/LightingJNI.class
```

The original `projectzomboid.jar` is **not** modified.

## Compatibility

Built and tested against **Project Zomboid Build 42.20.4 Stable**.

Because the runtime installation overrides one vanilla Java class, remove the loose `LightingJNI.class` after a Project Zomboid update until compatibility has been verified.

The tested Workshop `LightingJNI.dat` SHA-256 is listed in `CHECKSUMS.md`.

## License / game code

The Lua code and OmniSight-specific Java additions in this repository are the mod's source. Project Zomboid and its original game code belong to The Indie Stone.
