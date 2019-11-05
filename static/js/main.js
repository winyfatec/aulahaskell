//document.write("Hello");

    var elem = document.createElement('script');
    elem.src = 'https://quantcast.mgr.consensu.org/cmp.js';
    elem.async = true;
    elem.type = "text/javascript";
    var scpt = document.getElementsByTagName('script')[0];
    scpt.parentNode.insertBefore(elem, scpt);
    (function() {
    var gdprAppliesGlobally = false;
    function addFrame() {
        if (!window.frames['__cmpLocator']) {
        if (document.body) {
            var body = document.body,
                iframe = document.createElement('iframe');
            iframe.style = 'display:none';
            iframe.name = '__cmpLocator';
            body.appendChild(iframe);
        } else {
            setTimeout(addFrame, 5);
        }
        }
    }
    addFrame();
    function cmpMsgHandler(event) {
        var msgIsString = typeof event.data === "string";
        var json;
        if(msgIsString) {
        json = event.data.indexOf("__cmpCall") != -1 ? JSON.parse(event.data) : {};
        } else {
        json = event.data;
        }
        if (json.__cmpCall) {
        var i = json.__cmpCall;
        window.__cmp(i.command, i.parameter, function(retValue, success) {
            var returnMsg = {"__cmpReturn": {
            "returnValue": retValue,
            "success": success,
            "callId": i.callId
            }};
            event.source.postMessage(msgIsString ?
            JSON.stringify(returnMsg) : returnMsg, '*');
        });
        }
    }
    window.__cmp = function (c) {
        var b = arguments;
        if (!b.length) {
        return __cmp.a;
        }
        else if (b[0] === 'ping') {
        b[2]({"gdprAppliesGlobally": gdprAppliesGlobally,
            "cmpLoaded": false}, true);
        } else if (c == '__cmp')
        return false;
        else {
        if (typeof __cmp.a === 'undefined') {
            __cmp.a = [];
        }
        __cmp.a.push([].slice.apply(b));
        }
    }
    window.__cmp.gdprAppliesGlobally = gdprAppliesGlobally;
    window.__cmp.msgHandler = cmpMsgHandler;
    if (window.addEventListener) {
        window.addEventListener('message', cmpMsgHandler, false);
    }
    else {
        window.attachEvent('onmessage', cmpMsgHandler);
    }
    })();
    window.__cmp('init', {
    		'Language': 'pt',
		'Initial Screen Body Text Option': 1,
		'Publisher Name': 'Moneytizer',
		'Default Value for Toggles': 'off',
		'UI Layout': 'banner',
		'No Option': false,
    });