package uatsapp.uatsapp;

import android.os.AsyncTask;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import uatsapp.uatsapp.Utils.StringHelper;
import uatsapp.uatsapp.data.data.BaseResponse;
import uatsapp.uatsapp.data.data.ErrorResponse;
import uatsapp.uatsapp.data.data.IBaseCallback;
import uatsapp.uatsapp.data.data.ObjectNameValuePair;

public class ApiConnection {
    private static final String CONTENT_TYPE = "Content-Type";
    private static final String POST = "POST";
    private static final int STATUS_CODE_OK = 200;

    public final static <T extends BaseResponse> void Register(final IBaseCallback callback,final String username,final String password, final String c_password,final String email,
                                                              final T responseToPopulate, final Type type) {
        ArrayList<ObjectNameValuePair> parameters = new ArrayList<ObjectNameValuePair>();
        parameters.add(new ObjectNameValuePair("username",username));
        parameters.add(new ObjectNameValuePair("password",password));
        parameters.add(new ObjectNameValuePair("c_password",c_password));
        parameters.add(new ObjectNameValuePair("email",email));
        performRequest("registerDEV/jsonsignup.php", "application/json", parameters, responseToPopulate, type, callback);

    }

    public final static <T extends BaseResponse> void Login(final IBaseCallback callback,final String username,final String password,
                                                               final T responseToPopulate, final Type type) {
        ArrayList<ObjectNameValuePair> parameters = new ArrayList<ObjectNameValuePair>();
        parameters.add(new ObjectNameValuePair("username",username));
        parameters.add(new ObjectNameValuePair("password",password));
        performRequest("registerDEV/jsonlogin1.php", "application/json", parameters, responseToPopulate, type, callback);

    }

//    public final static <T extends BaseResponse> void GetUsers(final IBaseCallback callback, final T responseToPopulate, final Type type) {
//        ArrayList<ObjectNameValuePair> parameters = new ArrayList<ObjectNameValuePair>();
//        performRequest("accounts/jsonlogin1.php", "application/json", parameters, responseToPopulate, type, callback);
//
//    }

    public static <T extends BaseResponse> void performRequest(final String operation, final String contentType, final ArrayList<ObjectNameValuePair> parameters,
                                                               final T responseToPopulate, final Type type, final IBaseCallback<T> callback) {
        try {
            AsyncTask<Void, Void, Void> execute = new AsyncTask<Void, Void, Void>() {
                @Override
                protected Void doInBackground(Void... params) {

                    T copy = responseToPopulate;
                    responseToPopulate.setError(ErrorResponse.getDefaultResponse());
                    String jsonContent = null;
                    try {
                        //retrieve the https connection
                        HttpURLConnection urlConnection = getURLConnection( operation, parameters, contentType);
                        if (urlConnection != null) {
                            // Perform request and get the result
                            InputStream responseStream;
                            int code = urlConnection.getResponseCode();
                            String message = urlConnection.getResponseMessage();

                            if (code == STATUS_CODE_OK) {
                                responseStream = urlConnection.getInputStream();
                                jsonContent = getJSONData(responseStream);
                                GsonBuilder gsonBuilder = new GsonBuilder();
                                Gson gson = gsonBuilder.create();

                                Log.d("response", "Response is:");
                                Log.d("response", jsonContent);
                                copy = gson.fromJson(jsonContent, type);
                                callback.onResult(copy);
                                return null;
                            }
                            else {
                                responseToPopulate.setError(new ErrorResponse(code, message));
                            }
                        }
                    }
                    catch (IOException ex) {
                        responseToPopulate.setError(new ErrorResponse(ErrorCodes.E_CLI_CONNECTION, null));
                        ex.printStackTrace();
                    }
                    catch (Exception ex) {
                        responseToPopulate.setError(new ErrorResponse(ErrorCodes.E_SRV_INVALID_PARAM, null));
                        ex.printStackTrace();
                    }
                    callback.onResult(responseToPopulate);
                    return null;
                }

                @Override
                protected void onPostExecute(Void res) {
                    if (responseToPopulate.getError().succeded() == false && operation.equals("GetDeviceStatus") == false && responseToPopulate.getError().getErrorCode() != -1) {
                    }
                }

            }.execute((Void[]) null);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static HttpURLConnection getURLConnection( String operation, ArrayList<ObjectNameValuePair> parameters, String contentType) {
        HttpURLConnection urlConnection = null;
        try {
            String apiUrlAddress = Constants.API_URL;
            if(!apiUrlAddress.endsWith("/"))
                apiUrlAddress = apiUrlAddress +"/";

            // Create URL request
            String request = apiUrlAddress + operation;




            URL urlRequest = new URL(request);
            urlConnection = (HttpURLConnection) urlRequest.openConnection();
            urlConnection.setConnectTimeout(5000);

            // Set the SSL context on HTTPS URL connection
//            if (certType == CertificateType.DEFAULT) {
//                urlConnection.setSSLSocketFactory(SSLConnection.getDefaultSSLContext());
//            }
//            else {
//                urlConnection.setSSLSocketFactory(SSLConnection.getClientSSLContext());
//            }
//

            if (StringHelper.isNullOrWhiteSpace(contentType) == false) {
                urlConnection.setRequestProperty(CONTENT_TYPE, contentType);
            }


            urlConnection.setDoOutput(true);
            urlConnection.setRequestMethod(POST);

            injectParameters(parameters, urlConnection, operation);

        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return urlConnection;
    }

    private static String getJSONData(InputStream responseStream) {

        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(responseStream));

            StringBuffer buffer = new StringBuffer();
            String inputLine = null;
            try {
                while ((inputLine = reader.readLine()) != null)
                    buffer.append(inputLine);
            }
            catch (IOException e) {
                e.printStackTrace();
            }

            String apiResponse = buffer.toString();
            return apiResponse;
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private static void injectParameters(ArrayList<ObjectNameValuePair> parameters, HttpURLConnection urlConnection, String operation) throws IOException {
        try {
            JSONObject jsonParam = new JSONObject();
            if (parameters != null && parameters.size() > 0) {
                for (ObjectNameValuePair param : parameters) {
                    try {
                        Object value = param.getValue();
                        if (value != null) {
                            jsonParam.put(param.getName(), param.getValue());
                        }
                    }
                    catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
                OutputStreamWriter out = new OutputStreamWriter(urlConnection.getOutputStream());
                Log.d("request","op:"+operation+ " :" + jsonParam.toString());

                out.write(jsonParam.toString());
                out.flush();
                out.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

}
