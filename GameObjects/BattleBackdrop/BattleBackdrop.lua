function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    local backdrops = vili.from_file("root://Data/Groups/battleBackdrops.vili")

    for i = 1, backdrops.total do
        if (backdrops[("Backdrop%s"):format(i)][vars.currentMap] ~= nil) then
            This.Sprite:loadTexture(("sprites://LevelSprites/Backdrops/%s.BMP"):format(backdrops[("Backdrop%s"):format(i)]["name"]))
            break
        end
    end
end
