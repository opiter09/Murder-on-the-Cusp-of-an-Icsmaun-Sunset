local bigCursorPos = { side = "Player", slot = "slot1" }
local canvas
local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
local menuType

local timerUp = 0
local timerDown = 0
local timerLeft = 0
local timerRight = 0

function UserEvent.Custom.beginText(evt)
    This.Sprite:setVisible(false)
end

function UserEvent.Custom.endText(evt)
    This.Sprite:setVisible(true)
end

function Local.Init()
    Engine.Scene:getSprite("bigCursor"):setVisible(false)
    canvas = obe.Canvas.Canvas(1024, 640)
    canvas:render(This.Sprite)
end

local function displaySlotStats()
    local battleTable = vili.from_file("root://Data/battleTable.vili")
    local thisThing = battleTable[string.lower(bigCursorPos.side)][bigCursorPos.slot]
    canvas:clear()

    if (thisThing == 0) then
        canvas:render(This.Sprite)
        return
    end

    canvas:Text("NameText"){
        font = fontString,
        x = 8.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = thisThing.Name
    }
    canvas:Text("HealthText"){
        font = fontString,
        x = 341.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("%s/%s"):format(thisThing.Vitality, thisThing.MaximumVitality)
    }
    canvas:Text("SizeText"){
        font = fontString,
        x = 690.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = thisThing.Size
    }

    local statsTable = {}
    if (bigCursorPos.side == "Enemies") and (thisThing.isKnown == 0) then
        statsTable = {
            Level = "???",
            Might = "???",
            Agility = "???",
            Guard = "???",
            Insight = "???",
            Communication = "???"
        }
    else
        statsTable = {
            Level = thisThing.Level,
            Might = thisThing.Might,
            Agility = thisThing.Agility,
            Guard = thisThing.Guard,
            Insight = thisThing.Insight,
            Communication = thisThing.Communication
        }
    end
    local index = 0
    for k, v in pairs(statsTable) do
        index = index + 1
        local xPos = 8 + (341 * ((math.fmod(index, 3) - 1)))
        local yPos = 8 + (40 * ((math.fmod(index, 3) - 1)))
        canvas:Text(("%sText"):format(k)){
            font = fontString,
            x = xPos,
            y = yPos,
            unit = obe.Transform.Units.ScenePixels,
            size = 22,
            color = "#FAFAFA",
            text = ("%s: %s"):format(k, v)
        }
    end
    canvas:render(This.Sprite)
end

function UserEvent.Custom.beginTurn(evt)
    local battleTable = vili.from_file("root://Data/battleTable.vili")
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")

    local soundPath = "evretro://alert-video-game-sound.wav"
    local thisSound = Engine.Audio:load(obe.System.Path(soundPath), obe.Audio.LoadPolicy.Stream)
    thisSound:play()

    if (battleTable.currentTurn == "Enemies") then
        menuType = "Waiting"
        CustomGroup:trigger("magiqueChange", { SideM = "Enemies", Amount = battleTable.enemies.magiqueRegen })
        return
    end

    CustomGroup:trigger("magiqueChange", { SideM = "Player", Amount = battleTable.player.magiqueRegen })
    menuType = "slotChooseCursor"
    Engine.Scene:getSprite("bigCursor"):setVisible(true)
    displaySlotStats()
end

function Event.Actions.Up()
    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.slot ~= "slot1") and (bigCursorPos.slot ~= "slot4") and (bigCursorPos.slot ~= "slot7") then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            bigCursorPos.slot = ("slot%s"):format(oldNumber - 1)
            Engine.Scene:getGameObject("%s%s"):format(bigCursorPos.side, (oldNumber - 1)).SceneNode:addChild(Engine.Scene:getSprite("bigCursor"))
            displaySlotStats()
        end
    end
end

function Event.Actions.Down()
    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.slot ~= "slot3") and (bigCursorPos.slot ~= "slot6") and (bigCursorPos.slot ~= "slot9") then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            bigCursorPos.slot = ("slot%s"):format(oldNumber + 1)
            Engine.Scene:getGameObject("%s%s"):format(bigCursorPos.side, (oldNumber + 1)).SceneNode:addChild(Engine.Scene:getSprite("bigCursor"))
            displaySlotStats()
        end
    end
end

function Event.Actions.Left()
    timerLeft = timerLeft + 1
    if (timerLeft < 10) then
        return
    end
    timerLeft = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.side == "Player" or (bigCursorPos.slot ~= "slot7") and (bigCursorPos.slot ~= "slot8") and (bigCursorPos.slot ~= "slot9")) then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            if (oldNumber < 4) and (bigCursorPos.side == "Player") then
                bigCursorPos.side = "Enemies"
                oldNumber = oldNumber - 3 --in this scenario, the slot # does not actually change, but oldNumber must be adjusted so our GO-getting always works
            else
                bigCursorPos.slot = ("slot%s"):format(oldNumber + 3)
            end
            Engine.Scene:getGameObject("%s%s"):format(bigCursorPos.side, (oldNumber + 3)).SceneNode:addChild(Engine.Scene:getSprite("bigCursor"))
            displaySlotStats()
        end
    end
end

function Event.Actions.Right()
    timerRight = timerRight + 1
    if (timerRight < 10) then
        return
    end
    timerRight = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.side == "Enemies" or (bigCursorPos.slot ~= "slot7") and (bigCursorPos.slot ~= "slot8") and (bigCursorPos.slot ~= "slot9")) then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            if (oldNumber < 4) and (bigCursorPos.side == "Enemies") then
                bigCursorPos.side = "Player"
                oldNumber = oldNumber + 3 --in this scenario, the slot # does not actually change, but oldNumber must be adjusted so our GO-getting always works
            else
                bigCursorPos.slot = ("slot%s"):format(oldNumber - 3)
            end
            Engine.Scene:getGameObject("%s%s"):format(bigCursorPos.side, (oldNumber - 3)).SceneNode:addChild(Engine.Scene:getSprite("bigCursor"))
            displaySlotStats()
        end
    end
end