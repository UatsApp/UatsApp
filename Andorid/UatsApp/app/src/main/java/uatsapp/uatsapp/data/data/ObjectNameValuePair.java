package uatsapp.uatsapp.data.data;

/**
 * Created by v.baicu on 20/05/15.
 */
public class ObjectNameValuePair {
    protected String name;
    protected Object value;


    public ObjectNameValuePair(String name, Object value) {
        this.name = name;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public Object getValue() {
        return value;
    }

}
