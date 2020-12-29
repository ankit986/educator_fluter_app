import 'package:flutter/material.dart';

import 'package:educator/services/rest_api_service.dart';

import 'package:educator/sqlite/db_helper.dart';
import 'package:educator/Model/module_info.dart';

class Module_Details extends StatefulWidget {
  static const routeName = '/moduleDetails';

  String module_id;
  String course_id;

  Module_Details({Key key, @required this.course_id, this.module_id})
      : super(key: key);

  @override
  _Module_DetailsState createState() => _Module_DetailsState();
}

class _Module_DetailsState extends State<Module_Details> {
  Future<List<Module_Info>> _modules;
  final _module_nameController = TextEditingController();
  final _module_descriptionController = TextEditingController();

  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    _populateFormFields();
    super.initState();
  }

  void _populateFormFields() {
    //If course_id is already available then populate the Form Fields
    if (widget.module_id != null && widget.module_id != "") {
      _modules = _dbHelper.getModulesBymodule_id(widget.module_id);

      _modules.then((value) {
        if (value.length > 0) {
          //Setting the field value to course whose module id is received
          _module_descriptionController.text = value[0].module_description;
          _module_nameController.text = value[0].module_name;
        }
      }).catchError((onError) {
        print("ERROR IN GETTING DATA FROM DATABASE");
        print(onError);
      });
    }
  }

  //To Save Module in Database and through API
  void _saveModule() {
    var course_id = widget.course_id;

    String _module_name = _module_nameController.text;
    String _module_description = _module_descriptionController.text;

    //Generating ID for module
    String id = course_id +
        "_" +
        _module_name
            .replaceAll(new RegExp(r"[^\s\w]"), '')
            .replaceAll(' ', '') +
        "_" +
        DateTime.now().millisecondsSinceEpoch.toString();

    var module_id = widget.module_id == null
        ? id
        : widget
            .module_id; // If module id is null then use new id to save else use recieved id to update.

    var moduleInfo = Module_Info(
        course_id: widget.course_id,
        module_id: module_id,
        module_name: _module_name,
        module_description: _module_description);

    if (widget.module_id != null && widget.module_id != "") {
      ModuleInfoList moduleInfoList = new ModuleInfoList(modules: [moduleInfo]);

      //Update Module through API Post request
      updateModuleToServer(moduleInfoList, widget.module_id).then((value) {
        print(value);
      }).catchError((onError) {
        print(onError);
      });

      //  Update Local Database
      _dbHelper.updateModule(moduleInfo);
    } else {
      ModuleInfoList moduleInfoList = new ModuleInfoList(modules: [moduleInfo]);

      //Save Module through API Post request
      addModuleToServer(moduleInfoList).then((value) {
        print(value);
      }).catchError((onError) {
        print(onError);
      });
      //Insert Module into Local Database
      _dbHelper.insertModule(moduleInfo);
    }

    //Navigate Back to Course Detail Screen
    Navigator.pop(context);
  }

  //To Delete Module from Database and through API
  void _deleteModule() {
    if (widget.module_id != null) {
      //Delete Module through API Post request
      deleteModuleFromServer(widget.module_id);

      //Delete Module From Local Database
      _dbHelper.deleteModule(widget.module_id);
    }

    //Navigate Back To Course Detail Screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Module Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: Validator.validateModuleTitle,
                    controller: _module_nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Module Title',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: Validator.validateModuleDescription,
                    controller: _module_descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 1000,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Module Description'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonBar(
                        children: [
                          RaisedButton(
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await _alertDialogSave(context);
                              }
                            },
                            color: Color(0xFF6200EE),
                            child: Text('Save'),
                          ),
                          Container(
                            child: widget.module_id != null
                                ? RaisedButton(
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      await _alertDialogDelete(context);
                                    },
                                    color: Color(0xFF6200EE),
                                    child: Text('Delete'),
                                  )
                                : SizedBox(
                                    width: 10,
                                  ),
                          ),
                          RaisedButton(
                            textColor: Colors.white,
                            onPressed: () async {
                              await _alertDialogCancel(context);
                            },
                            color: Color(0xFF6200EE),
                            child: Text('Cancel'),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<ConfirmAction> _alertDialogSave(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create This Module?'),
          content: const Text('This will create the module from your device.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Create'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);

                _saveModule();
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _alertDialogCancel(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                // Navigator.of(context).pop(ConfirmAction.Accept);
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _alertDialogDelete(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete?'),
          content: Text('This will delete whatever you have done now!!!'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteModule();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            )
          ],
        );
      },
    );
  }
}

enum ConfirmAction { Cancel, Accept }

//To Validate the Form For Adding/Updating Module
class Validator {
  static String validateModuleDescription(String value) {
    if (value.isEmpty) return 'Please Enter Module Description';
    return null;
  }

  static String validateModuleTitle(String value) {
    if (value.isEmpty) return 'Please Enter Module Title';
    return null;
  }
}
