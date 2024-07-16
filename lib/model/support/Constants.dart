class Constants {


  static final String APP_VERSION = "0.0.1";
  static final String APP_NAME = "Bookball";

  // addresses
  static final String ADDRESS_STORE_SERVER = "localhost:8081";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8080";

  // authentication
  static final String REALM = "myrealm";
  static final String CLIENT_ID = "myclient";
  static final String CLIENT_SECRET = "u5kadDfKitzeDg8yux824bRa9tvvvlWW";
  static final String REQUEST_LOGIN = "/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/realms/" + REALM + "/protocol/openid-connect/logout";

  // requests
  static final String CHECK = "/check/simple";
  static final String REQUEST_SEARCH_COURT_CITY_TYPE = "/courts/byCityType";
  static final String REQUEST_SEARCH_COURT_CITY= "/courts/byCity";
  static final String REQUEST_SEARCH_COURT_TYPE= "/courts/byType";
  static final String REQUEST_SEARCH_COURT_ALL= "/courts/all";
  static final String REQUEST_BOOK_COURT= "/bookings/add";
  static final String REQUEST_TOKEN= "/users/token";


  static final String REQUEST_ADD_USER = "/users/add";
  static final String REQUEST_USER="/home/getUser";

  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "email gia in uso da un altro utente";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";


}