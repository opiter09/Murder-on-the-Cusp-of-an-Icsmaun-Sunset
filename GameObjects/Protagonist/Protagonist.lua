local chased = 0
local lastDirection = 0
local noMove = false
local currentSpeed = 16
local warps = vili.from_file("root://Data/Groups/mapConnections.vili")

function UserEvent.Custom.beginNoMove(evt)
    noMove = true
end
function UserEvent.Custom.endNoMove(evt)
    noMove = false
end
function UserEvent.Custom.beginNoRun(evt)
    currentSpeed = 16
    chased = chased + 1
end
function UserEvent.Custom.endNoRun(evt)
    chased = math.max((chased - 1), 0)
end

function Event.Actions.ShowMap()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    local vars = vili.from_file("root://saveData.vili")
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Map_Menu.map.vili")
end

function Event.Actions.Inventory()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    local vars = vili.from_file("root://saveData.vili")
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Inventory_Menu.map.vili")
end

function Event.Actions.PauseOrStats()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end

    local config = vili.from_file("root://config.vili")
    local xThing = (-1) * config.Camera.xOffsetRight
    local yThing = (-1) * config.Camera.yOffsetDown
    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

    local position = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    local vars = vili.from_file("root://saveData.vili")
    vars.currentX = position.x
    vars.currentY = position.y
    vars.currentKey = This.Animator:getKey()
    vili.to_file("root://saveData.vili", vars)
    Engine.Scene:loadFromFile("scenes://Statistics_Menu.map.vili")
end

function Local.Init()
    chased = 0
    local vars = vili.from_file("root://saveData.vili")
    This.SceneNode:setPosition(obe.Transform.UnitVector(vars.currentX, vars.currentY, obe.Transform.Units.ScenePixels))
    This.Animator:setKey(vars.currentKey)

    if (vars.currentParty > 0) then
        if (Engine.Scene:doesGameObjectExists("Enemies1") == false) then
            Engine.Scene:loadFromFile("scenes://Battleground.map.vili")
        else
            This.Sprite:setVisible(false)
        end
    end
end

function Event.Actions.Up()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Up") and (lastDirection ~= 0)) then
        return
    end

    local check
    local warpCheck
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            if (v == Engine.Scene:getCollider("topBoundary")) then
                warpCheck = true
            end
            break
        end
    end
    if (check == true) and (lastDirection == "Up") then
        local vars = vili.from_file("root://saveData.vili")
        if (warpCheck == true) and (warps[vars.currentMap].North ~= "None") then
            local config = vili.from_file("root://config.vili")
            local xThing = (-1) * config.Camera.xOffsetRight
            local yThing = (-1) * config.Camera.yOffsetDown
            Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
            Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

            vars.currentX = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x
            vars.currentY = 800
            vars.currentMap = warps[vars.currentMap].North
            vili.to_file("root://saveData.vili", vars)
            Engine.Scene:loadFromFile(("scenes://%s.map.vili"):format(vars.currentMap))
            return
        end
        This.SceneNode:move(obe.Transform.UnitVector(0, (currentSpeed), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Up"
    This.Animator:setKey("Walk_Up")
    This.SceneNode:move(obe.Transform.UnitVector(0, -(currentSpeed/15), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Down()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Down") and (lastDirection ~= 0)) then
        return
    end

    local check
    local warpCheck
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            if (v == Engine.Scene:getCollider("bottomBoundary")) then
                warpCheck = true
            end
            break
        end
    end
    if (check == true) and (lastDirection == "Down") then
        local vars = vili.from_file("root://saveData.vili")
        if (warpCheck == true) and (warps[vars.currentMap].South ~= "None") then
            local config = vili.from_file("root://config.vili")
            local xThing = (-1) * config.Camera.xOffsetRight
            local yThing = (-1) * config.Camera.yOffsetDown
            Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
            Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

            vars.currentX = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x
            vars.currentY = 224
            vars.currentMap = warps[vars.currentMap].South
            vili.to_file("root://saveData.vili", vars)
            Engine.Scene:loadFromFile(("scenes://%s.map.vili"):format(vars.currentMap))
            return
        end
        This.SceneNode:move(obe.Transform.UnitVector(0, -(currentSpeed), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Down"
    This.Animator:setKey("Walk_Down")
    This.SceneNode:move(obe.Transform.UnitVector(0, (currentSpeed/15), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Left()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Left") and (lastDirection ~= 0)) then
        return
    end

    local check
    local warpCheck
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            if (v == Engine.Scene:getCollider("leftBoundary")) then
                warpCheck = true
            end
            break
        end
    end
    if (check == true) and (lastDirection == "Left") then
        local vars = vili.from_file("root://saveData.vili")
        if (warpCheck == true) and (warps[vars.currentMap].West ~= "None") then
            local config = vili.from_file("root://config.vili")
            local xThing = (-1) * config.Camera.xOffsetRight
            local yThing = (-1) * config.Camera.yOffsetDown
            Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
            Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

            vars.currentX = 1408
            vars.currentY = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y
            vars.currentMap = warps[vars.currentMap].West
            vili.to_file("root://saveData.vili", vars)
            Engine.Scene:loadFromFile(("scenes://%s.map.vili"):format(vars.currentMap))
            return
        end
        This.SceneNode:move(obe.Transform.UnitVector((currentSpeed), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Left"
    This.Animator:setKey("Walk_Left")
    This.SceneNode:move(obe.Transform.UnitVector(-(currentSpeed/15), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Right()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Right") and (lastDirection ~= 0)) then
        return
    end

    local check
    local warpCheck
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            if (v == Engine.Scene:getCollider("rightBoundary")) then
                warpCheck = true
            end
            break
        end
    end
    if (check == true) and (lastDirection == "Right")  then
        local vars = vili.from_file("root://saveData.vili")
        if (warpCheck == true) and (warps[vars.currentMap].East ~= "None") then
            local config = vili.from_file("root://config.vili")
            local xThing = (-1) * config.Camera.xOffsetRight
            local yThing = (-1) * config.Camera.yOffsetDown
            Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
            Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)

            vars.currentX = 448
            vars.currentY = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y
            vars.currentMap = warps[vars.currentMap].East
            vili.to_file("root://saveData.vili", vars)
            Engine.Scene:loadFromFile(("scenes://%s.map.vili"):format(vars.currentMap))
            return
        end
        This.SceneNode:move(obe.Transform.UnitVector(-(currentSpeed), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Right"
    This.Animator:setKey("Walk_Right")
    This.SceneNode:move(obe.Transform.UnitVector((currentSpeed/15), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Run()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    if (chased > 0) then
        return
    end

    if currentSpeed == 16 then
        currentSpeed = 48
        return
    elseif currentSpeed == 48 then
        currentSpeed = 16
        return
    end
end

function Event.Game.Update()
    if (Engine.Scene:doesGameObjectExists("Enemies1") == true) then
        return
    end
    if (noMove == true) then
        return
    end
    local inputs = Engine.Input:getPressedInputs()
    if (#inputs ~= 1) and (lastDirection ~= nil) and (lastDirection ~= 0) then
        if (#inputs == 0) then
            This.Animator:setKey(("Idle_%s"):format(lastDirection))
        end
        lastDirection = 0
    end
end