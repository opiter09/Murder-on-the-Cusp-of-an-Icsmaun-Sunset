local battleTable
local Pause
local slot

function Event.Actions.PauseOrStats()
    Pause = not Pause
end

function UserEvent.Custom.SlotAction()
    battleTable = vili.from_file("root://Data/battleTable.vili")
    local string = ("slot%s"):format(slot)
    if (battleTable.enemies[string] == 0) then
        This.Sprite:setVisible(false)
        return
    end
    This.Sprite:loadTexture(("sprites://GameObjects/EnemyBattleSprites/%s.png"):format(battleTable.enemies[string].ID))
    This.Sprite:useTextureSize()
    This.Sprite:setVisible(true)
end

function Local.Init(Slot, xPos, yPos)
    Pause = false
    slot = Slot
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))
end