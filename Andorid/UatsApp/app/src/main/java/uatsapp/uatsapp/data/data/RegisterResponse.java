package uatsapp.uatsapp.data.data;

/**
 * Created by Sergiu on 7/7/2015.
 */
public class RegisterResponse extends BaseResponse {
    private int success;
    private String error_message;

    public String getError_message() {
        return error_message;
    }

    public void setError_message(String error_message) {
        this.error_message = error_message;
    }

    public boolean isSuccess() {
        if(success==1)
            return true;
        else
            return false;
    }
    public void setSuccess(int success) {
        this.success = success;
    }
}
