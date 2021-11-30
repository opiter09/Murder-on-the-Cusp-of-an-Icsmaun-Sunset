local battleTable
local canvas
local newSprite
local Pause
local slot

function Event.Actions.PauseOrStats()
    Pause = not Pause
end

function UserEvent.Custom.SlotAction()
    battleTable = vili.from_file("root://Data/battleTable.vili")
    local string = ("slot%s"):format(slot)
    if (battleTable.player[string] == 0) then
        This.Sprite:setVisible(false)
        newSprite:setVisible(false)
        return
    end
    if (battleTable.player[string].Sprite ~= nil) then
        This.Sprite:loadTexture(("sprites://GameObjects/PlayerBattleSprites/%s/%s.png"):format(battleTable.player[string].ID, battleTable.player[string].Sprite))
    else
        This.Sprite:loadTexture(("sprites://GameObjects/PlayerBattleSprites/%s.png"):format(battleTable.player[string].ID))
    end
    This.Sprite:useTextureSize()
    This.Sprite:setVisible(true)

    canvas.elements["Name"].text = battleTable.player[string].Name
    canvas.elements["Vitality"].text = tostring(battleTable.player[string].Vitality)
    if ((battleTable.player[string].MaximumVitality / 4) >= battleTable.player[string].Vitality) then
        canvas.elements["Vitality"].color = "#B61B25"
    else
        canvas.elements["Vitality"].color = "#216B1B"
    end

    for k, v in pairs(battleTable.player[string].Status) do
        if (v == 1) and (k ~= "Camouflaged") then
            canvas.elements[k].text = string.sub(k, 1, 6)
        elseif (v == 0) and (k ~= "Camouflaged") then
            canvas.elements[k].text = " "
        end
    end
    canvas:render(newSprite)
    newSprite:setVisible(true)
end

function Local.Init(Slot, xPos, yPos)
    Pause = false
    slot = Slot
    newSprite = Engine.Scene:createSprite(("playerTextDisplay%s"):format(Slot))
    newSprite:setParentId(This:getId())
    newSprite:load(This.Sprite:dump())
    newSprite:setLayer(-4)
    This.SceneNode:addChild(newSprite)
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas = obe.Canvas.Canvas(256, 128)

    canvas:Text("Flying"){
        font = fontString,
        x = 80.0,
        y = 19.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#858585",
        text = "Flying"
    }
    canvas:Text("Name"){
        font = fontString,
        x = 80.0,
        y = 37.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Name"
    }
    canvas:Text("Vitality"){
        font = fontString,
        x = 80.0,
        y = 55.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#216B1B",
        text = "100"
    }
    canvas:Text("Poisoned"){
        font = fontString,
        x = 80.0,
        y = 73.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#803C80",
        text = "Poison"
    }
    canvas:Text("Asleep"){
        font = fontString,
        x = 80.0,
        y = 91.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FF8096",
        text = "Asleep"
    }
    canvas:Text("Confused"){
        font = fontString,
        x = 80.0,
        y = 109.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFA96",
        text = "Confus"
    }
    canvas:render(newSprite)
end