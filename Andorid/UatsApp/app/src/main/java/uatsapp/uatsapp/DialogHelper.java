package uatsapp.uatsapp;

import android.app.AlertDialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;

/**
 * Created by Sergiu on 7/2/2015.
 */
public class DialogHelper {

    public static void showAlertDialog(Context context, String error) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
// Add the buttons
        builder.setPositiveButton("ok", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                }

        );

        AlertDialog dialog = builder.create();
        dialog.setMessage(error);
        dialog.show();
    }
}

