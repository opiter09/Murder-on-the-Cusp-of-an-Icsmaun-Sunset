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

    local oldBattleTable = vili.from_file("root://Data/battleTable.vili")
    if (oldBattleTable.returning ~= nil) and (oldBattleTable.returning == true) then
        oldBattleTable.returning = false
        vili.to_file("root://Data/battleTable.vili", oldBattleTable)
        return
    end

    local parties = vili.from_file("root://Data/Groups/enemyParties.vili")
    local baseStats = vili.from_file("root://Data/Stats/enemyBaseStats.vili")
    local growths = vili.from_file("root://Data/Stats/enemyGrowths.vili")
    local battleTable = {
        enemies = {
            magiqueRegen = parties[vars.currentMap][("party%s"):format(vars.currentParty)].magiqueRegen,
            magiqueMax = parties[vars.currentMap][("party%s"):format(vars.currentParty)].magiqueMax
        },
        player = { magiqueRegen = vars.magiqueRegen, magiqueMax = vars.magiqueMax },
        returning = false
    }
    battleTable.inventory = vars.inventory
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

    local playerTable = {
        slot1 = "Agwemnco",
        slot3 = "Aclor",
        slot4 = "Ypvua",
        slot6 = "Vlyoaz"
    }
    for k, v in pairs(playerTable) do
        battleTable.player[k] = { Name = v, ID = v, Sprite = "standing-combat" }
        for o, p in pairs(vars.stats[v]) do
            battleTable.player[k][o] = p
        end
        battleTable.player[k].spells = vars.spells[v]
    end

    vili.to_file("root://Data/battleTable.vili", battleTable)
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("SlotAction", {})
end
