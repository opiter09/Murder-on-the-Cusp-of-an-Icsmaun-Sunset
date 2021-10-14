local itemTexts = vili.from_file("text://items.vili")

local canvas
local cursor
local cursorPlace
local page
local pageMax
local textObject
local textObject2
local textObject3
local timerUp = 0
local timerDown = 0

local function drawInventory()
    canvas:clear()

    local vars = vili.from_file("root://saveData.vili")

    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas:Text("bigWord"){
        font = fontString,
        x = 256.0,
        y = 25.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 60,
        color = "#FAFAFA",
        text = "Inventory"
    }

    for i = 1, #vars.inventory do
        if (i > (20 * (page - 1))) and (i <= (20 * page)) and (type(vars.inventory[i]) ~= "number") then
            local yVal = (50 * math.ceil(i / 2)) + 65
            canvas:Text(("%s"):format(i)){
                font = fontString,
                x = 64.0,
                y = yVal,
                unit = obe.Transform.Units.ScenePixels,
                size = 30,
                color = "#FAFAFA",
                text = ("%s   %s"):format(itemTexts[vars.inventory[i]][1], vars.inventory[i + 1])
            }
            canvas:render(This.Sprite)
        end
    end

    local yVal2 = (50 * cursorPlace)  + 65
    cursor = canvas:Text("cursor"){
        font = fontString,
        x = 32.0,
        y = yVal2,
        unit = obe.Transform.Units.ScenePixels,
        size = 30,
        color = "#FAFAFA",
        text = ">"
    }

    local thing = (20 * (page - 1)) + ((cursorPlace * 2) - 1)
    textObject = canvas:Text("It"){
        font = fontString,
        x = 8.0,
        y = 648.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.inventory[thing]][2]
    }
    textObject2 = canvas:Text("It2"){
        font = fontString,
        x = 8.0,
        y = 688.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.inventory[thing]][3]
    }
    textObject3 = canvas:Text("It3"){
        font = fontString,
        x = 8.0,
        y = 728.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = itemTexts[vars.inventory[thing]][4]
    }

    canvas:render(This.Sprite)
end


function Local.Init()
    local vars = vili.from_file("root://saveData.vili")

    pageMax = math.ceil((#vars.inventory / 20))
    page = 1
    cursorPlace = 1
    canvas = obe.Canvas.Canvas(1024, 1280)
    drawInventory()
end

function Event.Actions.Up(event)
    if (canvas == nil) or (cursor == nil) then
        return
    end

    timerUp = timerUp + 1
    if (timerUp < 10) then
        return
    end
    timerUp = 0

    local vars = vili.from_file("root://saveData.vili")

    if (cursorPlace > 1) then
        cursorPlace = cursorPlace - 1
        cursor.y = (50 * cursorPlace) + 65

        local thing = (20 * (page - 1)) + ((cursorPlace * 2) - 1)
        textObject.text = itemTexts[vars.inventory[thing]][2]
        textObject2.text = itemTexts[vars.inventory[thing]][3]
        textObject3.text = itemTexts[vars.inventory[thing]][4]

        canvas:render(This.Sprite)
        return
    elseif (cursorPlace == 1) and (page > 1) then
        page = page - 1
        cursorPlace = 10
        drawInventory()
    end
end

function Event.Actions.Down(event)
    if (canvas == nil) or (cursor == nil) then
        return
    end

    timerDown = timerDown + 1
    if (timerDown < 10) then
        return
    end
    timerDown = 0

    local vars = vili.from_file("root://saveData.vili")
    local endThing = #vars.inventory - (20 * (page - 1))

    if (cursorPlace < 10) and ((cursorPlace * 2) < endThing) then
        cursorPlace = cursorPlace + 1
        cursor.y = (50 * cursorPlace) + 65

        local thing = (20 * (page - 1)) + ((cursorPlace * 2) - 1)
        textObject.text = itemTexts[vars.inventory[thing]][2]
        textObject2.text = itemTexts[vars.inventory[thing]][3]
        textObject3.text = itemTexts[vars.inventory[thing]][4]

        canvas:render(This.Sprite)
        return
    elseif (cursorPlace == 10) and (page < pageMax) then
        page = page + 1
        cursorPlace = 1
        drawInventory()
    end
end

function Event.Actions.Back(event)
    local vars = vili.from_file("root://saveData.vili")

    Engine.Scene:loadFromFile(("Scenes/%s.map.vili"):format(vars.currentMap))
end

function Event.Actions.Inventory(event)
    Engine.Scene:loadFromFile("Scenes/Equipment_Menu.map.vili")
end