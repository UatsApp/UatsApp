package uatsapp.uatsapp.data.data;

import java.util.List;

/**
 * Created by Vlad on 22-Jul-15.
 */
public class MessageHistoryResponse extends BaseResponse {
    int relation_id;
    List<MessageHistory> history;
    public int getRelation_id() {return relation_id;}
    public void setRelation_id(int relation_id) {this.relation_id = relation_id;}
    public List<MessageHistory> getHistory() {return history;}
    public void setHistory(List<MessageHistory> users) {this.history = history;}
}
