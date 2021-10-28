local chased = false
local lastDirection = 0
local noMove = false
local runToggle = 16

function UserEvent.Custom.beginNoMove(evt)
    noMove = true
end
function UserEvent.Custom.endNoMove(evt)
    noMove = false
end
function UserEvent.Custom.beginNoRun(evt)
    runToggle = 16
    chased = true
end
function UserEvent.Custom.endNoRun(evt)
    chased = false
end

function Event.Actions.ShowMap()
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
    local vars = vili.from_file("root://saveData.vili")

    This.SceneNode:setPosition(obe.Transform.UnitVector(vars.currentX, vars.currentY, obe.Transform.Units.ScenePixels))
    This.Animator:setKey(vars.currentKey)
    chased = false
end

function Event.Actions.Up()
if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Up") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            break
        end
    end
    if (check == true) and (lastDirection == "Up") then
        This.SceneNode:move(obe.Transform.UnitVector(0, (runToggle), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Up"
    This.Animator:setKey("Walk_Up")
    This.SceneNode:move(obe.Transform.UnitVector(0, -(runToggle/15), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Down()
if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Down") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            break
        end
    end
    if (check == true) and (lastDirection == "Down") then
        This.SceneNode:move(obe.Transform.UnitVector(0, -(runToggle), obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Down"
    This.Animator:setKey("Walk_Down")
    This.SceneNode:move(obe.Transform.UnitVector(0, (runToggle/15), obe.Transform.Units.ScenePixels))
end

function Event.Actions.Left()
if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Left") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            break
        end
    end
    if (check == true) and (lastDirection == "Left") then
        This.SceneNode:move(obe.Transform.UnitVector((runToggle), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Left"
    This.Animator:setKey("Walk_Left")
    This.SceneNode:move(obe.Transform.UnitVector(-(runToggle/15), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Right()
if (noMove == true) then
        return
    end
    if (lastDirection == nil) or ((lastDirection ~= "Right") and (lastDirection ~= 0)) then
        return
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            break
        end
    end
    if (check == true) and (lastDirection == "Right")  then
        This.SceneNode:move(obe.Transform.UnitVector(-(runToggle), 0, obe.Transform.Units.ScenePixels))
        return
    end

    lastDirection = "Right"
    This.Animator:setKey("Walk_Right")
    This.SceneNode:move(obe.Transform.UnitVector((runToggle/15), 0, obe.Transform.Units.ScenePixels))
end

function Event.Actions.Run()
    if (noMove == true) then
        return
    end
    if (chased == true) then
        return
    end

    if runToggle == 16 then
        runToggle = 48
        return
    elseif runToggle == 48 then
        runToggle = 16
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