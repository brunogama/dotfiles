// Logging
var logCount = 0;
var l = function(msg) {
    msg = typeof msg !== 'undefined' ? msg: "";
    logCount++;
    S.log(logCount.toString()+": "+ msg);
};

var windowHintDimension = 64;
S.cfga({
    "defaultToCurrentScreen":         true,
    "nudgePercentOf":                 "screenSize",
    "resizePercentOf":                "screenSize",
    "checkDefaultsOnLoad":            true,
    "gridCellRoundedCornerSize":      0,
    "gridRoundedCornerSize":          0,
    "windowHintsShowIcons":           true,
    "windowHintsIgnoreHiddenWindows": false,
    "windowHintsSpread":              true,
    "windowHintsSpreadSearchWidth":   windowHintDimension,
    "windowHintsSpreadSearchHeight":  windowHintDimension,
    "windowHintsSpreadPadding":       windowHintDimension,
    "windowHintsOrder":               "leftToRight",
    "windowHintsBackgroundColor":     [50, 53, 58, 0.9],
    "windowHintsHeight":              windowHintDimension,
    "windowHintsWidth":               windowHintDimension
});


var show = slate.operation("show", {
    "app": "current"
});

slate.bind("1:ctrl", show);

// var sLaptop = "1440x990";
// var sHP     = "1920x1080";

// Operations
var fullscreen = S.op("move", {
        "x" : "screenOriginX",
        "y" : "screenOriginY",
        "width" : "screenSizeX",
        "height" : "screenSizeY"
});

var screenResizeRightHalf = S.op("push", {
    "direction" : "right",
    "style" : "bar-resize:screenSizeX/2"
});

var screenResizeLeftHalf = screenResizeRightHalf.dup({"direction": "left"});

var screenResizeTopHalf = S.op("push", {
    "direction" : "up",
    "style" : "bar-resize:screenSizeY/2"
});

var screenResizeBottomHalf = screenResizeTopHalf.dup({"direction": "down"});


var quarterWindowTopLeft = S.op("move", {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" :  "screenSizeX/2",
  "height" : "screenSizeY/2",
  "screen": "1"
});

var quarterWindowBottomLeft = quarterWindowTopLeft.dup({"y": "screenSizeY/2"});
var quarterWindowTopRight = quarterWindowTopLeft.dup({"x": "screenSizeX/2"});
var quarterWindowBottomRight = quarterWindowTopRight.dup({"y": "screenSizeY/2"});

var theGrid = S.op("grid", {
    "grids": {
        "1440x900":  { "width": 12, "height": 8 },
        "1920x1080": {"width": 14, "height": 10 }
    },
    "padding": 2
});


// Current Browser
var focusApp = function (argument) { return S.op("focus", {"app": argument}); };

S.bnda({
    // App Focus
    "i:ctrl;shift;alt;cmd": focusApp("iTerm2"),
    "x:ctrl;shift;alt;cmd": focusApp("Xcode"),
    "z:ctrl;shift;alt;cmd": focusApp("Simulator"),
    "a:ctrl;shift;alt;cmd": focusApp("Android Studio"),
    "e:ctrl;shift;alt;cmd": focusApp("Sublime Text"),
    "f:ctrl;shift;alt;cmd": focusApp("Finder"),
    "b:ctrl;shift;alt;cmd": focusApp("Google Chrome"),
    "y:ctrl;shift;alt;cmd": focusApp("Skype"),
    "t:ctrl;shift;alt;cmd": focusApp("Spotify"),
    "m:ctrl;shift;alt;cmd": focusApp("Franz"),
    "s:ctrl;shift;alt;cmd": focusApp("Slack"),
    "w:ctrl;shift;alt;cmd": focusApp("WhatsApp"),


    // Push Bindings
    "left:ctrl;shift;alt;cmd": screenResizeLeftHalf,
    "right:ctrl;shift;alt;cmd": screenResizeRightHalf,
    // "\:ctrl;shift;alt;cmd": screenResizeTopHalf,
    // ":ctrl;shift;alt;cmd": screenResizeBottomHalf,

    "]:ctrl;shift;alt;cmd": quarterWindowTopRight,
    "':ctrl;shift;alt;cmd": quarterWindowBottomRight,
    "[:ctrl;shift;alt;cmd": quarterWindowTopLeft,
    ";:ctrl;shift;alt;cmd": quarterWindowBottomLeft,

    // Postions
    "up:ctrl;shift;alt;cmd": fullscreen,
    "3:ctrl;shift;alt;cmd": theGrid
});
l("Finished loading");
