S.src('.reslate/reslate.js');

/*
var retile = function(windowObject) {
  var windows = [];
  slate.eachApp(function(app) {
    app.eachWindow(function(win) {
      if (win.isMinimizedOrHidden()) return;
      if (null == win.title() || win.title() === "") return;
      windows.push(win);
    });
  });

  var ss          = S.rect();
  var windowSizeX = ss.width * 0.4;
  var windowSizeY = ss.height / (windows.length - 1);
  var winPosY     = 0;

  for (i = 0; i < windows.length; i++) {
    w = windows[i];

    if (w.title() == windowObject.title()) {
      mainWidth = (windows.length > 1) ? "screenSizeX*0.6" : "screenSizeX";

      w.doOperation("move", {
        "x": "screenOriginX",
        "y": "screenOriginY",
        "width": mainWidth,
        "height": "screenSizeY"
      });
    }
    else {
      w.doOperation("move", {
        "x": "screenSizeX*0.6",
        "y": winPosY,
        "width": windowSizeX,
        "height": windowSizeY
      });

      winPosY += windowSizeY;
    }
  }
}
*/

slate.alias('hyper', 'alt;cmd');

// begin config
slate.configAll({
  defaultToCurrentScreen: true,
  nudgePercentOf: 'screenSize',
  resizePercentOf: 'screenSize',
  undoOps: [
    'active-snapshot',
    'chain',
    'grid',
    'layout',
    'move',
    'resize',
    'sequence',
    'shell',
    'push'
  ]
});

// keybinds
slate.bindAll({
  hyper: {
    shift: {
      // edges
      h: [$('barResize', 'left',   3),
        $('center',    'left',   3, 3)],
      j: [$('barResize', 'bottom', 2),
        $('center',    'bottom', 3, 3)],
      k: [$('barResize', 'top',    2),
        $('center',    'top',    3, 3)],
      l: [$('barResize', 'right',  3),
        $('center',    'right',  3, 3)],

      // corners
      y: [$('corner', 'top-left',     3, 2),
        $('corner', 'top-left',     3, 3)],
      i: [$('corner', 'top-right',    3, 2),
        $('corner', 'top-right',    3, 3)],
      b: [$('corner', 'bottom-left',  3, 2),
        $('corner', 'bottom-left',  3, 3)],
      m: [$('corner', 'bottom-right', 3, 2),
        $('corner', 'bottom-right', 3, 3)],

      // centers
      u: [$('center', 'top'),
        $('center', 'top', 3, 3)],
      n: [$('center', 'bottom'),
        $('center', 'bottom', 3, 3)],
      'return': $('center', 'center', 3, 3)
    },
    // bars
    h: [$('barResize', 'left',  2),
      $('barResize', 'left',  1.5)],
    j: $('barResize', 'bottom', 2),
    k: $('barResize', 'top',    2),
    l: [$('barResize', 'right', 2),
      $('barResize', 'right', 1.5)],
    // corners
    y: [$('corner', 'top-left'),
      $('corner', 'top-left', 1.5)],
    i: [$('corner', 'top-right'),
      $('corner', 'top-right', 1.5)],
    b: [$('corner', 'bottom-left'),
      $('corner', 'bottom-left', 1.5)],
    m: [$('corner', 'bottom-right'),
      $('corner', 'bottom-right', 1.5)],
    // centers
    u: $('center', 'top'),
    n: $('center', 'bottom'),
    'return': $('center', 'center'),
    // throw to monitor
    '`': ['throw 0 resize',
      'throw 1 resize'],
    '1': $('toss', '0', 'resize'),
    '2': $('toss', '1', 'resize'),
    '3': $('toss', '2', 'resize'),
    // direct focus
    b: $.focus('Google Chrome'),
    t: $.focus('Terminal'),
    // utility functions
    f1: 'relaunch',
    z: 'undo',
    tab: 'hint'
    //r: retile
  }
});

/*
slate.on("windowOpened", function(event, win) { retile(win); });
slate.on("windowClosed", function(event, win) { retile(win); });
slate.on("appOpened", function(event, win) { retile(win); });
slate.on("appClosed", function(event, win) { retile(win); });
slate.on("appHidden", function(event, win) { retile(win); });
slate.on("appUnhidden", function(event, win) { retile(win); });
*/

