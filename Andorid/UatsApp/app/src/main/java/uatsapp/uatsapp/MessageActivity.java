package uatsapp.uatsapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import uatsapp.uatsapp.Adapters.HistoryAdapter;
import uatsapp.uatsapp.Utils.SendMessage;
import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.MessageHistory;
import uatsapp.uatsapp.data.data.MessageHistoryResponse;
import uatsapp.uatsapp.data.data.RegisterResponse;


public class MessageActivity extends Activity {
String currentUser = AppPreferences.getStringPreferences("USERNAME");
List<MessageHistory> messageList;
ListView lv_history;
EditText et_message;
TextView tv_friend;
WebSocketClient mWebSocketClient;
Button btn_send;
String MessageData;
int relation_id;
private HistoryAdapter adapter;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_messages);

        connectWebSocket();

        adapter = new HistoryAdapter(this, R.layout.item_note_list_entry, new ArrayList<MessageHistory>());
        lv_history = (ListView) findViewById(R.id.lv_history);
        lv_history.setAdapter(adapter);
//
        et_message = (EditText) findViewById(R.id.et_message);

        tv_friend = (TextView)findViewById(R.id.tv_friend);
        tv_friend.setText(AppPreferences.getStringPreferences("friendUser"));
//
        btn_send = (Button) findViewById(R.id.iv_new);
        btn_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!et_message.getText().toString().isEmpty())
                    sendMessage();
            }
        });
        ApiConnection.GetMessages(new IBaseCallback<MessageHistoryResponse>() {
            @Override
            public void onResult(final MessageHistoryResponse result) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        messageList = result.getHistory();
                        relation_id = result.getRelation_id();

                        adapter.setDataSource(messageList);
                        adapter.notifyDataSetChanged();
                    }
                });
            }
        }, currentUser, AppPreferences.getIntPreferences("friendId"), new MessageHistoryResponse(), new TypeToken<MessageHistoryResponse>() {}.getType());
    }

    private void connectWebSocket() {
        URI uri;
        try {
            uri = new URI("ws://46.101.248.188:9300");
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }
       mWebSocketClient = new WebSocketClient(uri) {
            @Override
            public void onOpen(ServerHandshake serverHandshake) {
                Log.i("Websocket", "Opened");
            }



            @Override
            public void onMessage(String message) {
                Log.d("new message: ",message);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        ApiConnection.GetMessages(new IBaseCallback<MessageHistoryResponse>() {
                            @Override
                            public void onResult(final MessageHistoryResponse result) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        messageList = result.getHistory();
                                        adapter.setDataSource(messageList);
                                        adapter.notifyDataSetChanged();
                                    }
                                });
                            }
                        }, currentUser, AppPreferences.getIntPreferences("friendId"), new MessageHistoryResponse(), new TypeToken<MessageHistoryResponse>() {
                        }.getType());
                    }
                });
            }
            @Override
            public void onClose(int i, String s, boolean b) {
                Log.i("Websocket", "Closed " + s);
            }
            @Override
            public void onError(Exception e) {
                Log.i("Websocket", "Error " + e.getMessage());
            }
        };
        mWebSocketClient.connect();
    }

    public void sendMessage() {
        SendMessage sentMessage = new SendMessage();
        EditText editText = (EditText)findViewById(R.id.et_message);
        sentMessage.setMessage(editText.getText().toString());
        sentMessage.setReciever(AppPreferences.getIntPreferences("friendId"));
        sentMessage.setRelation_id(relation_id);
        sentMessage.setSenderID(AppPreferences.getIntPreferences("ID"));
        sentMessage.setUsename(AppPreferences.getStringPreferences("friendUser"));
        Gson gson = new Gson();
        MessageData = gson.toJson(sentMessage);
        Log.d("message: ", MessageData);
        mWebSocketClient.send(MessageData);    //reuse this after fixing the WebsocketNotConnectedError
        editText.setText("");

//        ApiConnection.sendMessage(new IBaseCallback<RegisterResponse>() {
//            @Override
//            public void onResult(final RegisterResponse result) {
//
//            }
//        }, sentMessage.getMessage(), sentMessage.getRelation_id(), sentMessage.getRelation_id(), new RegisterResponse(), new TypeToken<RegisterResponse>() {
//        }.getType());
        //to save message in database

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        mWebSocketClient.close();
        finish();
    }
}
