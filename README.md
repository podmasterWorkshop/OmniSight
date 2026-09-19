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

## Repository contents

- `LightingJNI.patch` — minimal patch showing the exact Java changes.
- `OmniSightLightingCode.java.txt` — exact Java block added to `LightingJNI`.
- `mod/42/media/lua/client/OmniSight.lua` — Mod Options, automatic implant creation/equip, respawn support.
- `mod/42/media/registries.lua` — registers the hidden body-location ID.
- `mod/42/media/scripts/OmniSight_Items.txt` — defines the invisible implant.
- `mod/42/mod.info` — mod metadata.

## Why the full LightingJNI.java is not included

This repository intentionally does **not** redistribute the full decompiled Project Zomboid `LightingJNI.java` class. Instead, it shows only the minimal changes made to the user's own Build 42.20.4 class.

That makes it straightforward to inspect exactly what OmniSight adds without publishing the rest of the game's source.

## Installation note

The Workshop version uses a loose replacement:

```text
<ProjectZomboid>/zombie/iso/LightingJNI.class
```

The Workshop package ships it with a non-`.class` extension for manual installation. The original `projectzomboid.jar` is not modified.

## Compatibility

Built and tested against **Project Zomboid Build 42.20.4 Stable**.

Because the runtime installation overrides one vanilla Java class, remove the loose `LightingJNI.class` after a Project Zomboid update until compatibility has been verified.

## License / game code

The Lua code and OmniSight-specific Java additions in this repository are the mod's source. Project Zomboid and its original game code belong to The Indie Stone.
