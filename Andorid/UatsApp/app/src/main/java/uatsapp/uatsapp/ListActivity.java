package uatsapp.uatsapp;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
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
    ListView lv;
    String currentUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list);

        Bundle extras = getIntent().getExtras();
        currentUser = extras.getString("username");

        adapter = new UsersAdapter(this, R.layout.item_note_list_entry, new ArrayList<Users>());
        lv = (ListView)findViewById(R.id.listView);
        lv.setAdapter(adapter);

        asyncTask.execute(new String[]{"http://uatsapp.tk/accounts/get_users.php"});
        asyncTask.delegate = this;

    }
    public void processFinish(String output){
        Log.d("Caine123", output);

        Gson gson = new Gson();

        List<Users> userList = gson.fromJson(output,new TypeToken<List<Users>>(){}.getType());
        adapter.setDataSource(userList);
        adapter.notifyDataSetChanged();
        //sper ca macar o sa se inteleaga ce am vrut sa fac...
    }
}
