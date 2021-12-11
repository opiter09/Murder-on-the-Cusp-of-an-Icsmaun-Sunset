local canvas
local CustomGroup = Engine.Events:getNamespace("UserEvent"):joinGroup("Custom")
local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"

function UserEvent.Custom.beginText(evt)
    This.Sprite:setVisible(false)
end

function UserEvent.Custom.endText(evt)
    This.Sprite:setVisible(true)
end

function Local.Init()
    canvas = obe.Canvas.Canvas(1024, 640)
    canvas:render(This.Sprite)
end

function UserEvent.Custom.beginTurn(evt)
    local battleTable = vili.from_file("root://Data/battleTable.vili")
    canvas:clear()

    if (battleTable.currentTurn == "Enemies") then
        CustomGroup:trigger("magiqueChange", { Side = "Enemies", Amount = battleTable.enemies.magiqueRegen })
    end
end