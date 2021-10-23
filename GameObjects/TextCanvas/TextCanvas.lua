local allTexts = vili.from_file("text://texts.vili")

local canvas
local footnoteOn = false
local H = {}
local ID
local index = 1
local letter = 0
local newPrint = "0"
local placeIndex = 1
local startingPoint
local tempDial = {}
local textObject
local textObject2
local textObject3
local wordSound

function UserEvent.Custom.beginText(evt)
    ID = evt.id
    startingPoint = evt.theText

    footnoteOn = false
    index = 1
    letter = 0
    newPrint = "0"
    placeIndex = 1
    tempDial = {}
    wordSound:stop()
    wordSound:play()
end

function Local.Init()
    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    canvas = obe.Canvas.Canvas(1024, 640)

    textObject = canvas:Text("It"){
        font = fontString,
        x = 8.0,
        y = 8.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = ""
    }
    textObject2 = canvas:Text("It2"){
        font = fontString,
        x = 8.0,
        y = 48.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = ""
    }
    textObject3 = canvas:Text("It3"){
        font = fontString,
        x = 8.0,
        y = 88.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 22,
        layer = 1,
        color = "#FAFAFA",
        text = ""
    }
    canvas:render(This.Sprite)

    H = { [1] = textObject, [2] = textObject2, [3] = textObject3 }
    local soundPath = "root://Data/Music/SomeGuy22 TextSound.wav"
    wordSound = Engine.Audio:load(obe.System.Path(soundPath), obe.Audio.LoadPolicy.Stream)
    wordSound:setVolume(0.2)
end

function Event.Actions.Accept(event)
    if (startingPoint == nil) or (canvas == nil) then
        return
    end

    if (newPrint == ">") then
        newPrint = "_"
        if (footnoteOn == false) and (index >= #allTexts[startingPoint]) then
            textObject.text = ""
            textObject2.text = ""
            textObject3.text = ""
            canvas:render(This.Sprite)

            wordSound:stop()
            startingPoint = nil

            local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
            CustomGroup:trigger("endText", { id = ID })
        end
    end
end

function Event.Actions.EnterFootnote(event)
    if (startingPoint == nil) or (canvas == nil) then
        return
    end

    if (newPrint == ">") and (string.sub(allTexts[startingPoint][index], (letter - 6), (letter - 4)) == " FN") then
        tempDial = { [1] = index, [2] = placeIndex, [3] = letter }
        index = tonumber(string.sub(allTexts[startingPoint][index], (letter - 3), (letter - 2)))
        placeIndex = 1
        letter = 0
        newPrint = "0"
        footnoteOn = true

        textObject.text = ""
        textObject2.text = ""
        textObject3.text = ""
        canvas:render(This.Sprite)
    end
end

function Event.Actions.ExitFootnote(event)
    if (footnoteOn == false) then
        return
    end

    if (startingPoint == nil) or (canvas == nil) then
        return
    end

    index = tempDial[1]
    placeIndex = tempDial[2]
    letter = tempDial[3]
    newPrint = ">"
    footnoteOn = false
    tempDial = {}

    local recentString = string.sub(allTexts[startingPoint][index], 1, (letter - 4))
    recentString = ("%s%s"):format(recentString, " >")
    if (placeIndex == 1) then
        textObject.text = recentString
        textObject2.text = ""
        textObject3.text = ""
    elseif (placeIndex == 2) then
        textObject.text = allTexts[startingPoint][(index - 1)]
        textObject2.text = recentString
        textObject3.text = ""
    elseif (placeIndex == 3) then
        textObject.text = allTexts[startingPoint][(index - 2)]
        textObject2.text = allTexts[startingPoint][(index - 1)]
        textObject3.text = recentString
    end
    canvas:render(This.Sprite)
end

function Event.Game.Update()
    if (startingPoint == nil) or (canvas == nil) then
        return
    end

    local currentPlace = allTexts[startingPoint]
    if (footnoteOn == true) then
        currentPlace = allTexts.Footnotes[startingPoint]
    end

    if (index > #currentPlace) then
        return
    end
    if (newPrint == ">") then
        wordSound:stop()
        return
    end
    if (newPrint == "_") then
        newPrint = "0"
        textObject.text = ""
        textObject2.text = ""
        textObject3.text = ""
        index = index + 1
        placeIndex = 1
        letter = 0
        return
    end

    letter = letter + 1
    if (letter > string.len(currentPlace[index])) then
        index = index + 1
        placeIndex = placeIndex + 1
        if (placeIndex > 3) then
            placeIndex = 1
            textObject.text = ""
            textObject2.text = ""
            textObject3.text = ""
        end
        letter = 0
        return
    end

    wordSound:stop()
    wordSound:play()

    newPrint = string.sub(currentPlace[index], letter, letter)
    H[placeIndex].text = ("%s%s"):format(H[placeIndex].text, newPrint)
    canvas:render(This.Sprite)

    if (string.sub(currentPlace[index], (letter - 2), letter) == " FN") then
        letter = letter + 2
    end
end