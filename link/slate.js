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
        "1920x1080": {"width": 12, "height": 8 }
    },
    "padding": 2
});


// Current Browser
var focusApp = function (argument) { return S.op("focus", {"app": argument}); };

// var current_browser = shell;
// l("current browser = " + current_browser + " " + typeof(current_browser));

// var focusCurrentBrowser = function() {
//     var s = S.sh("/Users/windu/.dotfiles/bin/default_browser", true);
//     S.log("current browser = " + s + " " + typeof(s));
//     return S.op("focus", {"app": s});
// };
// slate.bind("b:ctrl;shift;alt;cmd", focusCurrentBrowser());



S.bnda({
    // App Focus
    "c:ctrl;shift;alt;cmd": focusApp("Messages"),
    "i:ctrl;shift;alt;cmd": focusApp("iTerm"),
    "x:ctrl;shift;alt;cmd": focusApp("Xcode"),
    "e:ctrl;shift;alt;cmd": focusApp("Sublime Text"),
    "s:ctrl;shift;alt;cmd": focusApp("Skype"),
    "n:ctrl;shift;alt;cmd": focusApp("Evernote"),
    "f:ctrl;shift;alt;cmd": focusApp("Finder"),
    "m:ctrl;shift;alt;cmd": focusApp("Mail"),
    "t:ctrl;shift;alt;cmd": focusApp("TweetDeck"),
    "b:ctrl;shift;alt;cmd": focusApp("Google Chrome"),

    // Push Bindings
    "right:ctrl;alt": screenResizeRightHalf,
    "left:ctrl;alt":   screenResizeLeftHalf,
    "up:ctrl;alt":   screenResizeTopHalf,
    "down:ctrl;alt": screenResizeBottomHalf,
    "h:ctrl;alt":   quarterWindowTopLeft,
    "j:ctrl;alt":   quarterWindowBottomLeft,
    "k:ctrl;alt": quarterWindowTopRight,
    "l:ctrl;alt": quarterWindowBottomRight,

    // Postions
    "up:ctrl;shift;alt;cmd": fullscreen,
    "esc:cmd": S.op("hint"),
    "g:ctrl;shift;alt;cmd": theGrid
});
l("Finished loading");
