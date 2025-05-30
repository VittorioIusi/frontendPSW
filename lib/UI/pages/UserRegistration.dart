import 'package:fakestore/UI/behaviors/AppLocalizations.dart';
import 'package:fakestore/UI/widgets/buttons/CircularIconButton.dart';
import 'package:fakestore/UI/widgets/InputField.dart';
import 'package:fakestore/model/Model.dart';
import 'package:fakestore/model/objects/User.dart';
import 'package:fakestore/model/support/extensions/StringCapitalization.dart';
import 'package:flutter/material.dart';

import '../../model/objects/UserReq.dart';


class UserRegistration extends StatefulWidget {
  UserRegistration() : super();


  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  bool _adding = false;
  User? _justAddedUser;


  TextEditingController _firstNameFiledController = TextEditingController();
  TextEditingController _lastNameFiledController = TextEditingController();
  TextEditingController _telephoneNumberFiledController = TextEditingController();
  TextEditingController _emailFiledController = TextEditingController();
  TextEditingController _addressFiledController = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                AppLocalizations.of(context)!.translate("register").capitalize + "!",
                style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: AppLocalizations.of(context)!.translate("firstName").capitalize,
                    controller: _firstNameFiledController,
                  ),
                  InputField(
                    labelText: AppLocalizations.of(context)!.translate("lastName").capitalize,
                    controller: _lastNameFiledController,
                  ),
                  InputField(
                    labelText: AppLocalizations.of(context)!.translate("telephoneNumber").capitalize,
                    controller: _telephoneNumberFiledController,
                  ),
                  InputField(
                    labelText: AppLocalizations.of(context)!.translate("email").capitalize,
                    controller: _emailFiledController,
                  ),
                  InputField(
                    labelText: AppLocalizations.of(context)!.translate("password").capitalize,
                    controller: _controllerPassword,
                    isPassword: true,
                  ),
                  CircularIconButton(
                    icon: Icons.person_rounded,
                    onPressed: () {
                      _register();
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: _adding ?
                      CircularProgressIndicator() :
                      _justAddedUser != null ?
                      Text(
                          AppLocalizations.of(context)!.translate("just_added") + ":" + _justAddedUser!.firstName + " " + _justAddedUser!.lastName + "!"
                      ) :
                      SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    setState(() {
      _adding = true;
      _justAddedUser = null;
    });
    User user = User(
      userName: _emailFiledController.text,
      firstName: _firstNameFiledController.text,
      lastName: _lastNameFiledController.text,
      telephone: _telephoneNumberFiledController.text,
      email: _emailFiledController.text,
    );
    if (_firstNameFiledController.text == "" ||
        _lastNameFiledController.text == "" ||
        _telephoneNumberFiledController.text == "" ||
        _emailFiledController.text == "" || _controllerPassword.text == "") {
      final snackBar = SnackBar(
        content: Text("Tutti campi obbligatori"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _adding = false;
      });
    }
    else {
      UserReq userReq = UserReq(
          user: user,
          password: _controllerPassword.text
      );
      Model.sharedInstance.addUser(userReq)?.then((result) {
        setState(() {
          _adding = false;
          _justAddedUser = result;
        });
      });
    }
  }

}
