package uatsapp.uatsapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;

import uatsapp.uatsapp.Adapters.UsersAdapter;
import uatsapp.uatsapp.Utils.User;
import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.UsersListResponse;

/**
 * Created by Vlad on 20-Jul-15.
 */
public class ListActivity extends Activity {
//    DowloadWebPageTask asyncTask =new DowloadWebPageTask();
    private UsersAdapter adapter;
    ListView lv;
    String currentUser = AppPreferences.getStringPreferences("USERNAME");
    List<User> userList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list);


        adapter = new UsersAdapter(this, R.layout.item_note_list_entry, new ArrayList<User>());
        lv = (ListView)findViewById(R.id.listView);
        lv.setAdapter(adapter);

        ApiConnection.GetUsers(new IBaseCallback<UsersListResponse>() {
            @Override
            public void onResult(final UsersListResponse result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        userList = result.getUsers();
                        adapter.setDataSource(userList);
                        adapter.notifyDataSetChanged();
                    }
                });
            }
        }, new UsersListResponse(), new TypeToken<UsersListResponse>() {
        }.getType());

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                int friendId = userList.get(position).getId();
                String friendUser = userList.get(position).getUsername();
                for(User user:userList){
                    if(user.getUsername().equals(currentUser))
                        AppPreferences.setPreferences("ID", user.getId());
                        int identifier;
                }
                AppPreferences.setPreferences("friendId",friendId);
                AppPreferences.setPreferences("friendUser",friendUser);
                Intent launchactivity = new Intent(ListActivity.this,MessageActivity.class);
                startActivity(launchactivity);
            }
        });
    }

}
