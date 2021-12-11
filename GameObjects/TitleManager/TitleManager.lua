local accept = 0
local song

function Event.Actions.Accept()
    if (accept == 1) then
        local vars = vili.from_file("root://saveData.vili")
        song:stop()
        Engine.Scene:loadFromFile(("scenes://%s.map.vili"):format(vars.currentMap))
    end
end

function Local.Init()
    Engine.Events:schedule():after(2):run(function()
        This.Sprite:loadTexture("sprites://GameObjects/TitleScreen/Presents_Splash.png")
    end)

    Engine.Events:schedule():after(4):run(function()
        This.Sprite:setVisible(false)
        song = Engine.Audio:load(obe.System.Path("music://Title Theme.wav"), obe.Audio.LoadPolicy.Stream)
        song:setSpeed(0.5)
        song:play()
        accept = 1
    end)
end