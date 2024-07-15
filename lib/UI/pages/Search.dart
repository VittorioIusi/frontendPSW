import 'package:fakestore/UI/behaviors/AppLocalizations.dart';
import 'package:fakestore/UI/widgets/buttons/CircularIconButton.dart';
import 'package:fakestore/UI/widgets/InputField.dart';
import 'package:fakestore/UI/widgets/CourtCard.dart';
import 'package:fakestore/model/Model.dart';
import 'package:fakestore/model/objects/Product.dart';
import 'package:fakestore/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';

import 'package:fakestore/UI/widgets/CourtCard.dart';

import '../../model/objects/Court.dart';





class Search extends StatefulWidget {
  Search() : super();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _searching = false;
  bool _byType = false;
  bool _byCity = false;
  String currentValue="Per sport e città";
  int currentPage = 0;
  int dimPage = 4;
  List<Court>? _courts;

  TextEditingController _searchFiledController = TextEditingController();
  TextEditingController _controllerType = TextEditingController();
  TextEditingController _controllerCity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            top(),
            middle(),
            bottom(),
          ],
        ),
      ),
    );
  }

  Widget top(){
    List<String>items=["Per sport","Per città","Per sport e città"];
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
            children: [
              Flexible(
                  child: DropdownButton(
                    value: currentValue,
                    hint: Text('Seleziona un tipo di Ricerca'),
                    icon: Icon(Icons.arrow_drop_down),
                    items: items.map((String item){
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text('$item'),
                      );
                    }).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return items.map<Widget>((String item){
                        return Text(item);
                      }).toList();
                    },
                    style: new TextStyle(color: Colors.black87),
                    onChanged: (String? value){
                      setState(() {
                        currentValue=value!;
                        _changeMiddle(value);
                        currentPage=0;
                      });
                      _changeMiddle(value);
                    },
                  )
              )
            ]
        )
    );//padding
  }
  void _changeMiddle(value){
    setState(() {
      switch(value){
        case "Per sport":
          _byType=true;
          _byCity=false;
          break;
        case "Per città":
          _byType=false;
          _byCity=true;
          break;
        default:
          _byType=false;
          _byCity=false;
      }
    });
  }
  Widget middle(){
    if(_byCity || _byType)
      return findBy();
    return findByBoth();
  }

  Widget bottom(){
    return !_searching ?
    _courts == null ?
    SizedBox.shrink() :
    _courts?.length == 0 ?
    noResult():
    yesResults():
    CircularProgressIndicator();
  }
  Widget noResult(){
    return Text("No Results!!");
  }



  Widget yesResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _courts!.length,
          itemBuilder: (context, index) {
            return CourtCard(
              _courts![index],
            );
          },
        ),
      ),
    );
  }


  Widget findBy(){
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child : Row(
        children: [
          Flexible(
              child: InputField(
                labelText: "Cerca",
                controller: _searchFiledController,
                onSubmit: (value){
                  if(_byType)
                    _search("Per sport");
                  else
                    _search("Per città");
                },
              )
          ),
          CircularIconButton(
            icon: Icons.search_rounded,
            onPressed: (){
              if(_byType)
                _search("Per sport");
              _search("Per città");
            },
          ),
          CircularIconButton(
              icon: Icons.arrow_circle_left_outlined,
              onPressed: () {
                if (currentPage != 0) {
                  currentPage--;
                  _search(currentValue);
                }
              }
          ),
          CircularIconButton(
            icon: Icons.arrow_circle_right_outlined,
            onPressed: (){
              if(_courts!=null && _courts?.length == dimPage){
                currentPage++;
                _search(currentValue);
              }
            },
          )
        ],
      ),
    );
  }

  Widget findByBoth(){
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Flexible(
              child: InputField(
                labelText: "Citta es. rovito",
                controller: _controllerCity,
              )
          ),
          Flexible(
              child: InputField(
                labelText: "Sport es. tennis",
                controller: _controllerType,
              )
          ),
          CircularIconButton(
              icon: Icons.search_rounded,
              onPressed: () {
                _search("ByBoth");
              }
          ),
          CircularIconButton(
              icon: Icons.arrow_circle_left_outlined,
              onPressed: () {
                if (currentPage != 0) {
                  currentPage--;
                  _search(currentValue);
                }
              }
          ),
          CircularIconButton(
            icon: Icons.arrow_circle_right_outlined,
            onPressed: (){
              if(_courts!=null && _courts?.length == dimPage){
                currentPage++;
                _search(currentValue);
              }
            },
          )
        ],
      ),
    );
  }

  void _search(String arg){
    setState(() {
      _searching = true;
      _courts=[];
    });
    switch(arg){
      case "Per città":
        if(_searchFiledController.text!="") {
          Model.sharedInstance.searchCourtCity(
              _searchFiledController.text, numPage: currentPage, dimPage: dimPage, sortBy: '').then((result) {
            setState(() {
              _searching = false;
              _courts = result;
            });
          });
        }
        else{
          Model.sharedInstance.searchAllCourt(numPage: currentPage, dimPage: dimPage, sortBy: '')
              .then((result) {
            setState(() {
              _searching = false;
              _courts = result;
            });
          });
        }
        break;
      case "Per sport":
        Model.sharedInstance.searchCourtType(
            _searchFiledController.text, numPage: currentPage, dimPage: dimPage, sortBy: '').then((result) {
          setState(() {
            _searching = false;
            _courts = result;
          });
        });
        break;
      case "ByBoth":
        Model.sharedInstance.searchCourtTypeCity(
            _controllerType.text, _controllerCity.text, numPage: currentPage,
            dimPage: dimPage, sortBy: '')
            .then((result) {
          setState(() {
            _searching = false;
            _courts = result;
          });
        });

        break;


    }



  }

}























//classe scala
/*
class Search extends StatefulWidget {
  Search() : super();


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool _searching = false;
  List<Product>? _products;

  TextEditingController _searchFiledController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            top(),
            bottom(),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Flexible(
            child: InputField(
              labelText: AppLocalizations.of(context)!.translate("search").capitalize,
              controller: _searchFiledController,
              onSubmit: (value) {
                _search();
              },
            ),
          ),
          CircularIconButton(
            icon: Icons.search_rounded,
            onPressed: () {
              _search();
            },
          ),
        ],
      ),
    );
  }

  Widget bottom() {
    return  !_searching ?
              _products == null ?
                SizedBox.shrink() :
                _products!.length == 0 ?
                  noResults() :
                  yesResults() :
              CircularProgressIndicator();
  }

  Widget noResults() {
    return Text(AppLocalizations.of(context)!.translate("no_results").capitalize + "!");
  }

  Widget yesResults() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: _products!.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: _products![index],
            );
          },
        ),
      ),
    );
  }


  void _search() {
    setState(() {
      _searching = true;
      _products = null;
    });
    Model.sharedInstance.searchProduct(_searchFiledController.text)?.then((product) {
      setState(() {
        _searching = false;
        _products = product;
      });
    });
  }


}

 */
