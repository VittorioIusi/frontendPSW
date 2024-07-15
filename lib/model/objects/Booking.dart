import 'dart:convert';

import 'package:fakestore/model/objects/Court.dart';
import 'package:fakestore/model/objects/User.dart';

import 'Court.dart';
import 'User.dart';

class Booking{
  int ?id;
  String data;//ora-data che si vuole prenotare il campetto
  DateTime purchaseTime;
  double? prezzo;
  User? buyer;
  Court court;

  // rimettilo poi
  Booking({this.id, required this.data, required this.purchaseTime,  this.prezzo,  this.buyer,
    required this.court});

  factory Booking.fromJson(Map<String, dynamic> json) {
    DateTime dateTime;
    var milliSeconds = json['purchaseTime'];
    if (milliSeconds != null) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(milliSeconds);
    } else {
      dateTime = DateTime.now(); // fallback in caso di valore nullo
    }
    return Booking(
      id: json['id'],
      data: json['data'],
      purchaseTime: dateTime,
      prezzo: json['prezzo'],
      buyer: User.fromJson(json['buyer']),
      court: Court.fromJson(json['court']),
    );
  }

  Map<String,dynamic> toJson() =>{
    'id': id,
    'data':data,
    'purchaseTime':purchaseTime,
    'prezzo':prezzo,
    'buyer':buyer,
    'court':court,
  };

  @override
  String toString() {
    return jsonEncode({
      'data': data,
      'prezzo': prezzo,
      'purchaseTime': purchaseTime.toIso8601String(),
      'buyer': {
        'id': buyer?.id,
      },
      'court': {
        'id': court.id,
      },
    });
  }
}