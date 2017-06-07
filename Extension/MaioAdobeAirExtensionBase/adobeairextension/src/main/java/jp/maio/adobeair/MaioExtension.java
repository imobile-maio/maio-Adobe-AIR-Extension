package jp.maio.adobeair;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * Created by maio on 2017/05/29.
 */

public class MaioExtension implements FREExtension {

    private static FREContext extensionContext;

    public static FREContext getExtensionContext() { return extensionContext; }
    public static void setExtensionContext(FREContext context) {
        if(MaioExtension.extensionContext != null) return;
        MaioExtension.extensionContext = context;
    }

    @Override
    public void initialize() {}

    @Override
    public FREContext createContext(String s) { return new MaioExtensionContext(); }

    @Override
    public void dispose() {}
}
