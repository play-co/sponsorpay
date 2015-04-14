package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
import com.tealeaf.EventQueue;

import java.io.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

import com.sponsorpay.SponsorPay;
import com.sponsorpay.publisher.SponsorPayPublisher;
import com.sponsorpay.utils.SponsorPayLogger;
// import com.sponsorpay.publisher.interstitial.SPInterstitialAdCloseReason;
// import com.sponsorpay.publisher.interstitial.SPInterstitialActivity;
// import com.sponsorpay.publisher.interstitial.SPInterstitialRequestListener;

import com.sponsorpay.publisher.mbe.SPBrandEngageRequestListener;
import com.sponsorpay.publisher.mbe.SPBrandEngageClient;


public class SponsorPayPlugin implements
	IPlugin,
	// SPInterstitialRequestListener,
	SPBrandEngageRequestListener {

	private Activity _activity;
	private Context _ctx;

	private boolean _debug = false;
	private String sponsorPayAppID = "";
	private String sponsorPaySecurityToken = "";
	private String rewardText = null;

	// private Intent _interstitialIntent = null;
	// int INTERSTITIAL_REQUEST_CODE = 999;

	private Intent _videoIntent = null;
	boolean videoAdAvailable = false;
	int VIDEO_REQUEST_CODE = 998;

	class InitializedEvent extends com.tealeaf.event.Event {
		public InitializedEvent() {
			super("Initialized");
		}
	}

	// class InterstitialAvailableEvent extends com.tealeaf.event.Event {
	// 	public InterstitialAvailableEvent() {
	// 		super("InterstitialAvailable");
	// 	}
	// }

	// class InterstitialNotAvailableEvent extends com.tealeaf.event.Event {
	// 	public InterstitialNotAvailableEvent() {
	// 		super("InterstitialNotAvailable");
	// 	}
	// }

	// class InterstitialErrorEvent extends com.tealeaf.event.Event {
	// 	String errorMessage;
	// 	public InterstitialErrorEvent(String errorMessage) {
	// 		super("InterstitialError");
	// 		this.errorMessage = errorMessage;
	// 	}
	// }

	// class InterstitialCompletedEvent extends com.tealeaf.event.Event {
	// 	boolean success;
	// 	public InterstitialCompletedEvent(boolean success) {
	// 		super("InterstitialCompleted");
	// 		this.success = success;
	// 	}
	// }

	class VideoAvailableEvent extends com.tealeaf.event.Event {
		public VideoAvailableEvent() {
			super("VideoAvailable");
		}
	}

	class VideoNotAvailableEvent extends com.tealeaf.event.Event {
		public VideoNotAvailableEvent() {
			super("VideoNotAvailable");
		}
	}

	class VideoErrorEvent extends com.tealeaf.event.Event {
		String errorMessage;
		public VideoErrorEvent(String errorMessage) {
			super("VideoError");
			this.errorMessage = errorMessage;
		}
	}

	class VideoCompletedEvent extends com.tealeaf.event.Event {
		boolean success;
		public VideoCompletedEvent(boolean success) {
			super("VideoCompleted");
			this.success = success;
		}
	}


	public SponsorPayPlugin() {
	}

	public void onCreateApplication(Context applicationContext) {
		_ctx = applicationContext;
	}

	public void onCreate(Activity activity, Bundle savedInstanceState) {
		_activity = activity;
		PackageManager manager = activity.getPackageManager();
		try {
			Bundle meta = manager.getApplicationInfo(
					activity.getPackageName(),
					PackageManager.GET_META_DATA
				).metaData;
			if (meta != null) {
				sponsorPayAppID = meta.get("SPONSORPAY_APP_ID").toString();
				sponsorPaySecurityToken =
					meta.get("SPONSORPAY_SECURITY_TOKEN").toString();
			}

		} catch (Exception e) {
			logger.log("{sponsorPay} Exception:", e.getMessage().toString());
		}
	}

	public void initializeSponsorPay(String jsonData) {
		String userId = null;
		try {
			JSONObject jsonObject = new JSONObject(jsonData);
			userId = jsonObject.optString("userId", null);
			logger.log("{sponsorPay} Initializing with userId:", userId);
			_debug = jsonObject.optBoolean("debug", false);
		} catch (Exception e) {
			logger.log("{sponsorPay} exception reading event options", jsonData);
		}

		if (_debug) {
			logger.log("{sponsorPay} Enabling debug logging for sponsorPay SDK");
			com.sponsorpay.utils.SponsorPayLogger.enableLogging(true);
		}

		logger.log("{sponsorPay} Initializing with sponsorPayAppID:", sponsorPayAppID);
		SponsorPay.start(sponsorPayAppID, userId, sponsorPaySecurityToken, _activity);

		// SponsorPayPublisher.getIntentForInterstitialActivity(_activity, this);

		// TODO: make this configurable
		logger.log("{sponsorPay} Disabling sponsorPay toast messages");
		// SPBrandEngageClient.INSTANCE.setShowRewardsNotification(false);
		//SponsorPayPublisher.setCustomUIString(
			//UIStringIdentifier.MBE_REWARD_NOTIFICATION, "NEW_TEXT_HERE")

		logger.log("{sponsorPay} Initialized");
		EventQueue.pushEvent(new InitializedEvent());
	};

	// public void showInterstitial(String json) {
	// 	if (_interstitialIntent != null) {
	// 		logger.log("{sponsorPay} Showing interstitial (native)");
	// 		try {
	// 			_activity.startActivityForResult(_interstitialIntent, INTERSTITIAL_REQUEST_CODE);
	// 		} catch (Exception e) {
	// 			logger.log(
	// 					"{sponsorPay} Failure while showing interstitial:",
	// 					e.getMessage().toString()
	// 				);
	// 		}
	// 	} else {
	// 		logger.log("{sponsorPay} Interstitial requested but none available");
	// 	}
	// }

	// @Override
	// public void onSPInterstitialAdAvailable (Intent interstitialActivity) {
	// 	logger.log("{sponsorPay} Interstitial Available");
	// 	_interstitialIntent = interstitialActivity;
	// 	// tell javascript that an interstitial is available
	// 	EventQueue.pushEvent(new InterstitialAvailableEvent());
	// }

	// @Override
	// public void onSPInterstitialAdNotAvailable () {
	// 	logger.log("{sponsorPay} Interstitial Not Available");
	// 	_interstitialIntent = null;
	// 	// tell javascript that an interstitial is not available
	// 	EventQueue.pushEvent(new InterstitialNotAvailableEvent());
	// }

	// @Override
	// public void onSPInterstitialAdError (String errorMessage) {
	// 	logger.log("{sponsorPay} Interstitial Ad Error", errorMessage);
	// 	_interstitialIntent = null;
	// 	// tell javascript that an interstitial error occurred
	// 	EventQueue.pushEvent(new InterstitialErrorEvent(errorMessage));
	// }


	// SPBrandEngageRequestListener interface implementation
	public void checkVideoAvailable (String jsonString) {
		final Activity devkitActivity = _activity;
		final SPBrandEngageRequestListener listener = this;
		devkitActivity.runOnUiThread(new Runnable() {
			public void run() {
				SponsorPayPublisher.getIntentForMBEActivity(devkitActivity, listener);
			}
		});
	}

	public void showVideo(String json) {
		if (_videoIntent != null && videoAdAvailable) {
			logger.log("{sponsorPay} Showing video (native)");
			videoAdAvailable = false;
			try {
				_activity.startActivityForResult(_videoIntent, VIDEO_REQUEST_CODE);
				_videoIntent = null;
			} catch (Exception e) {
				logger.log(
						"{sponsorPay} Failure while showing video:",
						e.getMessage().toString()
					);
				EventQueue.pushEvent(
					new VideoErrorEvent(e.getMessage().toString())
				);
			}
		} else {
			logger.log("{sponsorPay} Video requested but none available");
			EventQueue.pushEvent(new VideoErrorEvent("No Video Available"));
		}
	}

	@Override
	public void onSPBrandEngageOffersAvailable(Intent spBrandEngageActivity) {
		logger.log("{sponsorPay} SPBrandEngage - intent available");
		_videoIntent = spBrandEngageActivity;
		videoAdAvailable = true;
		EventQueue.pushEvent(new VideoAvailableEvent());
	}

	@Override
	public void onSPBrandEngageOffersNotAvailable() {
		logger.log("{sponsorPay} SPBrandEngage - no offers for the moment");
		_videoIntent = null;
		videoAdAvailable = false;
		EventQueue.pushEvent(new VideoNotAvailableEvent());
	}

	@Override
	public void onSPBrandEngageError(String errorMessage) {
		logger.log("{sponsorPay} SPBrandEngage - an error occurred:\n" + errorMessage);
		_videoIntent = null;
		videoAdAvailable = false;
		EventQueue.pushEvent(new VideoErrorEvent(errorMessage));
	}

	public void onActivityResult(Integer requestCode, Integer resultCode, Intent data) {
		// if (resultCode == _activity.RESULT_OK && requestCode == INTERSTITIAL_REQUEST_CODE) {
		// 	SPInterstitialAdCloseReason adStatus =
		// 		(SPInterstitialAdCloseReason) data.getSerializableExtra(SPInterstitialActivity.SP_AD_STATUS);
		// 	logger.log("{sponsorPay} Interstitial ad closed with status", adStatus);
		// 	if (adStatus.equals(SPInterstitialAdCloseReason.ReasonError)) {
		// 		String error = data.getStringExtra(SPInterstitialActivity.SP_ERROR_MESSAGE);
		// 		logger.log("SPInterstitial closed and error - " + error);
		// 		EventQueue.pushEvent(new InterstitialCompletedEvent(false));
		// 	} else {
		// 		EventQueue.pushEvent(new InterstitialCompletedEvent(true));
		// 	}
		// }
		if (resultCode == _activity.RESULT_OK &&
				requestCode == VIDEO_REQUEST_CODE) {
			String engagementResult = data.getStringExtra(SPBrandEngageClient.SP_ENGAGEMENT_STATUS);
			if (engagementResult == SPBrandEngageClient.SP_REQUEST_STATUS_PARAMETER_FINISHED_VALUE) {
				logger.log("{sponsorPay} Video ad completed");
				EventQueue.pushEvent(new VideoCompletedEvent(true));
			} else if (engagementResult == SPBrandEngageClient.SP_REQUEST_STATUS_PARAMETER_ERROR) {
				logger.log("{sponsorPay} Video ad error");
				EventQueue.pushEvent(new VideoCompletedEvent(false));
			} else {
				logger.log("{sponsorPay} Unknown video result code", engagementResult);
				EventQueue.pushEvent(new VideoCompletedEvent(false));
			}
		}
	}

	public void onResume() {
	}

	public void onStart() {
	}

	public void onPause() {
	}

	public void onStop() {
	}

	public void onDestroy() {
	}

	public void onNewIntent(Intent intent) {
	}

	public void setInstallReferrer(String referrer) {
	}

	public boolean consumeOnBackPressed() {
		return true;
	}

	public void onBackPressed() {
	}
}

