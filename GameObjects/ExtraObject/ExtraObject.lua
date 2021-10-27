function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")

    if (vars.currentMap == "Intro_Narration") then
        CustomGroup:trigger("beginText", { theText = "introText" })
    end

    if (vars.currentMap == "myFirstMap") then
        CustomGroup:trigger("beginNoMove", {})
    end
end

function UserEvent.Custom.endText(evt)
    local vars = vili.from_file("root://saveData.vili")

    if (vars.currentMap == "Intro_Narration") then
        Engine.Scene:loadFromFile("scenes://myFirstMap.map.vili")
    end
end