local function addEvents()
    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:add("beginText")
    CustomGroup:add("endText")

    CustomGroup:add("equipmentSelect")
    CustomGroup:add("spellsSelect")

    CustomGroup:add("beginNoMove")
    CustomGroup:add("endNoMove")

    CustomGroup:add("Reveal")
    CustomGroup:add("beginNoRun")
    CustomGroup:add("endNoRun")
end

function Game.Start()
    --local renderOptions = obe.Scene.SceneRenderOptions()
    --renderOptions.collisions = true
    --Engine.Scene:setRenderOptions(renderOptions)
    Engine.Window:setClearColor(obe.Graphics.Color("#2C4DFF"))
    addEvents()

    local H = {
        currentMap = "Intro_Narration",
        currentX = 928.0,
        currentY = 800.0,
--currentSquare tells you where to put the party's map marker. each square has four maps, so a warp adds/subtracts 0.5
        currentSquare = { x = 25, y = 8 },
        currentKey = "Idle_Up",
        currentParty = 0,
        inventory = { "Planner", 1, "Vulnerary", 4 },
        equipment = { --order of sprites is left to right, top to bottom
            Vlyoaz = {Hat = "None", Cloak = "None", Shoes = "None"},
            Ypvua = {Hat = "None", Cloak = "None", Shoes = "None"},
            Aclor = {Hat = "None", Cloak = "None", Shoes = "None"},
            Agwemnco = {Hat = "Hat_of_Reportage_E", Cloak = "None", Shoes = "None"}
        },
--Magique is the communal pool of MP used to pay for spells. It regens every turn, up to a
--certain maximum. Regen increases by 10, and max by 50, when each party member gets to
--the next level.
        magiqueRegen = 50,
        magiqueMax = 200,
        stats = { --stats out of 100, levels go up to 25, absolute max Vitality is 300.
            Vlyoaz = {XP = 0, Vitality = 22, Level = 1, Class = "Silvalis", numbers =
                {Might = 10, Agility = 25, Guard = 10, Insight = 20, Communication = 10}
            },
            Ypvua = {XP = 0, Vitality = 26, Level = 1, Class = "Amuletalis", numbers =
                {Might = 15, Agility = 15, Guard = 15, Insight = 15, Communication = 15}
            },
            Aclor = {XP = 0, Vitality = 34, Level = 1, Class = "Sanguinalis", numbers =
                {Might = 20, Agility = 20, Guard = 15, Insight= 15, Communication = 5}
            },
            Agwemnco = {XP = 0, Vitality = 17, Level = 1, Class = "Actadiurnalis", numbers =
                {Might = 5, Agility = 15, Guard = 15, Insight = 20, Communication = 20}
            }
        },
        spells = {
            Vlyoaz = {"Magic_Hand", "Camouflage"},
            Ypvua = {"Magic_Hand", "Shift_Object"},
            Aclor = {"Magic_Hand", "Blood_Pact"},
            Agwemnco = {"Magic_Hand", "Investigate"}
        },
        defeated = {}
    }

    local maps = {}
    local backdrops = vili.from_file("root://Data/Groups/battleBackdrops.vili")
    for i = 1, backdrops.total do
        for j = 2, #backdrops[("Backdrop%s"):format(i)] do
            table.insert(maps, backdrops[("Backdrop%s"):format(i)][j])
        end
    end
    for i = 1, #maps do
        H.defeated[maps[i]] = {}
        for j = 1, 20 do
            local subTable = H.defeated[maps[i]]
            subTable[j] = 0
        end
    end

    local basePath = obe.System.Path("root://saveData.vili"):find()
    if (not basePath:success()) then
        vili.to_file("root://saveData.vili", H)
    end
    Engine.Scene:loadFromFile("scenes://Title_Screen.map.vili")
end