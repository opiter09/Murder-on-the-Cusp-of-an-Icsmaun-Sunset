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

    local basePath = obe.System.Path("root://Data/battleTable.vili"):find()
    if (not basePath:success()) then
        local fakeTable = { this = "this" }
        vili.to_file("root://Data/battleTable.vili", fakeTable)
    end

    local oldBattleTable = vili.from_file("root://Data/battleTable.vili")
    if (oldBattleTable.returning ~= nil) and (oldBattleTable.returning == 1) then
        oldBattleTable.returning = 0
        vili.to_file("root://Data/battleTable.vili", oldBattleTable)
        return
    end

    local parties = vili.from_file("root://Data/Groups/enemyParties.vili")
    local baseStats = vili.from_file("root://Data/Stats/enemyBaseStats.vili")
    local growths = vili.from_file("root://Data/Stats/enemyGrowths.vili")
    local levelSpells = vili.from_file("root://Data/Groups/enemyLevelSpells")

    local randObj = math.random(0, 5)
    local battleTable = {
        enemies = {
            turnCount = 0,
            currentMagique = 0,
            magiqueRegen = parties[vars.currentMap][("party%s"):format(vars.currentParty)].magiqueRegen,
            magiqueMax = parties[vars.currentMap][("party%s"):format(vars.currentParty)].magiqueMax
        },
        player = { turnCount = 0, currentMagique = 0, magiqueRegen = vars.magiqueRegen, magiqueMax = vars.magiqueMax },
        returning = 0,
        objectCount = randObj,
        currentTurn = vars.firstTurn
    }
    battleTable[string.lower(vars.firstTurn)].turnCount = 1
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
            myStats.Vitality = math.floor(myStats.Vitality * (1.1 ^ (thisGuy.Level - 1)))
            myStats.MaximumVitality = myStats.Vitality
            for k, v in pairs(thisGuy) do
                if (k == "Name") then
                    myStats[k] = string.sub(v, 1, 6)
                elseif (k == "LeveledAdd") then
                    local avgLevel = (vars.Vlyoaz.Level + vars.Ypvua.Level + vars.Aclor.Level + vars.Agwemnco.Level) / 4
                    myStats.Level = math.ceil(avgLevel) + v
                else
                    myStats[k] = v
                end
            end
            myStats.Status = { Flying = 0, Poisoned = 0, Asleep = 0, Stressed = 0, Camouflaged = 0 }
            for k, v in pairs(myStats.StartingStatus) do
                if (myStats.Status[v] ~= nil) then
                    myStats.Status[v] = 1
                end
            end
            myStats.Spells = {}
            for j = 1, myStats.Level do
                if (levelSpells[thisGuy.ID][("Level%s"):format(j)] ~= nil) then
                    local rand = math.random(1, #levelSpells[thisGuy.ID][("Level%s"):format(j)])
                    table.insert(myStats.Spells, levelSpells[thisGuy.ID][("Level%s"):format(j)][rand])
                end
            end
            myStats.canAct = 1
            myStats.isKnown = 0
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
        battleTable.player[k] = { Name = string.sub(v, 1, 6), ID = v, Sprite = "standing-combat" }
        for o, p in pairs(vars.stats[v]) do
            battleTable.player[k][o] = p
        end
        battleTable.player[k].MaximumVitality = battleTable.player[k].Vitality
        battleTable.player[k].Spells = vars.spells[v]
        battleTable.player[k].Status = { Flying = 0, Poisoned = 0, Asleep = 0, Stressed = 0, Camouflaged = 0 }
        battleTable.player[k].canAct = 1
    end

    vili.to_file("root://Data/battleTable.vili", battleTable)
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("SlotAction", {})
    Engine.Events:schedule():after(0.5):run(function()
        CustomGroup:trigger("beginTurn", {})
    end)
end
