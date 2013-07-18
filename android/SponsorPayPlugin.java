package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
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

import com.sponsorpay.sdk.android.SponsorPay;
import com.sponsorpay.sdk.android.publisher.SponsorPayPublisher;

public class SponsorPayPlugin implements IPlugin {
	private Activity _activity;
	private Context _ctx;
	private Intent _spi;

	public SponsorPayPlugin() {
	}

	public void onCreateApplication(Context applicationContext) {
		_ctx = applicationContext;
	}

	public void onCreate(Activity activity, Bundle savedInstanceState) {
		_activity = activity;

        PackageManager manager = activity.getPackageManager();
        String sponsorPayAppID = "", sponsorPaySecurityToken = "";
        try {
            Bundle meta = manager.getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA).metaData;
            if (meta != null) {
                sponsorPayAppID = meta.get("SPONSORPAY_APP_ID").toString();
                sponsorPaySecurityToken = meta.get("SPONSORPAY_SECURITY_TOKEN").toString();
            }

			logger.log("{sponsorPay} Initializing from manifest with sponsorPayAppID=", sponsorPayAppID);

			SponsorPay.start(sponsorPayAppID, null, sponsorPaySecurityToken, _ctx);

			_spi = SponsorPayPublisher.getIntentForOfferWallActivity(_ctx, true);
        } catch (Exception e) {
			logger.log("{sponsorPay} Exception:", e.getMessage().toString());
        }
	}

    public void showInterstitial(String json) {
        try {
            logger.log("{sponsorPay} Showing interstitial");

			_activity.startActivityForResult(_spi, SponsorPayPublisher.DEFAULT_OFFERWALL_REQUEST_CODE);
        } catch (Exception e) {
            logger.log("{sponsorPay} Failure while showing interstitial:", e.getMessage().toString());
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

	public void onActivityResult(Integer request, Integer result, Intent data) {
	}

	public boolean consumeOnBackPressed() {
		return true;
	}

	public void onBackPressed() {
	}
}

