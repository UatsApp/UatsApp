package uatsapp.uatsapp.Utils;

/**
 * Created by Vlad on 23-Jul-15.
 */
public class SendMessage {
    public String getMessage() {return message;}
    public void setMessage(String message) {this.message = message;}
    public String getUsename() {return usename;}
    public void setUsename(String usename) {this.usename = usename;}
    public int getReciever() {return reciever;}
    public void setReciever(int reciever) {this.reciever = reciever;}
    public int getSenderID() {return senderID;}
    public void setSenderID(int senderID) {this.senderID = senderID;}
    public int getRelation_id() {return relation_id;}
    public void setRelation_id(int relation_id) {this.relation_id = relation_id;}

    private String message;
    private int relation_id;
    private int senderID;
    private int reciever;
    private String usename;
}
