local vars = vili.from_file("root://saveData.vili")

function Local.Init()
    local canvas = obe.Canvas.Canvas(1024, 640)
    local xPoint = 32 * math.floor(vars.currentSquare.x)
    local yPoint = 32 * math.floor(vars.currentSquare.y)
    canvas:Rectangle("thing"){
        x = xPoint,
        y = yPoint,
        width = 32.0,
        height = 32.0,
        unit = obe.Transform.Units.ScenePixels,
        color = obe.Graphics.Color.Red,
    }
    canvas:render(This.Sprite)
end

function Event.Actions.Back()
    Engine.Scene:loadFromFile(("Scenes/%s.map.vili"):format(vars.currentMap))
end

function Event.Actions.ShowMap()
    Engine.Scene:loadFromFile(("Scenes/%s.map.vili"):format(vars.currentMap))
end