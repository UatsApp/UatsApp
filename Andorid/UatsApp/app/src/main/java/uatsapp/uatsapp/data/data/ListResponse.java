package uatsapp.uatsapp.data.data;

import java.util.List;

/**
 * Created by v.baicu on 20/05/15.
 */
public class ListResponse extends BaseResponse {
    private List<WTSong> songs;

    public List<WTSong> getSongs() {
        return songs;
    }

    public void setSongs(List<WTSong> songs) {
        this.songs = songs;
    }
}
