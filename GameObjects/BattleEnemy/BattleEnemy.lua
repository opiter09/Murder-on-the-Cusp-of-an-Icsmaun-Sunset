local Pause = false

function UserEvent.Custom.PausePressed(evt)
    Pause = not Pause
end

function Local.Init(Slot, xPos, yPos)
end