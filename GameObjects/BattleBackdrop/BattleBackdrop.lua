function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    local backdrops = vili.from_file("root://Data/Groups/battleBackdrops.vili")
    local check = 0

    for i = 1, backdrops.total do
        for j = 2, #backdrops[("Backdrop%s"):format(i)] do
            if (backdrops[("Backdrop%s"):format(i)][j] == vars.currentMap) then
                This.Sprite:loadTexture(("sprites://LevelSprites/Backdrops/%s.BMP"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("playerCamouflage"):loadTexture(("sprites://LevelSprites/Backdrops/Camouflage/%s.BMP"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("playerCamouflage"):setVisible(false)
                Engine.Scene:getSprite("enemyCamouflage"):loadTexture(("sprites://LevelSprites/Backdrops/Camouflage/%s.BMP"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("enemyCamouflage"):setVisible(false)
                check = 1
                break
            end
        end
        if (check == 1) then
            break
        end
    end
end
