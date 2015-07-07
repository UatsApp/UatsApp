package uatsapp.uatsapp.data.data;

/**
 * Created by v.baicu on 20/05/15.
 */
public class ErrorResponse {
    private String errorDescription;
    private int errorCode;

    public ErrorResponse(){}

    public ErrorResponse(int errorCode, String errorDescription){
        this.errorCode = errorCode;
        this.errorDescription = errorDescription;
    }

    public String getErrorDescription() {
        return errorDescription;
    }

    public void setErrorDescription(String errorDescription) {
        this.errorDescription = errorDescription;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public boolean succeded(){
        return errorCode == 0;
    }

    public static ErrorResponse getDefaultResponse() {
        return new ErrorResponse(-1, "invalid params");
    }
}
