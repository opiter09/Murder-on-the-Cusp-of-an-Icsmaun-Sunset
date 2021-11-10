function Event.Actions.PauseOrStats()
    This.Sprite:setZDepth(-1 * This.Sprite:getZDepth())

    local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
    CustomGroup:trigger("PausePressed", {})
end
