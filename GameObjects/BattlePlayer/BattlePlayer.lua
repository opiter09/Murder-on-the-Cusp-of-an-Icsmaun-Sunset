local battleTable
local Pause
local slot

function Event.Actions.PauseOrStats()
    Pause = not Pause
end

function UserEvent.Custom.SlotAction()
    battleTable = vili.from_file("root://Data/battleTable.vili")
    local string = ("slot%s"):format(slot)
    if (battleTable.player[string] == 0) then
        This.Sprite:setVisible(false)
        return
    end
    if (battleTable.player[string].Sprite ~= nil) then
        This.Sprite:loadTexture(("sprites://GameObjects/PlayerBattleSprites/%s/%s.png"):format(battleTable.player[string].ID, battleTable.player[string].Sprite))
    else
        This.Sprite:loadTexture(("sprites://GameObjects/PlayerBattleSprites/%s.png"):format(battleTable.player[string].ID))
    end
    This.Sprite:useTextureSize()
    This.Sprite:setVisible(true)
end

function Local.Init(Slot, xPos, yPos)
    Pause = false
    slot = Slot
    This.SceneNode:setPosition(obe.Transform.UnitVector(xPos, yPos, obe.Transform.Units.ScenePixels))
end