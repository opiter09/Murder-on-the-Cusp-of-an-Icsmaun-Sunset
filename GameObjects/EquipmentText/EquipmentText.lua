local canvas
local cursor
local cursorX = 1
local cursorY = 1
local mappingTable = {
    ["1, 1"] = { Person = "Vlyoaz", Thing = "Hat" },
    ["1, 2"] = { Person = "Vlyoaz", Thing = "Cloak" },
    ["1, 3"] = { Person = "Vlyoaz", Thing = "Shoes" },
    ["1, 4"] = { Person = "Aclor", Thing = "Hat" },
    ["1, 5"] = { Person = "Aclor", Thing = "Cloak" },
    ["1, 6"] = { Person = "Aclor", Thing = "Shoes" },
    ["2, 1"] = { Person = "Ypvua", Thing = "Hat" },
    ["2, 2"] = { Person = "Ypvua", Thing = "Cloak" },
    ["2, 3"] = { Person = "Ypvua", Thing = "Shoes" },
    ["2, 4"] = { Person = "Agwemnco", Thing = "Hat" },
    ["2, 5"] = { Person = "Agwemnco", Thing = "Cloak" },
    ["2, 6"] = { Person = "Agwemnco", Thing = "Shoes" },
}
local itemTexts = vili.from_file("text://items.vili")
local picking = false
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
local textObject
local textObject2
local textObject3
local timerUp = 0
local timerDown = 0
local timerLeft = 0
local timerRight = 0

local function drawEquipment()
    canvas:clear()

    local vars = vili.from_file("root://saveData.vili")
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

    local map = mappingTable[("%s, %s"):format(cursorX, cursorY)]
    textObject = canvas:Text("It"){
        font = fontString,
        x = 8.0,
        y = 648.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.equipment[map.Person][map.Thing]][2]
    }
    textObject2 = canvas:Text("It2"){
        font = fontString,
        x = 8.0,
        y = 688.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.equipment[map.Person][map.Thing]][3]
    }
    textObject3 = canvas:Text("It3"){
        font = fontString,
        x = 8.0,
        y = 728.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.equipment[map.Person][map.Thing]][4]
    }

    canvas:render(This.Sprite)
end

local function moveCursor()
    cursor.x = posTable[("%s, %s"):format(cursorX, cursorY)].x
    cursor.y = posTable[("%s, %s"):format(cursorX, cursorY)].y

    local vars = vili.from_file("root://saveData.vili")
    local map = mappingTable[("%s, %s"):format(cursorX, cursorY)]
    textObject.text = itemTexts[vars.equipment[map.Person][map.Thing]][2]
    textObject2.text = itemTexts[vars.equipment[map.Person][map.Thing]][3]
    textObject3.text = itemTexts[vars.equipment[map.Person][map.Thing]][4]

    canvas:render(This.Sprite)
end

function Local.Init()
    canvas = obe.Canvas.Canvas(1024, 1280)
    drawEquipment()
end

function Event.Actions.Up()
    if (picking == true) then
        return
    end

    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    cursorY = math.max((cursorY - 1), 1)
    moveCursor()
end

function Event.Actions.Down()
    if (picking == true) then
        return
    end

    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    cursorY = math.min((cursorY + 1), 6)
    moveCursor()
end

function Event.Actions.Left()
    if (picking == true) then
        return
    end

    timerLeft = timerLeft + 1
    if (timerLeft < 10) then
        return
    end
    timerLeft = 0

    cursorX = math.max((cursorX - 1), 1)
    moveCursor()
end

function Event.Actions.Right()
    if (picking == true) then
        return
    end

    timerRight = timerRight + 1
    if (timerRight < 10) then
        return
    end
    timerRight = 0

    cursorX = math.min((cursorX + 1), 2)
    moveCursor()
end

function Event.Actions.Accept()
    if (picking == true) then
        picking = false
        This.Sprite:setZDepth(0)
        Engine.Scene:getSprite("players"):setZDepth(0)
        drawEquipment()
        moveCursor()
        return
    end

    local vars = vili.from_file("root://saveData.vili")
    local map = mappingTable[("%s, %s"):format(cursorX, cursorY)]

    local check
    for i = 1, #vars.inventory do
        if (vars.inventory[i] == vars.equipment[map.Person][map.Thing]) then
            check = i
            break
        end
    end
    if (check ~= nil) then
        vars.inventory[check + 1] = vars.inventory[check + 1] + 1
    elseif (check == nil)  and (vars.equipment[map.Person][map.Thing] ~= "None") then
        table.insert(vars.inventory, vars.equipment[map.Person][map.Thing])
        table.insert(vars.inventory, 1)
    end

    local equipmentMods = vili.from_file("root://Data/Stats/equipmentModifiers")
    for i, v in pairs(equipmentMods[vars.equipment[map.Person][map.Thing]]) do
        if (i == "Spells") then
            for j = 1, #i do
                for k = 1, #vars.spells[map.Person] do
                    if i[j] == vars.spells[map.Person][k] then
                        table.remove(vars.spells[map.Person], k)
                    end
                end
            end
        else
            vars.stats[map.Person].numbers[i] = vars.stats[map.Person].numbers[i] - v
        end
    end

    vars.equipment[map.Person][map.Thing] = "None"
    vili.to_file("root://saveData.vili", vars)
    picking = true
    This.Sprite:setZDepth(3)
    Engine.Scene:getSprite("players"):setZDepth(3)
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("equipmentSelect", { thePerson = map.Person, theType = map.Thing })
end

function Event.Actions.Back()
    if (picking == true) then
        return
    end

    Engine.Scene:loadFromFile("Scenes/Inventory_Menu.map.vili")
end