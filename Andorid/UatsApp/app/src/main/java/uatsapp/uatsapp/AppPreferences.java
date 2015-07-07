package uatsapp.uatsapp;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/**
 * Created by v.baicu on 20/05/15.
 */
public class AppPreferences {

    public static final String SERVER_URL = "serverUrl";
    public static final String FREQUENCY = "frequency";

    static Context ctx = CoreApplication.getInstance();

    public static void setPreferences(String key, boolean value) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.putBoolean(key, value);
        editor.commit();
    }

    public static void setPreferences(String key, String value) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.putString(key, value);
        editor.commit();
    }

    public static void setPreferences(String key, int value) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.putInt(key, value);
        editor.commit();
    }

    public static void setPreferences(String key, float value) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.putFloat(key, value);
        editor.commit();
    }

    public static void setPreferences(String key, long value) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.putLong(key, value);
        editor.commit();
    }

    public static String getStringPreferences(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getString(key, "");
    }

    public static String getStringPreferences(String key, String defval) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getString(key, defval);
    }

    public static boolean getBoolPreferences(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getBoolean(key, false);
    }

    public static boolean getBoolPreferences(String key, boolean defval) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getBoolean(key, defval);
    }

    public static int getIntPreferences(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getInt(key, 0);
    }

    public static int getIntPreferences(String key, int defval) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getInt(key, defval);
    }

    public static float getFloatPreferences(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getFloat(key, 0);
    }

    public static float getFloatPreferences(String key, float defval) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getFloat(key, defval);
    }

    public static long getLongPreferences(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getLong(key, 0);
    }

    public static long getLongPreferences(String key, long defval) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).getLong(key, defval);
    }

    public static void removePreferences(String key) {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.remove(key);
        editor.commit();
    }

    public static boolean contains(String key) {
        return PreferenceManager.getDefaultSharedPreferences(ctx).contains(key);
    }

    public static void removeAll() {
        final SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(ctx).edit();
        editor.clear();
        editor.commit();
    }
}
