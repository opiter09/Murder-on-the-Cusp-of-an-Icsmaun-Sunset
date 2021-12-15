local bigCursorPos = { side = "player", slot = "slot1" }
local canvas
local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
local menuType

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
    local thisThing = battleTable[bigCursorPos.side][bigCursorPos.slot]
    canvas:clear()

    if (thisThing == 0) then
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
    -- three rows of three gets us name, health, level, size, and the five stats
end

function UserEvent.Custom.beginTurn(evt)
    local battleTable = vili.from_file("root://Data/battleTable.vili")

    local soundPath = "evretro://alert-video-game-sound.wav"
    local thisSound = Engine.Audio:load(obe.System.Path(soundPath), obe.Audio.LoadPolicy.Stream)
    thisSound:play()

    if (battleTable.currentTurn == "Enemies") then
        CustomGroup:trigger("magiqueChange", { Side = "Enemies", Amount = battleTable.enemies.magiqueRegen })
        return
    end

    menuType = "slotChooseCursor"
    Engine.Scene:getSprite("bigCursor"):setVisible(true)
    displaySlotStats()
end