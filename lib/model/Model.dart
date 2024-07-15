import 'dart:async';
import 'dart:convert';
import 'package:fakestore/model/managers/RestManager.dart';
import 'package:fakestore/model/objects/AuthenticationData.dart';
import 'package:fakestore/model/objects/Product.dart';
import 'package:fakestore/model/objects/User.dart';
import 'package:fakestore/model/support/Constants.dart';
import 'package:fakestore/model/support/LogInResult.dart';

import 'objects/Booking.dart';
import 'objects/Court.dart';
import 'objects/UserReq.dart';


class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  AuthenticationData? _authenticationData;
  bool logged = false;

  Future<LogInResult> logIn(String email, String password) async {
    try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type:TypeHeader.urlencoded);
      //print(result);
      //String result = await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_TOKEN,params,);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));

      if ( _authenticationData!.hasError() ) {
        print("ce un errore");
        if ( _authenticationData!.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData!.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      
       
      _restManager.token = _authenticationData!.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData!.expiresIn - 50)), (Timer t) {
        _refreshToken();
      });
      logged=true;
      return LogInResult.logged;
    }
    catch (e) {
      logged=false;
      print("Error during login: $e");
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      print("refresho");
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        logged=false;
        return false;
      }
      _restManager.token = _authenticationData!.accessToken;
      logged=true;
      return true;
    }
    catch (e) {
      logged=false;
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }


  Future<List<Product>?>? searchProduct(String name) async {
    Map<String, String> params = Map();
    params["name"] = name;
    try {
      return List<Product>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS, params)).map((i) => Product.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }



  Future<User?>? addUser(UserReq user) async {
    print("aggiungo");
    try {
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, user);
      if ( rawResult.contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        return null; // not the best solution
      }
      else {
        return User.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }




  Future<List<Court>?> searchCourtCity(String city,{required int numPage,required int dimPage,required String sortBy}) async {
    Map<String, String> params = Map();
    params["city"] = city;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_CITY,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }
  Future<List<Court>?> searchAllCourt({required int numPage,required int dimPage,required String sortBy}) async {
    Map<String, String> params = Map();
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_ALL,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }
  Future<List<Court>?> searchCourtType(String type,{required int numPage,required int dimPage,required String sortBy}) async {
    Map<String, String> params = Map();
    params["type"] = type;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_TYPE,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<Court>?> searchCourtTypeCity(String type,String city,{required int numPage,required int dimPage,required String sortBy}) async {
    Map<String, String> params = Map();
    params["type"] = type;
    params["city"] = city;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_CITY_TYPE,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }


  Future<User?> getUtente() async {
    try {
      String r = await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_USER);
      //print("stampa fatta da getUtent: "+ r);
      //if(User.fromJson(jsonDecode(r))==null)
      //  print("sto resitutendo null");
      return User.fromJson(jsonDecode(r));
      //return User.fromJson(jsonDecode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_USER)));
    }
    catch (e) {
      return null; // not the best solution
    }
  }


  Future<String?>? addBooking(String dataDaPrenotare, Court court) async {
    Booking booking = Booking(
      data: dataDaPrenotare,
      purchaseTime: DateTime.now(),
      court: court
    );

    String bookingJson = booking.toString();
    //Map<String, dynamic> bookingJson = booking.toJson();
    //print("Booking JSON: $bookingJson");
    String result = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_BOOK_COURT, json.decode(bookingJson));
    print(result);
    return result;
  }













  /*
  //BUONA
  Future<String?> addBooking(String dataDaPrenotare, Court court) async {
    try {
      // Fai la richiesta GET per ottenere l'utente
      String r = await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_USER);
      print("Response from server: $r");

      Map<String, dynamic> userJson = jsonDecode(r);
      //print("Decoded JSON: $userJson");

      User u = User.fromJson(userJson);
      //print("Utente ottenuto: ${u.userName}");

      DateTime now = DateTime.now();
      double prezzo = court.priceHourly;

      Booking booking = Booking(
        id: null,
        data: dataDaPrenotare,
        purchaseTime: now,
        prezzo: prezzo,
        buyer: u,
        court: court,
      );
      //print("questa e la prenotazione");
      //print(booking);

      Map<String, dynamic> bookingJson = booking.toJson();
      //print("Booking JSON: $bookingJson");

      //print("provo a fare la post");
      String result = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_BOOK_COURT, bookingJson);
      //String result = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_BOOK_COURT, bookingJson);
      print("finito la post");
      print(result);
      return result;

    }
    catch(e){
      print("Errore durante la prenotazione: $e");
      return null;
    }
  }//addBooking

   */












  //chicco
/*
  Future<String?> addBooking(String dataDaPrenotare, Court court) async {

    User user= User(
        userName: "flesca@gmail.com",
        firstName: "sergio",
        lastName: "flesca",
        telephone: '35555',
        email: "flesca@gmail.com"
    );
    Booking booking = Booking(id: null,data: dataDaPrenotare,purchaseTime: DateTime.now(),prezzo: court.priceHourly,buyer: user,court: court);


    try {
      // Converti l'oggetto booking in JSON
      Map<String, dynamic> bookingJson = booking.toJson();
      print("Booking JSON: $bookingJson");

      print("provo a fare la post");
      String result =  await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_BOOK_COURT, bookingJson);
      print(result);
      return result;
    } catch (e) {
      print("Errore prenotazione: $e");
      return null;
    }
  }

 */















}
