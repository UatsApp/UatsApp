package uatsapp.uatsapp.Utils;

import java.net.URI;
import java.net.URL;

/**
 * Created by v.baicu on 20/05/15.
 */
public class StringHelper {
    public static boolean isNullOrWhiteSpace(String value){
        if (value != null && value.equals("") == false && value.equals("null") == false) {
            return false;
        }
        return true;
    }

    public static boolean isValidUrl(String sUrl){
        try{
            if(isNullOrWhiteSpace(sUrl))
                return false;
            URL url = new URL(sUrl);
            URI uri = url.toURI();
            return true;

        } catch (Exception ex){
            ex.printStackTrace();
            return false;
        }
    }
}
