function Event.Actions.PauseOrStats()
    This.Sprite:setVisible(not This.Sprite:isVisible())
end

function Local.Init()
    This.Sprite:setVisible(false)
end