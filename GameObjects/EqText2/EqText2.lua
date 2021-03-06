local canvas
local cursor
local cursorPlace = 1
local page = 1
local pageMax
local Person
local relevantItems = { [1] = "None" }
local textObject
local textObject2
local textObject3
local timerUp = 0
local timerDown = 0
local Type

function Local.Init()
    canvas = obe.Canvas.Canvas(1024, 1280)
    This.Sprite:setVisible(false)
end

local function drawSelection()
    canvas:clear()
    relevantItems = { [1] = "None" }

    local checkTable = vili.from_file("root://Data/Groups/equipmentType.vili")
    local vars = vili.from_file("root://saveData.vili")
    local itemTexts = vili.from_file("text://items.vili")
    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"

    for i = 1, #vars.inventory do
        for j = 1, #(checkTable[Type]) do
            if (checkTable[Type][j] == vars.inventory[i]) then
                table.insert(relevantItems, vars.inventory[i])
            end
        end
    end

    for i = 1, #relevantItems do
        if (i > (10 * (page - 1))) and (i <= (10 * page)) then
            local yVal = (50 * math.ceil(i))
            canvas:Text(("%s"):format(i)){
                font = fontString,
                x = 64.0,
                y = yVal,
                unit = obe.Transform.Units.ScenePixels,
                size = 30,
                color = "#FAFAFA",
                text = ("%s"):format(itemTexts[relevantItems[i]][1])
            }
            canvas:render(This.Sprite)
        end
    end

    local yVal2 = (50 * cursorPlace)
    cursor = canvas:Text("cursor"){
        font = fontString,
        x = 32.0,
        y = yVal2,
        unit = obe.Transform.Units.ScenePixels,
        size = 30,
        color = "#FAFAFA",
        text = ">"
    }

    local thing = (10 * (page - 1)) + cursorPlace
    textObject = canvas:Text("It"){
        font = fontString,
        x = 8.0,
        y = 648.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[relevantItems[thing]][2]
    }
    textObject2 = canvas:Text("It2"){
        font = fontString,
        x = 8.0,
        y = 688.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[relevantItems[thing]][3]
    }
    textObject3 = canvas:Text("It3"){
        font = fontString,
        x = 8.0,
        y = 728.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[relevantItems[thing]][4]
    }

    canvas:render(This.Sprite)
end

function UserEvent.Custom.equipmentSelect(evt)
    Person = evt.thePerson
    Type = evt.theType

    This.Sprite:setZDepth(0)
    This.Sprite:setVisible(true)
    cursorPlace = 1
    page = 1
    drawSelection()
end

function Event.Actions.Up()
    if (canvas == nil) or (cursor == nil) or (This.Sprite:getZDepth() == 3) then
        return
    end

    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    local vars = vili.from_file("root://saveData.vili")
    local itemTexts = vili.from_file("text://items.vili")

    if (cursorPlace > 1) then
        cursorPlace = cursorPlace - 1
        cursor.y = (50 * cursorPlace)

        local thing = (10 * (page - 1)) + cursorPlace
        textObject.text = itemTexts[relevantItems[thing]][2]
        textObject2.text = itemTexts[relevantItems[thing]][3]
        textObject3.text = itemTexts[relevantItems[thing]][4]

        canvas:render(This.Sprite)
        return
    elseif (cursorPlace == 1) and (page > 1) then
        page = page - 1
        cursorPlace = 10
        drawSelection()
    end
end

function Event.Actions.Down()
    if (canvas == nil) or (cursor == nil) or (This.Sprite:getZDepth() == 3) then
        return
    end

    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    local vars = vili.from_file("root://saveData.vili")
    local itemTexts = vili.from_file("text://items.vili")

    local endThing = #relevantItems - (10 * (page - 1))

    if (cursorPlace < 10) and (cursorPlace < endThing) then
        cursorPlace = cursorPlace + 1
        cursor.y = (50 * cursorPlace)

        local thing = (10 * (page - 1)) + cursorPlace
        textObject.text = itemTexts[relevantItems[thing]][2]
        textObject2.text = itemTexts[relevantItems[thing]][3]
        textObject3.text = itemTexts[relevantItems[thing]][4]

        canvas:render(This.Sprite)
        return
    elseif (cursorPlace == 10) and (page < pageMax) then
        page = page + 1
        cursorPlace = 1
        drawSelection()
    end
end

function Event.Actions.Accept()
    if (canvas == nil) or (cursor == nil) or (This.Sprite:getZDepth() == 3) then
        return
    end

    local vars = vili.from_file("root://saveData.vili")
    local thing = (10 * (page - 1)) + cursorPlace
    local selection = relevantItems[thing]

    local check
    for i = 1, #vars.inventory do
        if (vars.inventory[i] == selection) then
            check = i
            break
        end
    end
    if (check ~= nil) then
        vars.inventory[check + 1] = vars.inventory[check + 1] - 1
        if (vars.inventory[check + 1] <= 0) then
            table.remove(vars.inventory, (check + 1))
            table.remove(vars.inventory, check)
        end
    end

    local equipmentMods = vili.from_file("root://Data/Stats/equipmentModifiers")
    for i, v in pairs(equipmentMods[selection]) do
        if (i == "Spells") then
            for j = 1, #i do
                local check = 0
                for k = 1, #vars.spells[Person] do
                    if i[j] == vars.spells[Person][k] then
                        check = 1
                    end
                end
                if (check == 0) then
                    table.insert(vars.spells[Person], equipmentMods[selection][i][j])
                end
            end
        else
            vars.stats[Person][i] = vars.stats[Person][i] + v
        end
    end

    vars.equipment[Person][Type] = selection
    vili.to_file("root://saveData.vili", vars)

    canvas:clear()
    This.Sprite:setZDepth(3)
end