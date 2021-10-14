function Local.Init()
    local config = vili.from_file("root://config.vili")

    local xThing = config.Camera.xOffsetRight
    local yThing = config.Camera.yOffsetDown
    local zoomAmount = (1 / config.Camera.zoom)

    Engine.Scene:getCamera():move(obe.Transform.UnitVector(xThing, yThing, obe.Transform.Units.ScenePixels))
    Engine.Scene:getCamera():scale(zoomAmount, obe.Transform.Referential.Center)
end
