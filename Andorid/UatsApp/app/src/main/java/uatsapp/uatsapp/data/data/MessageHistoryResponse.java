package uatsapp.uatsapp.data.data;

import android.os.Message;

import java.util.List;

/**
 * Created by Vlad on 22-Jul-15.
 */
public class MessageHistoryResponse extends BaseResponse {
    int relation_id;
    int senderId;
    int receiverID;
    String sender_username;
    String message;

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public int getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(int receiverID) {
        this.receiverID = receiverID;
    }

    public String getSender_username() {
        return sender_username;
    }

    public void setSender_username(String sender_username) {
        this.sender_username = sender_username;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    List<MessageHistory> history;
    public int getRelation_id() {return relation_id;}
    public void setRelation_id(int relation_id) {this.relation_id = relation_id;}
    public List<MessageHistory> getHistory() {return history;}

    public void setHistory(List<MessageHistory> users) {this.history = history;}
}
