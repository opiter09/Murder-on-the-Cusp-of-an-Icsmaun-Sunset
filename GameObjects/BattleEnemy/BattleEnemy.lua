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
    if (battleTable.enemies[string] == 0) then
        This.Sprite:setVisible(false)
        newSprite:setVisible(false)
        return
    end
    This.Sprite:loadTexture(("sprites://GameObjects/EnemyBattleSprites/%s.png"):format(battleTable.enemies[string].ID))
    This.Sprite:useTextureSize()
    This.Sprite:setVisible(true)
    newSprite:setVisible(true)
end

function Local.Init(Slot, xPos, yPos)
    Pause = false
    slot = Slot
    newSprite = Engine.Scene:createSprite(("enemyTextDisplay%s"):format(Slot))
    newSprite:setParentId(This:getId())
    newSprite:load(This.Sprite:dump())
    This.SceneNode:addChild(newSprite)
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas = obe.Canvas.Canvas(256, 128)

    canvas:Text("Name"){
        font = fontString,
        x = 100.0,
        y = 0.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Name"
    }
    canvas:Text("Vitality"){
        font = fontString,
        x = 100.0,
        y = 18.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "100"
    }
    canvas:Text("Flying"){
        font = fontString,
        x = 100.0,
        y = 36.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Fly"
    }
    canvas:Text("Poison"){
        font = fontString,
        x = 100.0,
        y = 54.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Pois"
    }
    canvas:Text("Sleep"){
        font = fontString,
        x = 100.0,
        y = 72.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Sleep"
    }
    canvas:Text("Confused"){
        font = fontString,
        x = 100.0,
        y = 90.0,
        layer = -3,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        color = "#FAFAFA",
        text = "Conf"
    }
    canvas:Text("Camouflaged"){
        font = fontString,
        x = 100.0,
        y = 108.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -3,
        color = "#FAFAFA",
        text = "Camo"
    }
    canvas:render(newSprite)
end