function Local.Init()
    local fontString = "root://Data/Fonts/dogica/TTF/dogicapixel.ttf"
    local canvas = obe.Canvas.Canvas(1024, 640)
    canvas:Rectangle("rect"){
        x = 0.0,
        y = 0.0,
        width = 1024.0,
        height = 640.0,
        unit = obe.Transform.Units.ScenePixels,
        layer = 2,
        color = "#A097BD"
    }
    canvas:Text("1"){
        font = fontString,
        x = 128.0,
        y = 25.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 80,
        layer = 1,
        color = "#BD264D",
        text = "Murder"
    }
    canvas:Text("2"){
        font = fontString,
        x = 128.0,
        y = 120.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 70,
        layer = 1,
        color = "#FAFAFA",
        text = "   on the"
    }
    canvas:Text("3"){
        font = fontString,
        x = 190.0,
        y = 110.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 100,
        layer = 1,
        color = "#FAFAFA",
        text = "        Cusp"
    }
    canvas:Text("4"){
        font = fontString,
        x = 0.0,
        y = 215.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 70,
        layer = 1,
        color = "#FAFAFA",
        text = "  of an Icsmaun"
    }
    canvas:Text("5"){
        font = fontString,
        x = 128.0,
        y = 300.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 100,
        layer = 1,
        color = "#FAD6A5",
        text = "  Sunset"
    }
    canvas:Text("6"){
        font = fontString,
        x = 280.0,
        y = 550.0,
        unit = obe.Transform.Units.ScenePixels,
        size = 40,
        layer = 1,
        color = "#FAFAFA",
        text = "Press ACCEPT"
    }

    canvas:render(This.Sprite)
end