package jp.maio.adobeair.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import jp.maio.adobeair.MaioExtension;
import jp.maio.sdk.android.FailNotificationReason;
import jp.maio.sdk.android.MaioAds;
import jp.maio.sdk.android.MaioAdsListener;

/**
 * Created by maio on 2017/05/29.
 */

public class MaioGeneralFunction implements FREFunction {
    @Override
    public FREObject call(final FREContext freContext, FREObject[] freObjects) {
        try {
            String functionName = freObjects[0].getAsString();

            switch (functionName) {
                case "getSdkVersion":
                    return FREObject.newObject(MaioAds.getSdkVersion());
                case "setAdTestMode":
                    MaioAds.setAdTestMode(freObjects[1].getAsBool());
                    break;
                case "start":
                    MaioAds.init(freContext.getActivity(), freObjects[1].getAsString(), new MaioAdsListener(){

                        private void sendCallback(String level, String code) {
                            FREContext context = MaioExtension.getExtensionContext();
                            // Context should never be null.
                            if(context == null) return;
                            context.dispatchStatusEventAsync(level, code);
                        }

                        @Override
                        public void onInitialized() {
                            sendCallback("onInitialized", "");
                        }

                        @Override
                        public void onChangedCanShow(String mediaId, boolean canShow) {
                            // MEMO: Boolean conversion in actionscript depends on whether the string is emply or not.
                            // i.e. "true"/"false" = true, ""/null = false
                            sendCallback("onChangedCanShow", canShow ? "true" : "");
                        }

                        @Override
                        public void onStartedAd(String zoneId) {
                            sendCallback("onStartAd", zoneId);
                        }

                        @Override
                        public void onFinishedAd(int playtime, boolean skipped, int duration, String zoneId) {
                            // TODO Replace "0" with the actual reward parameter when Android's implementation is done.
                            String[] params = {zoneId, String.valueOf(playtime), skipped ? "true" : "", "0"};

                            // Connect params with a colon
                            StringBuilder resultStringBuilder = new StringBuilder();
                            for (String param: params) {
                                resultStringBuilder.append(param);
                                resultStringBuilder.append(":");
                            }
                            String result = resultStringBuilder.toString();

                            sendCallback("onFinishedAd", result);
                        }

                        @Override
                        public void onClickedAd(String zoneId) {
                            sendCallback("onClickedAd", zoneId);
                        }

                        @Override
                        public void onFailed(FailNotificationReason reason, String zoneId) {
                            String failReason;
                            switch (reason) {
                                case AD_STOCK_OUT       :failReason = "AD_STOCK_OUT"; break;
                                case RESPONSE           :failReason = "RESPONSE"; break;
                                case NETWORK_NOT_READY  :failReason = "NETWORK_NOT_READY"; break;
                                case NETWORK            :failReason = "NETWORK"; break;
                                case VIDEO              :failReason = "VIDEO"; break;

                                case UNKNOWN:
                                default:
                                    failReason = "UNKNOWN"; break;
                            }

                            sendCallback("onFailed", zoneId + ":" + failReason);
                        }
                    });
                    break;
                case "canShow":
                    if (freObjects.length > 1) {
                        return FREObject.newObject(MaioAds.canShow(freObjects[1].getAsString()));
                    } else {
                        return FREObject.newObject(MaioAds.canShow());
                    }
                case "show":
                    if (freObjects.length > 1) {
                        MaioAds.show(freObjects[1].getAsString());
                    } else {
                        MaioAds.show();
                    }
                default:
                    Log.d("MaioExtensionJava", "undefined function: " + functionName);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
