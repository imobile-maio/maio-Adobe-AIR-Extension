package jp.maio.adobeair.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import jp.maio.adobeair.MaioExtension;

/**
 * Created by maio on 2017/05/30.
 */

public class MaioInitFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        MaioExtension.setExtensionContext(freContext);

        return null;
    }
}
