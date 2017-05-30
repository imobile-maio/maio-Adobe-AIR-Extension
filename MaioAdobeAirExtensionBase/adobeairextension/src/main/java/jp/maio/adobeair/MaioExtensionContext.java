package jp.maio.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

import jp.maio.adobeair.functions.MaioGeneralFunction;
import jp.maio.adobeair.functions.MaioInitFunction;

/**
 * Created by maio on 2017/05/29.
 */

public class MaioExtensionContext extends FREContext {

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functions = new HashMap<>();

        functions.put("generalFunction", new MaioGeneralFunction());
        functions.put("init", new MaioInitFunction());

        return functions;
    }

    @Override
    public void dispose() {}

}
