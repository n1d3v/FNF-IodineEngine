package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.util.FlxStringUtil;

/**
    The FPS class provides an easy-to-use monitor to display
    the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
    /**
        The current frame rate, expressed using frames-per-second
    **/
    public var currentFPS(default, null):Int;

    @:noCompletion private var times:Array<Float>;

    public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFF)
    {
        super();

        this.x = x;
        this.y = y;

        currentFPS = 0;
        selectable = false;
        mouseEnabled = false;
        defaultTextFormat = new TextFormat("_sans", 14, color, true);
        autoSize = LEFT;
        multiline = true;

        times = [];

        updateText();
    }

    var deltaTimeout:Float = 0.0;

    // Event Handlers
    private override function __enterFrame(deltaTime:Float):Void
    {
        // prevents the overlay from updating every frame, why would you need to anyways
        if (deltaTimeout > 1000) {
            deltaTimeout = 0.0;
            return;
        }

        final now:Float = haxe.Timer.stamp() * 1000;
        times.push(now);
        while (times[0] < now - 1000) times.shift();

        currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
        updateText();
        deltaTimeout += deltaTime;
    }

    private function updateText():Void
    {
        var textFormat:TextFormat = defaultTextFormat.clone();
        textFormat.leading = 5; // Add some spacing between lines

        text = 'FPS: ${currentFPS}';

        setTextFormat(textFormat, 0, text.length);

        textColor = currentFPS < FlxG.drawFramerate * 0.5 ? 0xFF0000 : 0xFFFFFF; // Red if FPS is low
    }
}
