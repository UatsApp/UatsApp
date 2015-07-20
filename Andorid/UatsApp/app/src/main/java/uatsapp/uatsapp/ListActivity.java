package uatsapp.uatsapp;

import android.app.Activity;
import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.List;

import uatsapp.uatsapp.Adapters.UsersAdapter;
import uatsapp.uatsapp.Utils.AsyncResponse;
import uatsapp.uatsapp.Utils.DowloadWebPageTask;
import uatsapp.uatsapp.Utils.Users;

/**
 * Created by Vlad on 20-Jul-15.
 */
public class ListActivity extends Activity implements AsyncResponse {
    DowloadWebPageTask asyncTask =new DowloadWebPageTask();
    private UsersAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list);

        asyncTask.execute(new String[]{"http://uatsapp.tk/accounts/get_users.php"});
        asyncTask.delegate = this;


    }
    public void processFinish(String output){
        //convert output to json and show it using list adapter
     //   Log.d("Caine123",output);

        Gson gson = new Gson();

        List<Users> userList = gson.fromJson(output,new TypeToken<List<Users>>(){}.getType());
        adapter.setDataSource(userList);
        adapter.notifyDataSetChanged();
        //sper ca macar o sa se inteleaga ce am vrut sa fac...
    }
}
