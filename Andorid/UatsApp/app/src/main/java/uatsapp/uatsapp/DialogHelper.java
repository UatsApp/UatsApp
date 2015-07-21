package uatsapp.uatsapp;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

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

    /**
     * Created by Sergiu on 7/6/2015.
     */
    public static class RegisterData {
        protected String username;
        protected String password;
        protected String c_password;
        protected String email;

        public RegisterData(String username, String password, String c_password, String email){
            this.username=username;
            this.password=password;
            this.c_password=c_password;
            this.email=email;
        }
        public String getUsername(){return username;}
        public String getPassword(){return password;}
        public String getC_password(){return c_password;}
        public String getEmail(){return email;}

    }
}

