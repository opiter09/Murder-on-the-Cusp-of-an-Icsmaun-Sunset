function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    local backgrounds = vili.from_file("root://Data/Groups/battleBackgrounds.vili")

    for i = 1, backgrounds.total do
        if (backgrounds[("Background%s"):format(i)][vars.currentMap] ~= nil) then
            This.Sprite:loadTexture(("sprites://LevelSprites/Backdrops/%s.BMP"):format(backgrounds[("Background%s"):format(i)]["name"]))
            break
        end
    end
end
