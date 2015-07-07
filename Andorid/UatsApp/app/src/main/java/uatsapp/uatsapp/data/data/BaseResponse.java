package uatsapp.uatsapp.data.data;

/**
 * Created by v.baicu on 20/05/15.
 */
public class BaseResponse {
    private ErrorResponse error = null;

    public ErrorResponse getError() {
        return error;
    }

    public void setError(ErrorResponse error) {
        this.error = error;
    }
}
