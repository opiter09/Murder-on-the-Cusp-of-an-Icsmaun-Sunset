local canvas
local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"

function Local.Init()
    canvas = obe.Canvas.Canvas(1024, 640)
    canvas:render(This.Sprite)
end