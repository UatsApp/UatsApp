package uatsapp.uatsapp.data.data;

/**
 * Created by v.baicu on 20/05/15.
 */
public class WTSong {
    private String name;
    private String length;

    public WTSong(String name,String length){
        this.name = name;
        this.length =length;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLength() {
        return length;
    }

    public void setLength(String length) {
        this.length = length;
    }
}
