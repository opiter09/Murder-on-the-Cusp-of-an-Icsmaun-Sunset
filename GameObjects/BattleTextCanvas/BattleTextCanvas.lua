local canvas
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