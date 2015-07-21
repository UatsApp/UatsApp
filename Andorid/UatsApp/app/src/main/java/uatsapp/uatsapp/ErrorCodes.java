package uatsapp.uatsapp;

/**
 * Created by v.baicu on 20/05/15.
 */
public class ErrorCodes {
    public static final int E_SUCCESS = 0;

    /*
     * Server error codes
     */
    public final static int E_SERVER_REQUEST_OK = 0;
    public static final int E_SRV_GENERIC = 100;
    public static final int E_SRV_INVALID_PARAM = 101;
    public final static int E_SRV_NO_ASSOC = 102;
    public final static int E_SRV_INVALID_MACHINEID = 103;
    public final static int E_SRV_MACHINE_NOT_FOUND = 104;
    public final static int E_SRV_INVALID_PHONEID = 105;
    public final static int E_SRV_INVALID_QR = 106;
    public final static int E_SRV_INVALID_REQUESTLOGIN = 107;
    public final static int E_SRV_INVALID_ERROR_CODE = 108;

    public final static int E_SRV_EMAIL_ACTIVATION_FAILED = 109;
    public final static int E_SRV_INVALID_SERVER_REQUEST = 110;
    public final static int E_SRV_SESSION_STATE_ERROR = 111;
    public final static int E_SRV_INVALID_QR_CODE = 112;
    public final static int E_SRV_EMAIL_INVITATION_FAILED = 113;
    public final static int E_SRV_REGISTRATION_FAILED = 114;
    public final static int E_SRV_SITE_SHARING_FAILED = 115;
    public final static int E_SRV_SESSION_UNAUTHORIZED_INITIATOR = 116;
    public final static int E_SRV_SESSION_UPDATE_FAILED = 117;
    public final static int E_SRV_DEVICE_NOT_FOUND = 118;
    public final static int E_SRV_SITE_UNAUTHORIZED_OWNER = 119;
    public final static int E_SRV_SITE_NOT_FOUND = 120;
    public final static int E_SRV_SESSION_CLOSED_UNEXPECTEDLY = 121;
    public final static int E_SRV_DEVICE_UNAUTHORIZED_OPERATION = 122;
    public final static int E_SRV_DEVICE_ALREADY_ACTIVATED = 123;
    public final static int E_SRV_SMS_SERVICE_ERROR = 124;

    public final static int E_SRV_PHONE_COMMUNICATION_ERROR = 300;

    public final static int E_SRV_IDENTITIY_GENERIC_ERROR = 700;
    public final static int E_SRV_IDENTITIY_INCONSISTENT_DB = 701;
    public final static int E_SRV_IDENTITIY_ACCOUNT_ERROR = 702;
    public final static int E_SRV_IDENTITIY_DEVICE_NOT_FOUND = 703;
    public final static int E_SRV_IDENTITIY_EMAIL_ACTIVATION_FAILURE = 704;
    public final static int E_SRV_IDENTITIY_INVALID_ARGUMENTS = 705;
    public final static int E_SRV_IDENTITIY_ACCOUNT_INACTIVE = 706;
    public final static int E_SRV_IDENTITIY_GET_SESSION = 707;
    public final static int E_SRV_IDENTITIY_DEVICE_INACTIVE = 708;

    public final static int E_SRV_GENERIC_SUBSCRIPTION_ERROR = 800;
    public final static int E_SRV_SUBSCRIPTION_NOT_LICENSED = 801;
    public final static int E_SRV_SUBSCRIPTION_NOT_AVAILABLE = 802;
    public final static int E_SRV_SUBSCRIPTION_EXPIRED = 803;
    public final static int E_SRV_MAXIMUM_DEVICES_REACHED = 804;
    public final static int E_SRV_MAXIMUM_SITES_REACHED = 805;
    public final static int E_SRV_SITE_INACTIVE = 806;

    /*
     * Client error codes
     */
    public static final int E_CLI_CONNECTION = -1;
    public static final int E_CLI_PARSE_RESPONSE = -2;
    public static final int E_CLI_GCM_REGISTER = -3;
    public static final int E_CLI_NO_PHONESITE = -4;
    public static final int E_CLI_NO_MACHINE = -5;
    public static final int E_CLI_SITE_NO_CREDENTIAL = -6;

    public static final int E_CLI_SSL_CONTEXT = -7;
    public static final int E_CLI_NO_DATA = -8;
    public static final int E_CLI_NO_DEF_SITES = -9;
    public static final int E_CLI_ADD_SITE = -10;
    public final static int E_CLI_UNASSOC = -16;

    public static final int E_CLI_GENERIC = -13;

    public final static int E_DB_INSERT = -11;
    public final static int E_DB_GENERIC = -12;
    public final static int E_DB_DELETE = -14;
    public final static int E_DB_READ = -15;
    public final static int E_DB_UPDATE = -17;


    /*
     * Network Connection Errors
     */
    public final static int E_NET_CONNECTED_VIA_WIFI = 1000;
    public final static int E_NET_CONNECTED_VIA_CELLULAR = 1001;
    public final static int E_NET_NOT_CONNECTED_WIFI_ON = 1002;
    public final static int E_NET_NOT_CONNECTED_WIFI_OFF = 1003;

}
