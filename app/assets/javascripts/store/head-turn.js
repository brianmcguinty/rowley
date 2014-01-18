// Info on the user's browser
var userBrowser = {
    'name':     '',
    'version':  0
};

jQuery(document).ready(function() {
    // IE detection code from http://www.javascriptkit.com/javatutors/navigator.shtml
    if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
        userBrowser = {
            'name':     'ie',
            'version':  new Number(RegExp.$1)
        };
    }
});

(function ($) {

    /*
    An object containing info on each of the headturns on the page.
    Look up a headturn by its id to get info about it.
    Sample key-value pair:
    'someId': {
        'picCount': 7,
        'currentIndex': 0,
        'defaultIndex': 3,
        'mouseHovered': false,
        'compoundImage': a jQuery object of the big headturn image
    }
    */
    var allHeadTurns = {};


    // Given an image and its container (both jQuery objects), returns the number of times that the image
    // will fill the container's supplied dimension, either width or height.
    // Returns a whole number 1 or higher, or NaN if the calculation has invalid inputs.
    function getPicCount(imageDimension, containerDimension) {
        return Math.max( 1, Math.ceil( imageDimension / containerDimension ) );
    }


    // Returns the structured data on a frame given the frame's jQuery object
    function getFrame(frame) {
        return allHeadTurns[frame.data('identifier')];
    }


    function headturnInteraction(evt) {

        evt.preventDefault();       // Suppress default touchmove behavior in touch UIs

        var pageX;
        // Detect whether it's a touch interaction or not, and fetch pageX accordingly.
        if (evt.originalEvent.touches) {
            pageX = evt.originalEvent.touches[evt.originalEvent.touches.length-1].pageX;
        }
        else {
            pageX = evt.pageX;
        }

        // Remove any helper overlays (snap out in IE, b/c its fadeOut looks bad on alpha pngs)
        var helpOverlay = jQuery(this).find('.help-overlay');
        if (userBrowser['name'] == 'ie' && userBrowser['version'] < 9) {
            helpOverlay.hide();
        }
        else {
            helpOverlay.fadeOut('fast');
        }

        var frame = getFrame(jQuery(this));
        var mouseJustEntered = (frame['mouseHovered'] == false) ? true : false;
        frame['mouseHovered'] = true;
        // How far across the image horizontally is the cursor? 0 <= percentAcross <= 1
        var percentAcross = (pageX - jQuery(this).offset().left) / jQuery(this).width();
        var targetIndex;
        // Based on percentAcross and the picCount, calculate which image to display.
        for (var i=0; i < frame['picCount']; i++) {
            if (i/frame['picCount'] < percentAcross && (i+1)/frame['picCount'] > percentAcross) {
                targetIndex = i;
                break;
            }
        }

        // Animate to the target image
        if (!isNaN(targetIndex) && targetIndex != frame['currentIndex']) {
            animateModel(frame, frame['currentIndex'], targetIndex, mouseJustEntered);
        }
    }


    // Moves the model smoothly through the intermediate images rather than just
    // just snapping directly to the target image.
    function animateModel(frame, startIndex, targetIndex, delay, dontThrottle) {

        // Time in ms. A mousemove sooner than this after the previous mousemove won't fire a new headturn recursion.
        var MIN_BTWN_MOVES = 50;

        // Animation delay, in ms
        var STD_FRAME_DELAY = 20;

        // Commented out b/c a frame delay seems to always look better. But I'm leaving
        // the code here in case we want to start selectively turning off the delay.
        // var frameDelay = (delay) ? STD_FRAME_DELAY : 0;
        var frameDelay = STD_FRAME_DELAY;

        // Make CSS adjustments for clients that need it (e.g. Mobile Safari).
        // It's an integer representing pixels. Negative bumps left, positive bumps right.
        // The 0.0034 multiplier is the arbitrary amount that fixes Mobile Safari's imprecision.
        var adjustment = (isMobileSafari) ? Math.round(frame['picWidth']* 0.0034) : 0;

        var now = new Date();

        // This condition prevents from headturns being fired in too-rapid succession.
        if (!lastHeadturnMove || now - lastHeadturnMove > MIN_BTWN_MOVES || dontThrottle) {
            lastHeadturnMove = now;
            var i;
            for (i = 0; i < frame['picCount']; i++) {
                if (i == startIndex) {
                    var newLeft = 0 - (i * frame['picWidth']) + (adjustment * i);
                    frame['compoundImage'].attr('style', 'left: '+ newLeft +'px !important');
                }
            }
            frame['currentIndex'] = startIndex;
            setTimeout(
                function() {
                    if (startIndex != targetIndex) {
                        var step = (startIndex > targetIndex) ? -1 : 1;
                        animateModel(frame, startIndex+step, targetIndex, frameDelay, true);
                    }
                },
                frameDelay
            );
        }
    }

    // Return model to default
    function turnToDefault(evt) {
        var frame = getFrame(jQuery(this));
        frame['mouseHovered'] = false;
        // There's a short delay to prevent flickering when the the mouse
        // leaves the wrapper and then immediately reenters. It doesn't *have*
        // to be 250ms, but that's about the right amount of time.
        setTimeout(
            function() {
                if (frame['mouseHovered'] != true) {
                    animateModel(frame, frame['currentIndex'], frame['defaultIndex'], true);
                }
            },
            250
        );
    }


    // Variables for timing interactions with the headturn
    var lastHeadturnMove = null;


    // Boolean, true if the user is on an iPhone, iPod, or iPad
    var isMobileSafari = false;


    // Run when the page is ready
    jQuery(document).ready(function() {

        var headturnImageWraps = jQuery('.headturn-image-wrap');

        // Detect whether this is a Mobile Safari device. From code at:
        // http://www.sitepoint.com/identify-apple-iphone-ipod-ipad-visitors
        var appleDeviceInfo = {};
        appleDeviceInfo.ua = navigator.userAgent;
        appleDeviceInfo.types = ['iPhone', 'iPod', 'iPad'];
        for (var d = 0; d < appleDeviceInfo.types.length; d++) {
            var t = appleDeviceInfo.types[d];
            appleDeviceInfo[t] = !!appleDeviceInfo.ua.match(new RegExp(t, 'i'));
            isMobileSafari = isMobileSafari || appleDeviceInfo[t];
        }


        jQuery(window).load(function() {
            // Prep work for each headturn. This gets done once to avoid having to do
            // it after every interaction event with the headturn. Wrapped in load()
            // because you can't measure an image's width until it has loaded.
            headturnImageWraps.each(function(i) {
                var headturnWrap = jQuery(this);
                var headturnImage = headturnWrap.find('.headturn-image').eq(0);

                var htWrapStyleMap = {'overflow': 'hidden'};

                if ( headturnWrap.css('position') == 'static' ) {
                    htWrapStyleMap['position'] = 'relative';
                }
                headturnWrap.css(htWrapStyleMap);

                if ( headturnImage.css('position') == 'static' ) {
                    headturnImage.css('position', 'absolute');
                }

                var thisHeadTurn = {};

                // Figure out pic width in pixels (assumes all the pics in the headturn have the same width)
                thisHeadTurn['picWidth'] = headturnWrap.width();

                // Automatically figure out the number of pics in the headturn. Have to make
                // sure it's visible, because jQuery returns a width of 0 for hidden images.
                var startedHidden = headturnWrap.is(':visible') === false;
                if (startedHidden) {
                    // If the headturn image isn't visible, we make an out-of-the-viewport clone, measure
                    // its dimensions, and then get rid of it. We could just try to show the image
                    // itself, briefly and out of the viewport, but that won't work if it's nested
                    // within a parent and the parent is hidden.
                    var tempMeasHeadturnImage = headturnImage.clone(false);
                    tempMeasHeadturnImage.css({
                        display:    'block',
                        position:   'absolute',
                        top:        '-20000px',
                        left:       '-20000px'
                    });
                    jQuery('body').append(tempMeasHeadturnImage);
                    thisHeadTurn['picCount'] = getPicCount(tempMeasHeadturnImage.width(), thisHeadTurn['picWidth']);
                    tempMeasHeadturnImage.remove();
                }
                else {
                    thisHeadTurn['picCount'] = getPicCount(headturnImage.width(), thisHeadTurn['picWidth']);
                }

                // Figure out default index (0-indexed) and set current index
                // Default index is the middle one, unless the headturn wrap
                // has a "no-center" class, then it's 0.
                thisHeadTurn['defaultIndex'] = (headturnWrap.hasClass('no-center')) ? 0 : Math.floor(thisHeadTurn['picCount'] / 2);
                thisHeadTurn['currentIndex'] = thisHeadTurn['defaultIndex'];

                // mouseHovered keeps track of whether the mouse is currently on the headturn (obviously).
                // It's useful for events that are delayed responses to mouseleave.
                thisHeadTurn['mouseHovered'] = false;

                // Save the jQuery object of the compound image, for later use
                thisHeadTurn['compoundImage'] = headturnImage;

                headturnWrap.data('identifier', headturnImageWraps.index(headturnWrap));
                allHeadTurns[headturnWrap.data('identifier')] = thisHeadTurn;

                // Prime it
                headturnImage.css({
                    position:   'relative',
                    left:       0 - (thisHeadTurn['picWidth'] * thisHeadTurn['defaultIndex'])
                });
                animateModel(thisHeadTurn, thisHeadTurn['currentIndex'], thisHeadTurn['defaultIndex'], false);
            });
        });


        // Listening for interaction with headturns. Touchmove covers drag events from touch UIs.
        headturnImageWraps.mousemove(headturnInteraction);
        headturnImageWraps.live('touchmove', headturnInteraction);


        // On mouseleave (or touchend, for touch UIs), returns the model's head to the default positon.
        //headturnImageWraps.mouseleave(turnToDefault);
        //headturnImageWraps.live('touchend', turnToDefault);

    });

})(jQuery);