local lastDirection = 0
local runToggle = 32/30

function Event.Actions.PauseOrMap()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Map_Menu.map.vili")
end

function Event.Actions.Inventory()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Inventory_Menu.map.vili")
end

function Event.Actions.Statistics()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Statistics_Menu.map.vili")
end

function Local.Init()
    local vars = vili.from_file("root://saveData.vili")

    This.SceneNode:setPosition(obe.Transform.UnitVector(vars.currentX, vars.currentY, obe.Transform.Units.ScenePixels))
    This.Animator:setKey(vars.currentKey)
end

function Event.Actions.Up()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Up") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) then
            break
        end
    end
    if (check == true) and (lastDirection == "Up") then
        This.SceneNode:move(obe.Transform.UnitVector(0, (15*runToggle), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Up"
    This.Animator:setKey("Walk_Up")
    This.SceneNode:move(obe.Transform.UnitVector(0, -(runToggle), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Down()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Down") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) then
            break
        end
    end
    if (check == true) and (lastDirection == "Down") then
        This.SceneNode:move(obe.Transform.UnitVector(0, -(15*runToggle), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Down"
    This.Animator:setKey("Walk_Down")
    This.SceneNode:move(obe.Transform.UnitVector(0, (runToggle), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Left()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Left") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) then
            break
        end
    end
    if (check == true) and (lastDirection == "Left") then
        This.SceneNode:move(obe.Transform.UnitVector((15*runToggle), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Left"
    This.Animator:setKey("Walk_Left")
    This.SceneNode:move(obe.Transform.UnitVector(-(runToggle), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Right()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Right") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) then
            break
        end
    end
    if (check == true) and (lastDirection == "Right")  then
        This.SceneNode:move(obe.Transform.UnitVector(-(15*runToggle), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Right"
    This.Animator:setKey("Walk_Right")
    This.SceneNode:move(obe.Transform.UnitVector((runToggle), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Run()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.noMove == true) then
        return
    end
    if runToggle == 32/30 then
        runToggle = 96/30
        return
    elseif runToggle == 96/30 then
        runToggle = 32/30
        return
    end
end

function Event.Game.Update()
    local inputs = Engine.Input:getPressedInputs()
    if (#inputs ~= 1) and (lastDirection ~= nil) and (lastDirection ~= 0) then
        if (#inputs == 0) then
            This.Animator:setKey(("Idle_%s"):format(lastDirection))
        end
        lastDirection = 0
    end
end