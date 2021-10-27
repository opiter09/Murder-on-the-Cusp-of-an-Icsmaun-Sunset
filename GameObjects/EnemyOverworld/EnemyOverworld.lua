local chasing = false
local DefeatedNumber
local Direction
local Distance
local startingX
local startingY

function Local.Init(sprite, defeatedNumber, initX, initY, direction, distance, visibility)
    This.Sprite:loadTexture(("sprites://GameObjects/%s/Walk_Down/1.png"):format(sprite))
    This.Animator:load(("sprites://GameObjects/%s"):format(sprite))
    This.Animator:setKey(("Idle_%s"):format(direction))
    This.SceneNode:setPosition(obe.Transform.UnitVector(initX, initY, obe.Transform.Units.ScenePixels))

    DefeatedNumber = defeatedNumber
    local vars = vili.from_file("root://saveData.vili")
    if (vars.defeated[Engine.Scene:getLevelName()][DefeatedNumber] ~= 0) then
        This.Sprite:setVisible(false)
        This.Collider:addTag(obe.Collision.ColliderTagType.Tag, "Invisible")
        return
    end

    Direction = direction
    Distance = distance * 32
    startingX = initX
    startingY = initY

    if (visibility == false) then
        This.Sprite:setVisible(false)
        This.Collider:addTag(obe.Collision.ColliderTagType.Tag, "Invisible")
    end
end

function UserEvent.Custom.Reveal()
    local vars = vili.from_file("root://saveData.vili")
    if (vars.defeated[Engine.Scene:getLevelName()][DefeatedNumber] ~= 0) then
        return
    end

    This.Sprite:setVisible(true)
    This.Collider:removeTag(obe.Collision.ColliderTagType.Tag, "Invisible")
end

local function pursuePlayer()
    local playerX = Engine.Scene:getGameObject("Protagonist").Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x
    local playerY = Engine.Scene:getGameObject("Protagonist").Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y
    local thisX = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).x
    local thisY = This.Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels).y

    local distTable = {
        left = thisX - playerX,
        right = playerX - thisX,
        up = thisY - playerY,
        down = playerY - thisY
    }
    if (distTable.left < 0) then distTable.left = 10000 end
    if (distTable.right < 0) then distTable.right = 10000 end
    if (distTable.up < 0) then distTable.up = 10000 end
    if (distTable.down < 0) then distTable.down = 10000 end
    local short = math.min(distTable.left, distTable.right, distTable.up, distTable.down)

    if (short == distTable.left) then
        This.Animator:setKey("Walk_Left")
        This.SceneNode:move(obe.Transform.UnitVector(-(32/15), 0, obe.Transform.Units.ScenePixels))
    elseif (short == distTable.right) then
        This.Animator:setKey("Walk_Right")
        This.SceneNode:move(obe.Transform.UnitVector((32/15), 0, obe.Transform.Units.ScenePixels))
    elseif (short == distTable.up) then
        This.Animator:setKey("Walk_Up")
        This.SceneNode:move(obe.Transform.UnitVector(0, -(32/15), obe.Transform.Units.ScenePixels))
    elseif (short == distTable.down) then
        This.Animator:setKey("Walk_Down")
        This.SceneNode:move(obe.Transform.UnitVector(0, (32/15), obe.Transform.Units.ScenePixels))
    end

    local check
    local colliders = Engine.Scene:getAllColliders()
    for i, v in pairs(colliders) do
        check = This.Collider:doesCollide(v, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) and (v ~= This.Collider) and (v:doesHaveTag(obe.Collision.ColliderTagType.Tag, "Invisible") == false) then
            break
        end
    end
    if (check == true) then
        if (short == distTable.left) then
            This.SceneNode:move(obe.Transform.UnitVector(32, 0, obe.Transform.Units.ScenePixels))
        elseif (short == distTable.right) then
            This.SceneNode:move(obe.Transform.UnitVector(-32, 0, obe.Transform.Units.ScenePixels))
        elseif (short == distTable.up) then
            This.SceneNode:move(obe.Transform.UnitVector(0, 32, obe.Transform.Units.ScenePixels))
        elseif (short == distTable.down) then
            This.SceneNode:move(obe.Transform.UnitVector(0, -32, obe.Transform.Units.ScenePixels))
        end
    end
end

function Event.Game.Update()
    if (This.Sprite:getVisible() == false) then
        return
    end

    local vars = vili.from_file("root://saveData.vili")
    if (vars.defeated[Engine.Scene:getLevelName()][DefeatedNumber] ~= 0) then
        return
    end

    if (chasing == true) then
        local playerCollider = Engine.Scene:getGameObject("Protagonist").Collider
        local check = This.Collider:doesCollide(playerCollider, obe.Transform.UnitVector(0, 0, obe.Transform.Units.ScenePixels), true)
        if (check == true) then
            local config = vili.from_file("root://config.vili")
            local xThing = (-1) * config.Camera.xOffsetRight
            local yThing = (-1) * config.Camera.yOffsetDown
            Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
            Engine.Scene:getCamera():scale(config.Camera.zoom, obe.Transform.Referential.Center)
            local position = Engine.Scene:getGameObject("Protagonist").Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
            vars.currentX = position.x
            vars.currentY = position.y
            vars.currentKey = Engine.Scene:getGameObject("Protagonist").Animator:getKey()
            vili.to_file("root://saveData.vili", vars)
            Engine.Scene:loadFromFile("scenes://Battleground.map.vili")
            return
        end
        pursuePlayer()
        return
    end

    local playerPos = Engine.Scene:getGameObject("Protagonist").Sprite:getPosition(obe.Transform.Referential.TopLeft):to(obe.Transform.Units.ScenePixels)
    if (Direction == "Up") then
        if (math.abs(startingX - playerPos.x) < 32) and (math.max((startingY - playerPos.y), 0) < Distance) then
            chasing = true
        end
    elseif (Direction == "Down") then
        if (math.abs(startingX - playerPos.x) < 32) and (math.max((playerPos.y - startingY), 0) < Distance) then
            chasing = true
        end
    elseif (Direction == "Left") then
        if (math.abs(startingY - playerPos.y) < 32) and (math.max((startingX - playerPos.x), 0) < Distance) then
            chasing = true
        end
    elseif (Direction == "Right") then
        if (math.abs(startingY - playerPos.y) < 32) and (math.max((playerPos.x - startingX), 0) < Distance) then
            chasing = true
        end
    end
end