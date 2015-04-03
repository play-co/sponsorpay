import event.Emitter as Emitter;

var events = [
  'Initialized',
  // 'InterstitialAvailable',
  // 'InterstitialNotAvailable',
  // 'InterstitialError',
  // 'InterstitialCompleted',
  'VideoAvailable',
  'VideoNotAvailable',
  'VideoError',
  'VideoCompleted'
];

var SponsorPay = Class(Emitter, function (supr) {

  this.init = function () {
    supr(this, 'init', arguments);

    this._createEventListeners();
  };

  this._sendEvent = function (eventName, data) {
    data = data || {};
    if (NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent) {
      NATIVE.plugins.sendEvent(
        'SponsorPayPlugin', eventName, JSON.stringify(data));
    } else {
      logger.log('{sponsorPay} Could not deliver event to native');
    }
  };

  this._createEventListeners = function () {
    for (var i = 0; i < events.length; i++) {
      NATIVE.events.registerHandler(events[i], bind(this, function (eventName) {
        logger.log('{sponsorPay} ' + eventName);
        this.emit(eventName);
      }, events[i]));
    }
  };

  /* sponsorpay */
  this.initializeSponsorPay = function (opts) {
    this._sendEvent('initializeSponsorPay', opts);
  };

  /* interstitial */
  // this.showInterstitial = function () {
  //   this._sendEvent('showInterstitial');
  // };

  /* video */
  this.cacheVideo = function () {
    this._sendEvent('checkVideoAvailable');
  };

  this.showVideo = function () {
    this._sendEvent('showVideo');
  };

});

exports = new SponsorPay;
