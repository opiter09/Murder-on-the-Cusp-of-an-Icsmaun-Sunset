local canvas
local numberText
local Pause
local side

function Event.Actions.PauseOrStats()
    Pause = not Pause
end

local function processAILogic()
end

function UserEvent.Custom.MagiqueChange(evt)
    if (evt.Side == side) then
        local battleTable = vili.from_file("root://Data/battleTable.vili")
        battleTable[string.lower(side)].currentMagique = battleTable[string.lower(side)].currentMagique + evt.Amount
        numberText.text = tostring(battleTable[string.lower(side)].currentMagique)
        vili.to_file("root://Data/battleTable.vili", battleTable)
        canvas:render(This.Sprite)

        if (side == "Enemies") and (battleTable.currentTurn == "Enemies") and (evt.Amount == battleTable.enemies.magiqueRegen) then
            processAILogic()
        end
    end
end

function Local.Init(Side, xPos, yPos)
    Pause = false
    side = Side
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas = obe.Canvas.Canvas(200, 128)
    
    local rectangle = canvas:Rectangle("Box"){
        x = 0.0,
        y = 0.0,
        width = 256.0,
        height = 128.0,
        unit = obe.Transform.Units.ScenePixels,
        layer = -2,
        color = "#FAFAFA"
    }
    if (Side == "Player") then
        rectangle.color = "#216B1B"
    else
        rectangle.color = "#B61B25"
    end

    canvas:Text("description"){
        font = fontString,
        x = 50.0,
        y = 5.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Magique:"
    }

    numberText = canvas:Text("number"){
        font = fontString,
        x = 50.0,
        y = 55.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 30,
        layer = -3,
        color = "#FAFAFA",
        text = "0"
    }
    canvas:render(This.Sprite)
end