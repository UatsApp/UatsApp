package uatsapp.uatsapp.data.data;

/**
 * Created by v.baicu on 20/05/15.
 */
public class CurrentSongResponse extends BaseResponse {
    WTSong song;
    int progress;

    public WTSong getSong() {
        return song;
    }

    public void setSong(WTSong song) {
        this.song = song;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }
}
