package uatsapp.uatsapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.reflect.TypeToken;

import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.RegisterResponse;


public class SingupActivity extends Activity {
    TextView tv2;
    TextView tv;
    EditText et;
    EditText et2;
    EditText et3;
    EditText et4;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        tv2=(TextView)findViewById(R.id.textView);
        tv=(TextView)findViewById(R.id.textView3);
        et = (EditText) findViewById(R.id.editText6);
        et2 = (EditText) findViewById(R.id.editText4);
        et3 = (EditText) findViewById(R.id.editText5);
        et4 = (EditText) findViewById(R.id.editText3);
        tv.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                finish();
            }
        });
        Button btn = (Button)findViewById(R.id.button2);
        tv2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent launchactivity = new Intent(SingupActivity.this,LoginActivity.class);
                startActivity(launchactivity);
                setResult(Activity.RESULT_OK);
                finish();
            }

        });
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                doSignUp();
                }
            });
    }

    private void doSignUp() {
        String e_mail = String.valueOf(et.getText());
        String pass = String.valueOf(et2.getText());
        String c_pass = String.valueOf(et3.getText());
        String id = String.valueOf(et4.getText());
        String error = null;
        if(id.matches(""))
        error="Please enter your username";
        else if(pass.matches(""))
        error="Please enter your password";
        else if(c_pass.matches(""))
        error="Please confirm your password";
        else if(!passwordcheck(pass, c_pass))
        error="Please make sure your passwords match";
        else if(e_mail.matches(""))
        error="Please enter your e-mail";
        else if(!emailcheck(e_mail))
        error="Invalid Email";
        if(!(error==null))
        DialogHelper.showAlertDialog(SingupActivity.this, error);
        else
        {
            ApiConnection.Register(new IBaseCallback<RegisterResponse>() {
                @Override
                public void onResult(final RegisterResponse result) {
                    if(result.isSuccess()){
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Toast.makeText(SingupActivity.this, "Your account has been successfully registered", Toast.LENGTH_SHORT).show();
                                finish();
                            }
                        });

                    }
                    else {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                DialogHelper.showAlertDialog(SingupActivity.this, result.getError_message());
                            }
                        });
                    }
                }
            },id,pass,c_pass,e_mail,new RegisterResponse(),new TypeToken<RegisterResponse>(){}.getType());
        }
    }

    public boolean emailcheck(String s){
        if(s.contains("@"))
            return true;
        else
            return false;
    }
    public boolean passwordcheck(String pass, String c_pass){
        if(pass.equals(c_pass)){
            return true;
        }
        else
            return false;
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
}
