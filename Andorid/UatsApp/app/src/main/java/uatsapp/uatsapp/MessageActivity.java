package uatsapp.uatsapp;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.reflect.TypeToken;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.json.JSONObject;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import uatsapp.uatsapp.Adapters.HistoryAdapter;
import uatsapp.uatsapp.Utils.SendMessage;
import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.MessageHistory;
import uatsapp.uatsapp.data.data.MessageHistoryResponse;

/**
 * Created by Vlad on 22-Jul-15.
 */
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
        tv_friend = (TextView) findViewById(R.id.tv_friend);
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
/*                        if (messageList.get(0).get_to() == AppPreferences.getIntPreferences("friendId"))
                            AppPreferences.setPreferences("ID", messageList.get(0).get_from());
                        else
                            AppPreferences.setPreferences("ID", messageList.get(0).get_to());
*/
                        relation_id = result.getRelation_id();
                        //messagelist contine toate mesajele
                        adapter.setDataSource(messageList);
                        adapter.notifyDataSetChanged();

                    }
                });
            }
        }, currentUser, AppPreferences.getIntPreferences("friendId"), new MessageHistoryResponse(), new TypeToken<MessageHistoryResponse>() {
        }.getType());


    }


    private void connectWebSocket() {
        URI uri;
        try {
            uri = new URI("ws://46.101.248.188:9400");
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }

        mWebSocketClient = new WebSocketClient(uri) {
            @Override
            public void onOpen(ServerHandshake serverHandshake) {
                try{
                    JSONObject temp = new JSONObject();
                    temp.put("type","handShake");
                    temp.put("senderID",AppPreferences.getIntPreferences("ID"));
                    Log.i("senderID", String.valueOf(AppPreferences.getIntPreferences("ID")));
                    mWebSocketClient.send(String.valueOf(temp));
                }catch (Exception e){
                    e.printStackTrace();
                }
                Log.i("Websocket", "Opened");
            }

            @Override
            public void onMessage(String s) {
                final String message = s;
                Log.i("test pula mea", s);
                try {

                    JSONObject temp = new JSONObject(message);
                    int rel = temp.getInt("relation_id");
                    int sender = temp.getInt("senderID");
                    String msg = temp.getString("message");
                    int receiver = temp.getInt("receiverID");
                    String user = temp.getString("sender_username");

                    MessageHistory newMsg = new MessageHistory();
                    newMsg.setMessage(msg);
                    newMsg.set_from(sender);
                    newMsg.setId_c(rel);
                    newMsg.setUsername(user);
                    newMsg.set_to(receiver);

                    messageList.add(newMsg);

                    adapter.setDataSource(messageList);
                    adapter.notifyDataSetChanged();


                  /*  ApiConnection.onMessages(new IBaseCallback<MessageHistoryResponse>() {
                        @Override
                        public void onResult(final MessageHistoryResponse result) {
                            runOnUiThread(new Runnable() {
                                //@Override
                                public void run() {
                                    try {
                                        String sender_username = result.getSender_username();
                                        TextView textView = (TextView) findViewById(R.id.et_message);
                                        textView.setText(textView.getText() + "\n");
                                        if (relation_id == temp.getInt("relation_id")) {
                                            MessageHistory newMsg = new MessageHistory();
                                            newMsg.setMessage(temp.getString("message"));
                                            newMsg.set_from(Integer.parseInt(temp.getString("senderID")));
                                            newMsg.setId_c(Integer.parseInt(temp.getString("relation_id")));
                                            messageList.add(newMsg);

                                            adapter.setDataSource(messageList);
                                            adapter.notifyDataSetChanged();
                                        }

                                        if (relation_id != temp.getInt("relation_id")) {
                                            Toast.makeText(MessageActivity.this, "You received a new message from:" + sender_username, Toast.LENGTH_LONG).show();
                                        }


                                    } catch (Exception e) {
                                        e.printStackTrace();

                                    }

                                }
                            });
                        }
                    }, msg, rel, sender, new MessageHistoryResponse(), new TypeToken<MessageHistoryResponse>() {
                    }.getType());
                */
                } catch (Exception e) {

                    e.printStackTrace();
                }
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

        EditText editText = (EditText) findViewById(R.id.et_message);
        final String message = editText.getText().toString();
        ApiConnection.sentMessages(new IBaseCallback<MessageHistoryResponse>() {
            @Override
            public void onResult(final MessageHistoryResponse result) {
                runOnUiThread(new Runnable() {
                    //@Override
                    public void run() {
                        try {

                            SendMessage sentMessage = new SendMessage();
                            EditText editText = (EditText) findViewById(R.id.et_message);
                            sentMessage.setMessage((String) message);
                            sentMessage.setReceiverID(AppPreferences.getIntPreferences("friendId"));
                            sentMessage.setRelation_id(relation_id);
                            sentMessage.setSenderID(AppPreferences.getIntPreferences("ID"));
                            sentMessage.setSender_username(AppPreferences.getStringPreferences("friendUser"));
                            editText.setText("");
//                            Gson gson = new Gson();
//                            MessageData = gson.toJson(sentMessage);
//                            mWebSocketClient.send(MessageData);   // reuse this after fixing the WebsocketNotConnectedError
//                            editText.setText("");


                            messageList.add(sentMessage);

                            adapter.setDataSource(messageList);
                            adapter.notifyDataSetChanged();


                        } catch (Exception e) {
                            e.printStackTrace();

                        }

                    }
                });
            }
        },message , relation_id, AppPreferences.getIntPreferences("ID"),AppPreferences.getIntPreferences("friendId"),AppPreferences.getStringPreferences("friendUser"),new MessageHistoryResponse(), new TypeToken<MessageHistoryResponse>() {
        }.getType());

/*        SendMessage sentMessage = new SendMessage();
        EditText editText = (EditText) findViewById(R.id.et_message);
        sentMessage.setMessage(editText.getText().toString());
//        sentMessage.setReciever(AppPreferences.getIntPreferences("friendId"));
        sentMessage.setRelation_id(relation_id);
        sentMessage.setSenderID(AppPreferences.getIntPreferences("ID"));
//        sentMessage.setUsename(AppPreferences.getStringPreferences("friendUser"));
        Gson gson = new Gson();
        MessageData = gson.toJson(sentMessage);
        mWebSocketClient.send(MessageData);   // reuse this after fixing the WebsocketNotConnectedError
        editText.setText("");
*/
    }
}


