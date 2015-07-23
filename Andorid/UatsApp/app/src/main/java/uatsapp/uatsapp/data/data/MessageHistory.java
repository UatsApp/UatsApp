package uatsapp.uatsapp.data.data;

/**
 * Created by Vlad on 22-Jul-15.
 */
public class MessageHistory {
    private int id;
    private int id_c;
    private int _from;
    private int _to;
    private String message;
    private String _time;

    public int getId() {return id;}
    public void setId(int id) {this.id = id;}
    public int getId_c() {return id_c;}
    public void setId_c(int id_c) {this.id_c = id_c;}
    public int get_from() {return _from;}
    public void set_from(int _from) {this._from = _from;}
    public int get_to() {return _to;}
    public void set_to(int _to) {this._to = _to;}
    public String getMessage() {return message;}
    public void setMessage(String message) {this.message = message;}
    public String get_time() {return _time;}
    public void set_time(String _time) {this._time = _time;}
}
