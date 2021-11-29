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
    newSprite:setLayer(-4)
    This.SceneNode:addChild(newSprite)
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas = obe.Canvas.Canvas(256, 128)

    canvas:Text("Flying"){
        font = fontString,
        x = 100.0,
        y = 19.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Fly"
    }
    canvas:Text("Poison"){
        font = fontString,
        x = 100.0,
        y = 37.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Pois"
    }
    canvas:Text("Name"){
        font = fontString,
        x = 100.0,
        y = 55.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Name"
    }
    canvas:Text("Vitality"){
        font = fontString,
        x = 100.0,
        y = 73.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "100"
    }
    canvas:Text("Sleep"){
        font = fontString,
        x = 100.0,
        y = 91.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Sleep"
    }
    canvas:Text("Confused"){
        font = fontString,
        x = 100.0,
        y = 109.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        layer = -4,
        color = "#FAFAFA",
        text = "Conf"
    }
    canvas:render(newSprite)
end