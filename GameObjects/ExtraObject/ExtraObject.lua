local CustomGroup

local function myFirstMapCutscene1()
    local vars = vili.from_file("root://saveData.vili")
    local framerate = vili.from_file("root://config.vili").Framerate.framerateTarget
    local player = Engine.Scene:getGameObject("Protagonist")
    CustomGroup:trigger("beginNoMove", {})

    for i = 1, ((12*30) + 1) do
        if (i == ((12*30) + 1)) then
            Engine.Events:schedule():after((i/framerate)):run(function()
                player.Animator:setKey("Idle_Left")
                CustomGroup:trigger("beginText", { theText = "astrayText", id = "tutorialEO1" })
            end)
        elseif (i <= (7*30)) or (i > (10*30)) then
            Engine.Events:schedule():after((i/framerate)):run(function()
                player.Animator:setKey("Walk_Up")
                This.SceneNode:move(obe.Transform.UnitVector(0, -(16/15), obe.Transform.Units.ScenePixels))
            end)
        else
            Engine.Events:schedule():after((i/framerate)):run(function()
                player.Animator:setKey("Walk_Left")
                This.SceneNode:move(obe.Transform.UnitVector(-(16/15), 0, obe.Transform.Units.ScenePixels))
            end)
        end
    end
end
local function myFirstMapCutscene2()
    local vars = vili.from_file("root://saveData.vili")
    local framerate = vili.from_file("root://config.vili").Framerate.framerateTarget
    local player = Engine.Scene:getGameObject("Protagonist")

    for i = 1, ((5*30) + 1) do
        if (i == ((5*30) + 1)) then
            Engine.Events:schedule():after((i/framerate)):run(function()
                player.Animator:setKey("Idle_Left")
                CustomGroup:trigger("beginText", { theText = "astrayText2", id = "tutorialEO2" })
            end)
        else
            Engine.Events:schedule():after((i/framerate)):run(function()
                player.Animator:setKey("Walk_Left")
                This.SceneNode:move(obe.Transform.UnitVector(-(16/15), 0, obe.Transform.Units.ScenePixels))
            end)
        end
    end
end
local function myFirstMapCutscene3()
    Engine.Scene:getGameObject("Protagonist").Animator:setKey("Idle_Up")
    CustomGroup:trigger("Reveal", {})
end

function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")

    if (vars.currentMap == "Intro_Narration") then
        CustomGroup:trigger("beginText", { theText = "introText" })
    end

    if (vars.currentMap == "myFirstMap") then
        if (vars.defeated.myFirstMap[1] == 0) then
            myFirstMapCutscene1()
        end
    end
end

function UserEvent.Custom.endText(evt)
    local vars = vili.from_file("root://saveData.vili")

    if (vars.currentMap == "Intro_Narration") then
        vars.currentMap = "myFirstMap"
        vili.to_file("root://saveData.vili", vars)
        Engine.Scene:loadFromFile("scenes://myFirstMap.map.vili")
    end

    if (vars.currentMap == "myFirstMap")then
        if (evt.id == "tutorialEO1") then
            myFirstMapCutscene2()
        elseif (evt.id == "tutorialEO2") then
            myFirstMapCutscene3()
        end
    end
end