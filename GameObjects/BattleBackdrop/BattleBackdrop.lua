function Local.Init()
    local vars = vili.from_file("root://saveData.vili")
    local backdrops = vili.from_file("root://Data/Groups/battleBackdrops.vili")
    local check = 0

    for i = 1, backdrops.total do
        for j = 2, #backdrops[("Backdrop%s"):format(i)] do
            if (backdrops[("Backdrop%s"):format(i)][j] == vars.currentMap) then
                This.Sprite:loadTexture(("sprites://LevelSprites/Backdrops/%s.BMP"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("playerCamouflage"):loadTexture(("sprites://LevelSprites/Backdrops/Camouflage/%s.png"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("playerCamouflage"):setVisible(false)
                Engine.Scene:getSprite("enemyCamouflage"):loadTexture(("sprites://LevelSprites/Backdrops/Camouflage/%s.png"):format(backdrops[("Backdrop%s"):format(i)][1]))
                Engine.Scene:getSprite("enemyCamouflage"):setVisible(false)
                check = 1
                break
            end
        end
        if (check == 1) then
            break
        end
    end

    local parties = vili.from_file("root://Data/Groups/enemyParties.vili")
    local baseStats = vili.from_file("root://Data/Stats/enemyBaseStats.vili")
    local growths = vili.from_file("root://Data/Stats/enemyGrowths.vili")
    local battleTable = { enemies = {}, player = {} }
    for i = 1, 9 do
        local string = ("slot%s"):format(i)
        battleTable.enemies[string] = 0
        battleTable.player[string] = 0

        if (parties[vars.currentMap][("party%s"):format(vars.currentParty)][("enemy%s"):format(i)] ~= nil) then
            local thisGuy = parties[vars.currentMap][("party%s"):format(vars.currentParty)][("enemy%s"):format(i)]
            local myStats = baseStats[thisGuy.ID]
            local myGrowths = growths[thisGuy.ID]
            for j = 1, (thisGuy.Level * 5) do
                local rand = math.random(1, 100)
                if (rand <= myGrowths.Might) then
                    myStats.Might = myStats.Might + 1
                elseif (rand > myGrowths.Might) and (rand <= myGrowths.Agility) then
                    myStats.Agility = myStats.Agility + 1
                elseif (rand > myGrowths.Agility) and (rand <= myGrowths.Guard) then
                    myStats.Guard = myStats.Guard + 1
                elseif (rand > myGrowths.Guard) and (rand <= myGrowths.Insight) then
                    myStats.Insight = myStats.Insight + 1
                elseif (rand > myGrowths.Insight) then
                    myStats.Communication = myStats.Communication + 1
                end
            end
            myStats.Vitality = myStats.Vitality * (1.1 ^ (thisGuy.Level - 1))
            for k, v in pairs(thisGuy) do
                myStats[k] = v
            end
            battleTable.enemies[string] = myStats
        end
    end

    battleTable.player.slot1 = { Name = "Agwemnco", ID = "Agwemnco", Sprite = "standing-combat" }
    for k, v in pairs(vars.stats.Agwemnco) do
        battleTable.player.slot1[k] = v
    end
    battleTable.player.slot3 = { Name = "Aclor", ID = "Aclor", Sprite = "standing-combat" }
    for k, v in pairs(vars.stats.Aclor) do
        battleTable.player.slot3[k] = v
    end
    battleTable.player.slot4 = { Name = "Ypvua", ID = "Ypvua", Sprite = "standing-combat" }
    for k, v in pairs(vars.stats.Ypvua) do
        battleTable.player.slot4[k] = v
    end
    battleTable.player.slot6 = { Name = "Vlyoaz", ID = "Vlyoaz", Sprite = "standing-combat" }
    for k, v in pairs(vars.stats.Vlyoaz) do
        battleTable.player.slot6[k] = v
    end

    vili.to_file("root://Data/battleTable.vili", battleTable)
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("SlotAction", {})
end
