local ITEM_TYPE = "OmniSight.OmniVisionImplant"
local MODDATA_KEY = "OmniSightEnabled"

-- =========================================
-- MOD OPTIONS
-- =========================================

local options = PZAPI.ModOptions:create(
    "OmniSight",
    "OmniSight"
)

options:addTitle("OmniSight")

options:addDescription(
    "Controls the OmniSight 360 degree vision implant."
)

local enable360 = options:addTickBox(
    "Enable360Vision",
    "Enable 360 degree vision",
    true,
    "When enabled, OmniSight removes the directional vision cone."
)

-- =========================================
-- APPLY OPTION TO PLAYER
-- =========================================

local function applySetting(player)
    if not player then
        return
    end

    local enabled = enable360:getValue() == true
    player:getModData()[MODDATA_KEY] = enabled

    print(
        "[OmniSight] 360 vision setting = "
        .. tostring(enabled)
    )
end

-- =========================================
-- ENSURE THE PLAYER HAS THE IMPLANT
-- =========================================

local function ensureImplant(player)
    if not player then
        return
    end

    local inventory = player:getInventory()

    if not inventory then
        print("[OmniSight] ERROR: Player inventory not available.")
        return
    end

    local item = inventory:getItemFromTypeRecurse(ITEM_TYPE)

    if not item then
        item = inventory:AddItem(ITEM_TYPE)

        if item then
            print("[OmniSight] Created Omni Vision Implant.")
        end
    end

    if not item then
        print("[OmniSight] ERROR: Could not create implant.")
        return
    end

    local location = item:getBodyLocation()

    if not location then
        print(
            "[OmniSight] ERROR: Omni Vision Implant "
            .. "doesn't have a BodyLocation."
        )
        return
    end

    local bodyGroup = player:getBodyLocationGroup()

    if not bodyGroup then
        print(
            "[OmniSight] ERROR: Player has no BodyLocationGroup."
        )
        return
    end

    local bodyLocation = bodyGroup:getOrCreateLocation(location)

    if not bodyLocation then
        print(
            "[OmniSight] ERROR: Could not create "
            .. "OmniSight body location."
        )
        return
    end

    local wornItems = player:getWornItems()

    if not wornItems then
        print("[OmniSight] ERROR: WornItems unavailable.")
        return
    end

    if not wornItems:contains(item) then
        player:setWornItem(location, item)
        print("[OmniSight] Implant equipped.")
    else
        print("[OmniSight] Implant already equipped.")
    end
end

-- =========================================
-- CHARACTER SPAWN / RESPAWN
-- =========================================

local function onCreatePlayer(playerIndex, player)
    print(
        "[OmniSight] OnCreatePlayer: "
        .. tostring(playerIndex)
    )

    ensureImplant(player)
    applySetting(player)
end

Events.OnCreatePlayer.Add(onCreatePlayer)

-- =========================================
-- GAME START
-- Covers existing saves.
-- =========================================

local function onGameStart()
    local player = getPlayer()

    if player then
        print("[OmniSight] OnGameStart")
        ensureImplant(player)
        applySetting(player)
    end
end

Events.OnGameStart.Add(onGameStart)

-- =========================================
-- MOD OPTIONS -> APPLY
-- =========================================

options.apply = function(self)
    local player = getPlayer()

    if player then
        print("[OmniSight] Applying options")
        ensureImplant(player)
        applySetting(player)
    end
end
