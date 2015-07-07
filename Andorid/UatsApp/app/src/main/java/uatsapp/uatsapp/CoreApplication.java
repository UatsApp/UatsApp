package uatsapp.uatsapp;

import android.app.Application;

/**
 * Created by Sergiu on 7/7/2015.
 */
public class CoreApplication extends Application {

    private static CoreApplication instance;

    public CoreApplication () {
        instance = this;
    }

    public static CoreApplication getInstance() {
        return instance;
    }
}
