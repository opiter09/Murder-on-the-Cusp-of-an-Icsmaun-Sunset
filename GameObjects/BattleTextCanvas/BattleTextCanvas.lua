local bigAcceptable = "None"
local bigCurrentAttack = "None"
local bigCursorPos = { side = "Player", slot = "slot1" }
local canvas
local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
local menuType = "None"

local timerUp = 0
local timerDown = 0
local timerLeft = 0
local timerRight = 0

local topLeft
local topCenter
local topRight
local middleLeft
local middleCenter
local middleRight
local bottomLeft
local bottomCenter
local bottomRight

function UserEvent.Custom.beginText(evt)
    This.Sprite:setVisible(false)
end

function UserEvent.Custom.endText(evt)
    This.Sprite:setVisible(true)
end

function Local.Init()
    local boxCanvas = obe.Canvas.Canvas(338, 32)
    boxCanvas:Rectangle("blackBox"){
        x = 0.0,
        y = 0.0,
        width = 338.0,
        height = 32.0,
        unit = obe.Transform.Units.ScenePixels,
        color = "#030303"
    }
    boxCanvas:render(Engine.Scene:getSprite("smallCursorBox"))
    Engine.Scene:getSprite("smallCursorBox"):setVisible(false)

    Engine.Scene:getSprite("bigCursor"):setVisible(false)
    canvas = obe.Canvas.Canvas(1024, 640)

    topLeft = canvas:Text("TopLeft"){
        font = fontString,
        x = 8.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    topCenter = canvas:Text("TopCenter"){
        font = fontString,
        x = 349.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    topRight = canvas:Text("TopRight"){
        font = fontString,
        x = 690.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    middleLeft = canvas:Text("MiddleLeft"){
        font = fontString,
        x = 8.0,
        y = 48.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    middleCenter = canvas:Text("MiddleCenter"){
        font = fontString,
        x = 349.0,
        y = 48.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    middleRight = canvas:Text("MiddleRight"){
        font = fontString,
        x = 690.0,
        y = 48.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    bottomLeft = canvas:Text("BottomLeft"){
        font = fontString,
        x = 8.0,
        y = 88.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    bottomCenter = canvas:Text("BottomCenter"){
        font = fontString,
        x = 349.0,
        y = 88.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    bottomRight = canvas:Text("BottomRight"){
        font = fontString,
        x = 690.0,
        y = 88.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ""
    }
    canvas:render(This.Sprite)
end

local function displaySlotStats()
    local newNumber = tonumber(string.sub(bigCursorPos.slot, -1))
    local unitPos = Engine.Scene:getGameObject(("%s%s"):format(bigCursorPos.side, newNumber)).SceneNode:getPosition()
    Engine.Scene:getSprite("bigCursor"):setPosition(unitPos)

    local battleTable = vili.from_file("root://Data/battleTable.vili")
    local thisThing = battleTable[string.lower(bigCursorPos.side)][bigCursorPos.slot]

    local nineTable = {}
    for i = 1, 9 do
        nineTable[i] = ""
    end

    if (thisThing ~= 0) then
        nineTable[1] = thisThing.Name
        nineTable[2] = ("Vitality: %s/%s"):format(thisThing.Vitality, thisThing.MaximumVitality)
        nineTable[3] = ("Size: %s"):format(thisThing.Size)
        if (bigCursorPos.side == "Enemies") and (thisThing.isKnown == 0) then
            nineTable[4] = "Level: ???"
            nineTable[5] = "Might: ???"
            nineTable[6] = "Agility: ???"
            nineTable[7] = "Guard: ???"
            nineTable[8] = "Insight: ???"
            nineTable[9] = "Communication: ???"
        else
            nineTable[4] = ("Level: %s"):format(thisThing.Level)
            nineTable[5] = ("Might: %s"):format(thisThing.Might)
            nineTable[6] = ("Agility: %s"):format(thisThing.Agility)
            nineTable[7] = ("Guard: %s"):format(thisThing.Guard)
            nineTable[8] = ("Insight: %s"):format(thisThing.Insight)
            nineTable[9] = ("Communication: %s"):format(thisThing.Communication)
        end
    end

    topLeft.text = nineTable[1]
    topCenter.text = nineTable[2]
    topRight.text = nineTable[3]
    middleLeft.text = nineTable[4]
    middleCenter.text = nineTable[5]
    middleRight.text = nineTable[6]
    bottomLeft.text = nineTable[7]
    bottomCenter.text = nineTable[8]
    bottomRight.text = nineTable[9]
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
        CustomGroup:trigger("MagiqueChange", { SideM = "Enemies", Amount = battleTable.enemies.magiqueRegen })
        return
    end

    CustomGroup:trigger("MagiqueChange", { SideM = "Player", Amount = battleTable.player.magiqueRegen })
    menuType = "slotChooseCursor"
    bigAcceptable = "Player"
    Engine.Scene:getSprite("bigCursor"):setVisible(true)
    displaySlotStats()
end

function Event.Actions.Up()
    if (menuType == "None") then
        return
    end

    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.slot ~= "slot1") and (bigCursorPos.slot ~= "slot4") and (bigCursorPos.slot ~= "slot7") then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            bigCursorPos.slot = ("slot%s"):format(oldNumber - 1)
            displaySlotStats()
        end
    else
        local config = vili.from_file("root://config.vili")
        local xThing = (-1) * config.Camera.xOffsetRight
        local yThing = (-1) * config.Camera.yOffsetDown
        Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
        local shift
        if (Engine.Scene:getSprite("smallCursorBox"):getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y == 867) then
            shift = 0
        else
            shift = -40
        end
        Engine.Scene:getSprite("smallCursorBox"):move(obe.Transform.UnitVector(0, shift, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(config.Camera.xOffsetRight, config.Camera.yOffsetDown, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():scale((1 / config.Camera.zoom), obe.Transform.Referential.Center)
    end
end

function Event.Actions.Down()
    if (menuType == "None") then
        return
    end

    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    if (menuType == "slotChooseCursor") then
        if (bigCursorPos.slot ~= "slot3") and (bigCursorPos.slot ~= "slot6") and (bigCursorPos.slot ~= "slot9") then
            local oldNumber = tonumber(string.sub(bigCursorPos.slot, -1))
            bigCursorPos.slot = ("slot%s"):format(oldNumber + 1)
            displaySlotStats()
        end
    else
        local config = vili.from_file("root://config.vili")
        local xThing = (-1) * config.Camera.xOffsetRight
        local yThing = (-1) * config.Camera.yOffsetDown
        Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
        local shift
        if (Engine.Scene:getSprite("smallCursorBox"):getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y > 907) then
            shift = 0
        else
            shift = 40
        end
        Engine.Scene:getSprite("smallCursorBox"):move(obe.Transform.UnitVector(0, shift, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(config.Camera.xOffsetRight, config.Camera.yOffsetDown, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():scale((1 / config.Camera.zoom), obe.Transform.Referential.Center)
    end
end

function Event.Actions.Left()
    if (menuType == "None") then
        return
    end

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
                if (bigCursorPos.side == "Enemies") then
                    bigCursorPos.slot = ("slot%s"):format(oldNumber + 3)
                else
                    bigCursorPos.slot = ("slot%s"):format(oldNumber - 3)
                end
            end
            displaySlotStats()
        end
    else
        local config = vili.from_file("root://config.vili")
        local xThing = (-1) * config.Camera.xOffsetRight
        local yThing = (-1) * config.Camera.yOffsetDown
        Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
        local shift
        if (Engine.Scene:getSprite("smallCursorBox"):getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x == 452) then
            shift = 0
        else
            shift = -341
        end
        Engine.Scene:getSprite("smallCursorBox"):move(obe.Transform.UnitVector(shift, 0, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(config.Camera.xOffsetRight, config.Camera.yOffsetDown, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():scale((1 / config.Camera.zoom), obe.Transform.Referential.Center)
    end
end

function Event.Actions.Right()
    if (menuType == "None") then
        return
    end

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
                if (bigCursorPos.side == "Enemies") then
                    bigCursorPos.slot = ("slot%s"):format(oldNumber - 3)
                else
                    bigCursorPos.slot = ("slot%s"):format(oldNumber + 3)
                end
            end
            displaySlotStats()
        end
    else
        local config = vili.from_file("root://config.vili")
        local xThing = (-1) * config.Camera.xOffsetRight
        local yThing = (-1) * config.Camera.yOffsetDown
        Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
        local shift
        if (Engine.Scene:getSprite("smallCursorBox"):getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x == 1134) then
            shift = 0
        else
            shift = 341
        end
        Engine.Scene:getSprite("smallCursorBox"):move(obe.Transform.UnitVector(shift, 0, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():move(obe.Transform.UnitVector(config.Camera.xOffsetRight, config.Camera.yOffsetDown, obe.Transform.Units.ScenePixels))
        Engine.Scene:getCamera():scale((1 / config.Camera.zoom), obe.Transform.Referential.Center)
    end
end

function Event.Actions.Accept()
    if (menuType == "None") then
        return
    end

    local battleTable = vili.from_file("root://Data/battleTable.vili")
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")

    if (menuType == "slotChooseCursor") then
        local check = 0
        if (bigAcceptable == bigCursorPos.side) then
            check = 1
        elseif (string.sub(bigAcceptable, -5) == "Blank") then
            if (string.sub(bigAcceptable, 1, 6) == string.sub(bigCursorPos.side, 1, 6)) then
                if (battleTable[string.lower(bigCursorPos.side)][bigCursorPos.slot] == 0) then
                    check = 1
                end
            end
        end
        if (check == 0) then
            local soundPath = "evretro://8-bit-damage-sound.wav"
            local thisSound = Engine.Audio:load(obe.System.Path(soundPath), obe.Audio.LoadPolicy.Stream)
            thisSound:play()
            return
        end
        Engine.Scene:getSprite("bigCursor"):setVisible(false)

        if (bigCurrentAttack == "None") then
            Engine.Scene:getSprite("smallCursorBox"):setVisible(true)
            menuType = "actionSelect"
        end
    end
end