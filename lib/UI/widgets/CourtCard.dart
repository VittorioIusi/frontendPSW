import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/Model.dart';
import '../../model/objects/Court.dart';
import 'buttons/CircularIconButton.dart';



import 'package:flutter/material.dart';

import '../../model/Model.dart';
import '../../model/objects/Court.dart';
import 'buttons/CircularIconButton.dart';

class CourtCard extends StatefulWidget {
  final Court court;

  CourtCard(this.court) : super();

  @override
  State<StatefulWidget> createState() => _CourtCardState();
}

class _CourtCardState extends State<CourtCard> {
  DateTime dateTime = DateTime.now();
  String bookingDateTime = '';

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 16,
              backgroundColor: Colors.blue,
              child: Column(
                children: [
                  SizedBox(height: 70, width: 500),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Seleziona Data'),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: dateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (newDate != null) {
                        setState(() {
                          dateTime = newDate;
                          updateBookingDateTime();
                        });
                      }
                    },
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    child: Text('Seleziona ora'),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(dateTime),
                      );
                      if (newTime != null) {
                        setState(() {
                          dateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            newTime.hour,
                          );
                          updateBookingDateTime();
                        });
                      }
                    },
                  ),
                  Text(
                    "Nome: ${widget.court.name}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    "Sport: ${widget.court.type}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    "Città: ${widget.court.city}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  CircularIconButton(
                    icon: Icons.shopping_basket_sharp,
                    onPressed: () {
                      if (Model.sharedInstance.logged) {
                        _acquisto();
                      } else {
                        final snackBar = SnackBar(
                          content: Text("Errore: Utente non loggato."),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  )
                ],
              ),
            );
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                widget.court.name,
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                widget.court.city,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateBookingDateTime() {
    bookingDateTime =
    "${dateTime.day.toString().padLeft(2, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.year.toString()}${dateTime.hour.toString().padLeft(2, '0')}";
    print("Updated bookingDateTime: $bookingDateTime");
  }



  void _acquisto()  {
    print("sono in acquisto");
    Model.sharedInstance.addBooking(bookingDateTime, widget.court)?.then((value) {
      print("verifico il risultato della post");
      print(value);
      if (value == "court is already booked") {
        final snackBar = SnackBar(
          content: Text("Errore: Campo già prenotato."),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text("Prenotazione effettuata."),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }


/*
  void _acquisto() async {
    try {
      print("sono in acquisto");
      String? value = await Model.sharedInstance.addBooking(bookingDateTime, widget.court);
      print("verifico il risultato della post");
      print(value);

      if (value == "court is already booked") {
        final snackBar = SnackBar(
          content: Text("Errore: Campo già prenotato."),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text("Prenotazione effettuata."),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print("Errore durante l'acquisto: $error");
      final snackBar = SnackBar(
        content: Text("Errore durante la prenotazione."),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

 */


}








//classe chicco
/*
class CourtCard extends StatefulWidget {
  final Court court;

  CourtCard(this.court) : super();

  @override
  State<StatefulWidget> createState() => _CourtCardState();
}

class _CourtCardState extends State<CourtCard> {

  DateTime dateTime = DateTime.now();

  String dataDaPrenotare="";

  @override
  Widget build(BuildContext context) {

    final hours = dateTime.hour.toString().padLeft(2,'0');
    return InkWell(
        onTap: (){
          showDialog(
              context: context,
              builder: (context){
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  backgroundColor: Colors.blue,
                  child: Column(
                    children: [
                      SizedBox(height: 70,width: 500,),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Seleziona Data'),
                        onPressed: () async{
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          setState(()=>dateTime=newDate!);
                        },
                      ),
                      SizedBox(width: 12,),
                      ElevatedButton(
                        child: Text('Seleziona ora'),
                        onPressed:()async{
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(dateTime)
                          );
                          setState(()=>dateTime=new DateTime(dateTime.year,dateTime.month,dateTime.day,newTime!.hour));
                          dataDaPrenotare=""+dateTime.day.toString()+dateTime.month.toString()+dateTime.year.toString()+dateTime.hour.toString();
                          print(""+dateTime.toString());
                        } ,
                      ),
                      Text(
                        "Nome: "+widget.court.name,
                        style: TextStyle(
                            fontSize: 20,
                            color:Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        "Sport: "+widget.court.type,
                        style: TextStyle(
                            fontSize: 20,
                            color:Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        "Città: "+widget.court.city,
                        style: TextStyle(
                            fontSize: 20,
                            color:Theme.of(context).primaryColor
                        ),
                      ),
                      /*Text(
                    "Prezzo: "+widget.court.priceHourly.toString()+"£",
                    style: TextStyle(
                        fontSize: 20,
                        color:Theme.of(context).primaryColor
                    ),
                  ),
                  Text(
                    "descrizione: "+widget.court.description,
                    style: TextStyle(
                        fontSize: 20,
                        color:Theme.of(context).primaryColor
                    ),
                  ),*/
                      CircularIconButton(
                        icon: Icons.shopping_basket_sharp,
                        onPressed: (){
                          print("ho premuto");
                          if(Model.sharedInstance.logged)
                            _acquisto();
                          else {
                            print("non sei loggato");
                            final snackBar = SnackBar(
                              content: Text("Errore non sei loggato."),
                              backgroundColor: Colors.red,);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                      )
                    ],
                  ),
                );
              }
          );
        },
        child:Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  widget.court.name,
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  widget.court.city,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }


  void _acquisto(){
    print("sono in acquisto");
    Model.sharedInstance.addBooking(dataDaPrenotare, widget.court).then((value) {
      print("sono in "+value.toString());
      if(value=="court is already booked"){
        final snackBar = SnackBar(
          content: Text("Errore campetto non disponibile"),
          backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else{
        final snackBar = SnackBar(
          content: Text("Prenotazione effetuata"),
          backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    });
  }


}

 */




















//codice scala
/*
class CourtCard extends StatelessWidget {
  final Court court;


  CourtCard({required this.court}) : super();




  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              court.name,
              style: TextStyle(
                fontSize: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              court.description,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }


}

 */
