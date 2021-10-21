function Local.Init()
    local vars = vili.from_file("root://saveData")

    if (vars.currentMap == "IntroText") then
        local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
        CustomGroup:trigger("beginText", { theText = "introText" })
    end
end

function UserEvent.Custom.endText(evt)
    local vars = vili.from_file("root://saveData")

    if (vars.currentMap == "IntroText") then
        Engine.Scene:loadFromFile("scenes://myFirstMap.map.vili")
    end
end