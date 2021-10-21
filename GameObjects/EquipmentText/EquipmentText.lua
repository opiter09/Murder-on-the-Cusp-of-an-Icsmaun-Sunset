local canvas
local cursor
local cursorX = 1
local cursorY = 1
local posTable = {
    ["1, 1"] = { x = 052, y = 114 },
    ["1, 2"] = { x = 052, y = 144 },
    ["1, 3"] = { x = 052, y = 174 },
    ["1, 4"] = { x = 052, y = 450 },
    ["1, 5"] = { x = 052, y = 480 },
    ["1, 6"] = { x = 052, y = 510 },
    ["2, 1"] = { x = 602, y = 114 },
    ["2, 2"] = { x = 602, y = 144 },
    ["2, 3"] = { x = 602, y = 174 },
    ["2, 4"] = { x = 602, y = 450 },
    ["2, 5"] = { x = 602, y = 480 },
    ["2, 6"] = { x = 602, y = 510 }
}

local timerUp = 0
local timerDown = 0
local timerLeft = 0
local timerRight = 0

function Local.Init()
    local vars = vili.from_file("root://saveData.vili")

    local itemTexts = vili.from_file("text://items.vili")

    cursorPlace = { "Top", "Left", 1 }
    canvas = obe.Canvas.Canvas(1024, 1280)

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"

    canvas:Text("nameTL"){
        font = fontString,
        x = 100.0,
        y = 64.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 40,
        color = "#FAFAFA",
        text = "Vlyoaz"
    }
    canvas:Text("hatTL"){
        font = fontString,
        x = 75.0,
        y = 114.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Hat: %s"):format(itemTexts[vars.equipment.Vlyoaz.Hat][1])
    }
    canvas:Text("cloakTL"){
        font = fontString,
        x = 75.0,
        y = 144.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Cloak: %s"):format(itemTexts[vars.equipment.Vlyoaz.Cloak][1])
    }
    canvas:Text("shoesTL"){
        font = fontString,
        x = 75.0,
        y = 174.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Shoes: %s"):format(itemTexts[vars.equipment.Vlyoaz.Shoes][1])
    }

    canvas:Text("nameTR"){
        font = fontString,
        x = 650.0,
        y = 64.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 40,
        color = "#FAFAFA",
        text = "Ypvua"
    }
    canvas:Text("hatTR"){
        font = fontString,
        x = 625.0,
        y = 114.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Hat: %s"):format(itemTexts[vars.equipment.Ypvua.Hat][1])
    }
    canvas:Text("cloakTR"){
        font = fontString,
        x = 625.0,
        y = 144.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Cloak: %s"):format(itemTexts[vars.equipment.Ypvua.Cloak][1])
    }
    canvas:Text("shoesTR"){
        font = fontString,
        x = 625.0,
        y = 174.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Shoes: %s"):format(itemTexts[vars.equipment.Ypvua.Shoes][1])
    }

    canvas:Text("nameBL"){
        font = fontString,
        x = 100.0,
        y = 400.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 40,
        color = "#FAFAFA",
        text = "Aclor"
    }
    canvas:Text("hatBL"){
        font = fontString,
        x = 75.0,
        y = 450.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Hat: %s"):format(itemTexts[vars.equipment.Aclor.Hat][1])
    }
    canvas:Text("cloakBL"){
        font = fontString,
        x = 75.0,
        y = 480.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Cloak: %s"):format(itemTexts[vars.equipment.Aclor.Cloak][1])
    }
    canvas:Text("shoesBL"){
        font = fontString,
        x = 75.0,
        y = 510.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Shoes: %s"):format(itemTexts[vars.equipment.Aclor.Shoes][1])
    }

    canvas:Text("nameBR"){
        font = fontString,
        x = 650.0,
        y = 400.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 40,
        color = "#FAFAFA",
        text = "Agwemnco"
    }
    canvas:Text("hatBR"){
        font = fontString,
        x = 625.0,
        y = 450.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Hat: %s"):format(itemTexts[vars.equipment.Agwemnco.Hat][1])
    }
    canvas:Text("cloakBR"){
        font = fontString,
        x = 625.0,
        y = 480.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Cloak: %s"):format(itemTexts[vars.equipment.Agwemnco.Cloak][1])
    }
    canvas:Text("shoesBR"){
        font = fontString,
        x = 625.0,
        y = 510.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ("Shoes: %s"):format(itemTexts[vars.equipment.Agwemnco.Shoes][1])
    }

    cursor = canvas:Text("cursor"){
        font = fontString,
        x = posTable["1, 1"].x,
        y = posTable["1, 1"].y,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        color = "#FAFAFA",
        text = ">"
    }

    canvas:render(This.Sprite)
end

local function moveCursor()
    cursor.x = posTable[("%s, %s"):format(cursorX, cursorY)].x
    cursor.y = posTable[("%s, %s"):format(cursorX, cursorY)].y
    canvas:render(This.Sprite)
end

function Event.Actions.Up()
    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    cursorY = math.max((cursorY - 1), 1)
    moveCursor()
end

function Event.Actions.Down()
    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    cursorY = math.min((cursorY + 1), 6)
    moveCursor()
end

function Event.Actions.Left()
    timerLeft = timerLeft + 1
    if (timerLeft < 10) then
        return
    end
    timerLeft = 0

    cursorX = math.max((cursorX - 1), 1)
    moveCursor()
end

function Event.Actions.Right()
    timerRight = timerRight + 1
    if (timerRight < 10) then
        return
    end
    timerRight = 0

    cursorX = math.min((cursorX + 1), 2)
    moveCursor()
end

function Event.Actions.Back()
    Engine.Scene:loadFromFile("Scenes/Inventory_Menu.map.vili")
end