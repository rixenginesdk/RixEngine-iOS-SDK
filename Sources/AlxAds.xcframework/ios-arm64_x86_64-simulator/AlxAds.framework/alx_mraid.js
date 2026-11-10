/**
 * the base of mraid.js is V2.0
 */

console.log("mraid.js start init")

;(function() {
    if(window.mraid){
        return
    }
    var mraid = window.mraid = {};

    var nativeBridge = window.alxMraidBridge || null;

    function postToHost(action, args) {
        try {
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.alxMraid) {
                window.webkit.messageHandlers.alxMraid.postMessage({
                    action: action,
                    args: args || {}
                });
                return true;
            }
        } catch (e) {
            console.log("mraid iOS bridge error:" + e.message);
        }

        try {
            if (nativeBridge && typeof nativeBridge[action] === "function") {
                return callLegacyAndroidBridge(action, args || {});
            }
        } catch (e) {
            console.log("mraid Android bridge error:" + e.message);
        }
        return false;
    }

    function callLegacyAndroidBridge(action, args) {
        switch (action) {
            case "close":
                nativeBridge.close();
                return true;
            case "unload":
                nativeBridge.unload();
                return true;
            case "open":
                nativeBridge.open(args.url);
                return true;
            case "expand":
                nativeBridge.expand(args.url, args.useCustomClose);
                return true;
            case "useCustomClose":
                nativeBridge.useCustomClose(args.useCustomClose);
                return true;
            case "setOrientationProperties":
                nativeBridge.setOrientationProperties(args.allowOrientationChange, args.forceOrientation);
                return true;
            case "resize":
                nativeBridge.resize();
                return true;
            case "storePicture":
                nativeBridge.storePicture(args.url);
                return true;
            case "playVideo":
                nativeBridge.playVideo(args.url);
                return true;
            case "createCalendarEvent":
                nativeBridge.createCalendarEvent(JSON.stringify(args.parameters || {}));
                return true;
            default:
                return false;
        }
    }

    var VERSION = mraid.VERSION = {
        V1_0    : "1.0",
        V2_0    : "2.0",
        V3_0    : "3.0"
    }

    var STATES = mraid.STATES = {
        LOADING     :"loading",
        DEFAULT     :"default",
        EXPANDED    :"expanded",
        RESIZED     :"resized",
        HIDDEN      :"hidden"
    };

    var EVENTS = mraid.EVENTS = {
        READY                   :"ready",
        ERROR                   :"error",
        STATECHANGE             :"stateChange",
        VIEWABLECHANGE          :"viewableChange",
        SIZECHANGE              :"sizeChange",
        AUDIOVOLUMECHANGE       :"audioVolumeChange",
        EXPOSURECHANGE          :"exposureChange"
    };

    var PLACEMENT_TYPES = mraid.PLACEMENT_TYPES = {
        UNKNOWN         :"unknown",
        INLINE          :"inline",
        INTERSTITIAL    :"interstitial"
    };

    var RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION = mraid.RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION = {
        TOP_LEFT        :"top-left",
        TOP_RIGHT       :"top-right",
        TOP_CENTER      :"top-center",
        CENTER          :"center",
        BOTTOM_LEFT     :"bottom-left",
        BOTTOM_RIGHT    :"bottom-right",
        BOTTOM_CENTER   :"bottom-center"
    };

    var ORIENTATION_PROPERTIES_FORCE_ORIENTATION = mraid.ORIENTATION_PROPERTIES_FORCE_ORIENTATION = {
        PORTRAIT    :"portrait",
        LANDSCAPE   :"landscape",
        NONE        :"none"
    };

    var SUPPORT_FEATURES = mraid.SUPPORT_FEATURES = {
        SMS             :"sms",
        TEL             :"tel",
        CALENDAR        :"calendar",
        STOREPICTURE    :"storePicture",
        INLINEVIDEO     :"inlineVideo",
        VPAID           :"vpaid",
        LOCATION        :"location"
    }

    // state
    mraid.state = STATES.LOADING;
    mraid.placementType = PLACEMENT_TYPES.UNKNOWN;
    mraid.viewable = false;

    mraid.allSupports = {
        sms:false,
        tel:false,
        calendar:false,
        storePicture:false,
        inlineVideo:false,
        vpaid:false,
        location:false
    };

    // expand properties
    var expandProperties = {
        width:0,
        height:0,
        useCustomClose:false,
        isModal:true
    };

    // orientation properties
    var orientationProperties = {
        allowOrientationChange:true,
        forceOrientation:ORIENTATION_PROPERTIES_FORCE_ORIENTATION.NONE
    };

    // resize properties
    var resizeProperties = {
        width:0,
        height:0,
        customClosePosition: RESIZE_PROPERTIES_CUSTOM_CLOSE_POSITION.TOP_RIGHT,
        offsetX:0,
        offsetY:0,
        allowOffscreen:true
    };

    // current position
    var curPosition = {
        x:0,
        y:0,
        width:0,
        height:0
    };

    // default position
    var defPosition = {
        x:0,
        y:0,
        width:0,
        height:0
    };

    // max size
    var maxSize = {
        width:0,
        height:0
    };

    // screen size
    var screenSize = {
        width:0,
        height:0
    };

    // current size
    var curSize = {
        width:0,
        height:0
    };

    // current orientation
    var curOrientation = -1;

    var curLocation = {
        lat:0,
        lon:0,
        type:0,
        accuracy:0,
        lastfix:0,
        ipservice:""
    };

    // listeners for events
    var listeners = {};

    var EventListeners = function(event) {
        this.event = event;
        this.count = 0;
        var listeners = {};

        this.add = function(func) {
            var id = String(func);
            if (!listeners[id]) {
                listeners[id] = func;
                this.count++;
            }
        };

        this.remove = function(func) {
            var id = String(func);
            if (listeners[id]) {
                listeners[id] = null;
                delete listeners[id];
                this.count--;
                return true;
            } else {
                return false;
            }
        };

        this.removeAll = function() {
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) this.remove(listeners[id]);
            }
        };

        this.broadcast = function(args) {
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) listeners[id].apply(mraid, args);
            }
        };

        this.toString = function() {
            var out = [event, ':'];
            for (var id in listeners) {
                if (listeners.hasOwnProperty(id)) out.push('|', id, '|');
            }
            return out.join('');
        };
    };

    var contains = function(value, array) {
        for (var i in array) {
            if (array[i] === value) return true;
        }
        return false;
    };

    var clone = function(obj){
        if(obj === null){
            return null;
        }
        var copy = obj.constructor();
        for(var attr in obj){
            if(obj.hasOwnProperty(attr)){
                copy[attr] = obj[attr];
            }
        }
        return copy;
    }

    var broadcastEvent = function() {
        var args = new Array(arguments.length);
        var l = arguments.length;
        for (var i = 0; i < l; i++) args[i] = arguments[i];
        var event = args.shift();
        if (listeners[event]) listeners[event].broadcast(args);
    };

    /**
     * log tool
     */
    var log = window.log = {};
    log.i = function(msg){
        console.log("INFO_MRAID:" + msg);
    }
    log.e = function(msg){
        console.log("ERROR_MRAID:" + msg);
    }

    /**************************************************************************
     * JavaScript API in MRAID
     **************************************************************************/
    mraid.getVersion = function(){
        log.i("mraid.getVersion");
        return VERSION.V3_0;
    }

    mraid.addEventListener = function(event,listener){
        log.i("mraid.addEventListener: event=" + event + ";listener=" + listener)
        if(!event || !listener){
            broadcastEvent(EVENTS.ERROR, 'Both event and listener are required.', 'addEventListener');
        }else if(!contains(event, EVENTS)){
            broadcastEvent(EVENTS.ERROR, 'Unknown MRAID event: ' + event, 'addEventListener');
        }else{
            if (!listeners[event]) {
                listeners[event] = new EventListeners(event);
            }
            listeners[event].add(listener);
        }
    }

    mraid.removeEventListener = function(event,listener){
        log.i("mraid.removeEventListener: event=" + event);
        if (!event) {
            broadcastEvent(EVENTS.ERROR, 'Event is required.', 'removeEventListener');
            return;
        }

        if (listener) {
            // If we have a valid event, we'll try to remove the listener from it.
            var success = false;
            if (listeners[event]) {
                success = listeners[event].remove(listener);
            }

            // If we didn't have a valid event or couldn't remove the listener from the event, broadcast an error and return early.
            if (!success) {
                broadcastEvent(EVENTS.ERROR, 'Listener not currently registered for event.', 'removeEventListener');
                return;
            }

        } else if (!listener && listeners[event]) {
            listeners[event].removeAll();
        }

        if (listeners[event] && listeners[event].count === 0) {
            listeners[event] = null;
            delete listeners[event];
        }
    }

    mraid.open = function(url){
        log.i("mraid.open: url=" + url)
        if(!url){
            broadcastEvent(EVENTS.ERROR,"URL is required","open");
        }else{
            postToHost("open", { url: url });
        }
    }

    mraid.close = function(){
        log.i("mraid.close")
        if(mraid.state === STATES.HIDDEN){
            broadcastEvent(EVENTS.ERROR,"Ad is couldn't be closed when it is already hidden.","close")
        }else{
            postToHost("close");
        }
    }

    /**
     * mraid3.0 add unload method
     */
    mraid.unload = function(){
        log.i("mraid.unload");
        postToHost("unload");
    }

    mraid.useCustomClose = function(shouldUseCustomClose){
        log.i("mraid.useCustomClose: " + shouldUseCustomClose)
        expandProperties.useCustomClose = shouldUseCustomClose;
        postToHost("useCustomClose", { useCustomClose: Boolean(shouldUseCustomClose) });
    }

    mraid.expand = function(url){
        log.i("mraid.expand: url=" + url)
        if(!(this.getState() === STATES.DEFAULT || this.getState() === STATES.RESIZED)){
            broadcastEvent(EVENTS.ERROR,"Ad can only be expanded from the default or resized state.","expand");
            return
        }
        postToHost("expand", {
            url: url || "",
            useCustomClose: Boolean(expandProperties.useCustomClose)
        });
    }

    mraid.isViewable = function(){
        log.i("mraid.isViewable: " + mraid.viewable);
        return mraid.viewable;
    }

    mraid.playVideo = function(uri){
        log.i("mraid.playVideo: uri=" + uri);
        if(!mraid.isViewable()){
            broadcastEvent(EVENTS.ERROR,"playVideo cannot be called until the ad is viewable","playVideo");
            return;
        }
        if(!uri){
            broadcastEvent(EVENTS.ERROR,"playVideo must be called with a valid URI","playVideo");
        }else{
            postToHost("playVideo", { url: uri });
        }
    }

    mraid.resize = function(){
        log.i("mraid.resize");
        if (!(this.getState() === STATES.DEFAULT || this.getState() === STATES.RESIZED)) {
            broadcastEvent(EVENTS.ERROR, 'Ad can only be resized from the default or resized state.', 'resize');
        } else if (!resizeProperties.width || !resizeProperties.height) {
            broadcastEvent(EVENTS.ERROR, 'Must set resize properties before calling resize()', 'resize');
        } else {
            postToHost("resize", clone(resizeProperties));
        }
    }

    mraid.storePicture = function(uri){
        log.i("mraid.storePicture: uri=" + uri)
        if (!mraid.isViewable()) {
            broadcastEvent(EVENTS.ERROR, 'storePicture cannot be called until the ad is viewable', 'storePicture');
            return;
        }
        if (!uri) {
            broadcastEvent(EVENTS.ERROR, 'storePicture must be called with a valid URI', 'storePicture');
        } else {
            postToHost("storePicture", { url: uri });
        }
    }

    mraid.createCalendarEvent = function(parameters){
        log.i("mraid.createCalendarEvent");
        if(!eval(mraid.allSupports["calendar"])){
            broadcastEvent(EVENTS.ERROR,"not support createCalendarEvent")
            return;
        }
        try{
            postToHost("createCalendarEvent", { parameters: parameters || {} });
        }catch(e){
            log.e("createCalendarEvent error: " + e.message)
        }
    }

    // Supports Beginning
    mraid.supports = function(feature){
        log.i("mraid.supports: feature=" + feature);
        return eval(mraid.allSupports[feature]);
    }
    // Supports Ending

    mraid.getPlacementType = function(){
        log.i("mraid.getPlacementType");
        return mraid.placementType;
    }

    mraid.getOrientationProperties = function(){
        log.i("mraid.getOrientationProperties");
        return clone(orientationProperties)
    }

    mraid.setOrientationProperties = function(properties){
        log.i("mraid.setOrientationProperties");

        if (properties.hasOwnProperty('allowOrientationChange')) {
            orientationProperties.allowOrientationChange = Boolean(properties.allowOrientationChange);
        }

        if (properties.hasOwnProperty('forceOrientation')) {
            orientationProperties.forceOrientation = properties.forceOrientation;
        }

        postToHost("setOrientationProperties", {
            allowOrientationChange: Boolean(orientationProperties.allowOrientationChange),
            forceOrientation: orientationProperties.forceOrientation
        });
    }

    mraid.getCurrentPosition = function(){
        log.i("mraid.getCurrentPosition");
        return clone(curPosition);
    }

    mraid.getDefaultPosition = function(){
        log.i("mraid.getDefaultPosition");
        return clone(defPosition);
    }

    mraid.getState = function(){
        log.i("mraid.getState: " + mraid.state)
        return mraid.state;
    }

    mraid.getExpandProperties = function(){
        log.i("mraid.getExpandProperties");
        var properties = {
            width : expandProperties.width,
            height : expandProperties.height,
            useCustomClose : expandProperties.useCustomClose,
            isModal : expandProperties.isModal
        };
        return clone(properties);
    }

    mraid.setExpandProperties = function(properties){
        log.i("mraid.setExpandProperties");
        if (properties.hasOwnProperty('width')) {
            expandProperties.width = properties.width;
        }

        if (properties.hasOwnProperty('height')) {
            expandProperties.height = properties.height;
        }

        if (properties.hasOwnProperty('useCustomClose')) {
            expandProperties.useCustomClose = Boolean(properties.useCustomClose);
        }
    }

    mraid.getMaxSize = function(){
        log.i("mraid.getMaxSize");
        return clone(maxSize);
    }

    mraid.getScreenSize = function(){
        log.i("mraid.getScreenSize");
        return clone(screenSize);
    }

    mraid.getResizeProperties = function(){
        log.i("mraid.getResizeProperties");
        return clone(resizeProperties);
    }

    mraid.setResizeProperties = function(properties){
        log.i("mraid.setResizeProperties");

        var writableFields = ['width', 'height', 'offsetX', 'offsetY', 'customClosePosition', 'allowOffscreen'];
        for (var i = 0; i < writableFields.length; i++) {
            var propname = writableFields[i];
            if (properties.hasOwnProperty(propname)) {
                resizeProperties[propname] = properties[propname];
            }
        }
    }

    /**
     * mraid3.0 add getCurrentAppOrientation method
     */
    mraid.getCurrentAppOrientation = function(){
        log.i("mraid.getCurrentAppOrientation");
        var appOrientation = {
            orientation:ORIENTATION_PROPERTIES_FORCE_ORIENTATION.NONE,
            locked:false
        }
        try{
            switch (curOrientation) {
                case 0:
                    appOrientation.orientation = ORIENTATION_PROPERTIES_FORCE_ORIENTATION.PORTRAIT;
                    break;
                case 90:
                    appOrientation.orientation = ORIENTATION_PROPERTIES_FORCE_ORIENTATION.LANDSCAPE;
                    break;
                default:
                    appOrientation.orientation = ORIENTATION_PROPERTIES_FORCE_ORIENTATION.NONE;
                    break;
            }
            if(orientationProperties.forceOrientation == ORIENTATION_PROPERTIES_FORCE_ORIENTATION.PORTRAIT ||
                orientationProperties.forceOrientation == ORIENTATION_PROPERTIES_FORCE_ORIENTATION.LANDSCAPE){
                appOrientation.locked = true;
            }else{
                appOrientation.locked = false;
            }
        }catch (e) {
            log.e("getCurrentAppOrientation error: " + e.message)
        }
        return appOrientation
    }

    /**
     * mraid3.0 add getLocation method
     */
    mraid.getLocation = function(){
        log.i("mraid.getLocation");
        if (!eval(mraid.allSupports["location"])) {
            broadcastEvent(EVENTS.ERROR, 'not support getLocation', 'getLocation');
            return -1;
        }
        if(curLocation.lat == 0 && curLocation.lon == 0){
            broadcastEvent(EVENTS.ERROR, 'unable to get valid location value', 'getLocation');
            return -1;
        }
        return clone(curLocation);
    }

    /***************************************************************************
     * methods to be called by native Objective-C / Swift / Java
     **************************************************************************/
    mraid.onReady = function(){
        log.i("mraid.onReady");
        broadcastEvent(EVENTS.READY);
    }

    mraid.onError = function(message,action){
        log.i("mraid.onError: message=" + message + ";action=" + action);
        broadcastEvent(EVENTS.ERROR, message, action);
    }

    mraid.onStateChange = function(state){
        log.i("mraid.onStateChange: state=" + state);
        mraid.state = state;
        broadcastEvent(EVENTS.STATECHANGE,mraid.state);
    }

    mraid.onViewableChange = function(isViewable){
        log.i("mraid.onViewableChange: isViewable=" + isViewable);
        mraid.viewable = isViewable;
        broadcastEvent(EVENTS.VIEWABLECHANGE,mraid.viewable);
    }

    mraid.onSizeChange = function(width,height){
        log.i("mraid.onSizeChange: width=" + width + ";height=" + height);
        if(width != curSize.width || height != curSize.height){
            curSize.width = width;
            curSize.height = height;
            broadcastEvent(EVENTS.SIZECHANGE,width,height);
        }
    }

    mraid.onAudioVolumeChange = function(volumePercentage){
        log.i("mraid.onAudioVolumeChange: volumePercentage=" + volumePercentage);
        broadcastEvent(EVENTS.AUDIOVOLUMECHANGE,volumePercentage);
    }

    mraid.onExposureChange = function(exposedPercentage,visibleRectangle,occlusionRectangles){
        log.i("mraid.onExposureChange: exposedPercentage=" + exposedPercentage);
        broadcastEvent(EVENTS.EXPOSURECHANGE,exposedPercentage,visibleRectangle,occlusionRectangles);
    }

    mraid.setPlacementType = function(placementType){
        log.i("mraid.setPlacementType: placementType=" + placementType);
        mraid.placementType = placementType;
    }

    mraid.setCurrentPosition = function(x,y,width,height){
        log.i("mraid.setCurrentPosition: x=" + x + ";y=" + y + ";width=" + width + ";height=" + height);
        curPosition.x = x;
        curPosition.y = y;
        curPosition.width = width;
        curPosition.height = height;
    }

    mraid.setDefaultPosition = function(x,y,width,height){
        log.i("mraid.setDefaultPosition: x=" + x + ";y=" + y + ";width=" + width + ";height=" + height);
        defPosition.x = x;
        defPosition.y = y;
        defPosition.width = width;
        defPosition.height = height;
    }

    mraid.setMaxSize = function(width,height){
        log.i("mraid.setMaxSize: width=" + width + ";height=" + height);
        maxSize.width = width;
        maxSize.height = height;
    }

    mraid.setScreenSize = function(width,height){
        log.i("mraid.setScreenSize: width=" + width + ";height=" + height);
        screenSize.width = width;
        screenSize.height = height;
    }

    mraid.setOrientation = function(orientation){
        log.i("mraid.setOrientation: orientation=" + orientation);
        curOrientation = orientation;
    }

    mraid.setLocation = function(lat,lon,type,accuracy,lastfix,ipservice){
        log.i("mraid.setLocation: lat=" + lat + ";lon=" + lon);
        curLocation.lat = lat;
        curLocation.lon = lon;
        curLocation.type = type;
        curLocation.accuracy = accuracy;
        curLocation.lastfix = lastfix;
        curLocation.ipservice = ipservice;
    }

}());
