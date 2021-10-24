local canvas
local cursor
local cursorX = 1
local cursorY = 1
local mappingTable = {
    ["1, 1"] = "Vlyoaz",
    ["1, 2"] = "Aclor",
    ["2, 1"] = "Ypvua",
    ["2, 2"] = "Agwemnco"
}
local picking = false
local posTable = {
    ["1, 1"] = { x = 045, y = 294 },
    ["1, 2"] = { x = 045, y = 606 },
    ["2, 1"] = { x = 595, y = 294 },
    ["2, 2"] = { x = 595, y = 606 }
}
local timerUp = 0
local timerDown = 0
local timerLeft = 0
local timerRight = 0

local function drawStatistics()
    canvas:clear()

    local config = vili.from_file("root://config.vili")
    local vars = vili.from_file("root://saveData.vili")
    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"

    cursor = canvas:Text("cursor"){
        font = fontString,
        x = posTable["1, 1"].x,
        y = posTable["1, 1"].y,
        unit = obe.Transform.Units.ScenePixels,
        size = 16,
        color = "#FAFAFA",
        text = ">"
    }

    for i = 1, 2 do
        for j = 1, 2 do
            local startingX
            local startingY
            if (i == 1) then
                startingX = 68
            else
                startingX = 618
            end
            if (j == 1) then
                startingY = 4
            else
                startingY = 316
            end

            local name = mappingTable[("%s, %s"):format(i, j)]
            local statBlock = vars.stats[name]
            local maxXP = (config.Experience.multiplier * (config.Experience.base ^ statBlock.Level)) + config.Experience.addition
            maxXP = math.floor(maxXP * ((100 - statBlock.APRegen) / 100))

            canvas:Text(("Name%s%s"):format(i , j)){
                font = fontString,
                x = startingX + 150,
                y = startingY + 30,
                unit = obe.Transform.Units.ScenePixels,
                size = 30,
                color = "#FAFAFA",
                text = name
            }
            canvas:Text(("Vitality%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 20,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Vitality: %s"):format(statBlock.Vitality)
            }
            canvas:Text(("Level%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 50,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Level: %s"):format(statBlock.Level)
            }
            canvas:Text(("XP%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 80,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Experience: %s/%s"):format(statBlock.XP, maxXP)
            }
            canvas:Text(("Class%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 110,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Class: %s"):format(statBlock.Class)
            }
            canvas:Text(("Might%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 140,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Might: %s"):format(statBlock.numbers.Might)
            }
            canvas:Text(("Agility%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 170,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Agility: %s"):format(statBlock.numbers.Agility)
            }
            canvas:Text(("Guard%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 200,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Guard: %s"):format(statBlock.numbers.Guard)
            }
            canvas:Text(("Insight%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 230,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Insight: %s"):format(statBlock.numbers.Insight)
            }
            canvas:Text(("Communication%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 260,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Communication: %s"):format(statBlock.numbers.Communication)
            }
            canvas:Text(("Spells%s%s"):format(i , j)){
                font = fontString,
                x = startingX,
                y = startingY + 290,
                unit = obe.Transform.Units.ScenePixels,
                size = 16,
                color = "#FAFAFA",
                text = ("Spells")
            }
        end
    end
    canvas:render(This.Sprite)
end

local function moveCursor()
    cursor.x = posTable[("%s, %s"):format(cursorX, cursorY)].x
    cursor.y = posTable[("%s, %s"):format(cursorX, cursorY)].y

    canvas:render(This.Sprite)
end

function Local.Init()
    canvas = obe.Canvas.Canvas(1024, 1280)
    drawStatistics()
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

    cursorY = math.min((cursorY + 1), 2)
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
        return
    end

    local vars = vili.from_file("root://saveData.vili")
    local map = mappingTable[("%s, %s"):format(cursorX, cursorY)]

    picking = true
    This.Sprite:setZDepth(3)
    Engine.Scene:getSprite("players"):setZDepth(3)
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("spellsSelect", { thePerson = map })
end

function Event.Actions.Back()
    if (picking == true) then
        picking = false
        This.Sprite:setZDepth(0)
        Engine.Scene:getSprite("players"):setZDepth(0)
        moveCursor()
        return
    end
    local vars = vili.from_file("root://saveData.vili")
    Engine.Scene:loadFromFile(("Scenes/%s.map.vili"):format(vars.currentMap))
end

function Event.Actions.PauseOrStats()
    local vars = vili.from_file("root://saveData.vili")
    Engine.Scene:loadFromFile(("Scenes/%s.map.vili"):format(vars.currentMap))
end