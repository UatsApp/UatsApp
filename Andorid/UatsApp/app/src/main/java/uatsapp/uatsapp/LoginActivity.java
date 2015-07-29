package uatsapp.uatsapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.google.gson.reflect.TypeToken;

import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.RegisterResponse;


public class LoginActivity extends Activity{
    EditText et;
    EditText et2;
    TextView tv;
    Button btn;

    TextView info;
    LoginButton loginButton;
    CallbackManager callbackManager;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FacebookSdk.sdkInitialize(getApplicationContext());
        callbackManager = CallbackManager.Factory.create();

        setContentView(R.layout.activity_main);
        info = (TextView)findViewById(R.id.info);
        loginButton = (LoginButton)findViewById(R.id.login_button);

        loginButton.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                info.setText(
                        "User ID: "
                                + loginResult.getAccessToken().getUserId()
                                + "\n" +
                                "Auth Token: "
                                + loginResult.getAccessToken().getToken()
                );

            }


            @Override
            public void onCancel() {
                info.setText("Login attempt canceled.");
            }

            @Override
            public void onError(FacebookException exception) {
                info.setText("Login attempt failed.");
            }

        });



        setContentView(R.layout.activity_main);
        et = (EditText) findViewById(R.id.editText);
        et2 = (EditText) findViewById(R.id.editText2);
        tv = (TextView)findViewById(R.id.textView2);
        tv.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent launchactivity = new Intent(LoginActivity.this, SingupActivity.class);
                startActivity(launchactivity);}
        });
        btn =(Button)findViewById(R.id.button);
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String username = String.valueOf(et.getText());
                String password = String.valueOf(et2.getText());
                String error = null;
                if (username.matches(""))
                    error = "Please enter your username";
                else
                if(password.matches(""))
                    error = "Please enter your password";
                if(!(error==null))
                    DialogHelper.showAlertDialog(LoginActivity.this, error);
                else
                {
                    ApiConnection.Login(new IBaseCallback<RegisterResponse>() {
                        @Override
                        public void onResult(final RegisterResponse result) {
                            if (result.isSuccess()) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Toast.makeText(LoginActivity.this, "You have logged in successfully", Toast.LENGTH_LONG).show();
                                        AppPreferences.setPreferences("USERNAME",et.getText().toString());
                                        Intent launchactivity = new Intent(LoginActivity.this,ListActivity.class);
                                        startActivity(launchactivity);
                                    }
                                });
                            } else {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        DialogHelper.showAlertDialog(LoginActivity.this, result.getError_message());
                                    }
                                });
                            }
                        }
                    }, username, password, new RegisterResponse(), new TypeToken<RegisterResponse>() {
                    }.getType());
                }
            }
        });

    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }



}
