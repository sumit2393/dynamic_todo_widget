import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_to_form/json_schema.dart';

class DynamicForm extends StatefulWidget {
  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {

  File _image;
  File _audio;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getAudio() async {
    File file = await FilePicker.getFile(type: FileType.audio);

    setState(() {
      _audio = file;
    });
  }


  Map formDataFS;

  Map form =  {
    'title': 'Register',
    'description':'',
    'autoValidated': false, //default false
    'fields': [
      {
        'key': 'name',
        'type': 'Input',
        'label': 'Name',
        'placeholder': "Enter name",
        'required': true
      },

      {
        'key': 'password',
        'type': 'Password',
        'label': 'Password',
        'required': true
      },

    ]
  };

  Map decorations = {
    'input': InputDecoration(
//      labelText: "Enter your name",
      prefixIcon: Icon(Icons.person),
      border: OutlineInputBorder(),
    ),
    'email': InputDecoration(
//      labelText: "Enter your name",
      prefixIcon: Icon(Icons.email),
      border: OutlineInputBorder(),
    ),
    'password': InputDecoration(
//      labelText: "Enter your name",
      prefixIcon: Icon(Icons.security),
      border: OutlineInputBorder(),
    ),
  };


  dynamic response;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Dynamic Form'),),
        body: SingleChildScrollView(
          child: Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('forms').snapshots(),
              builder: (context,snapshot){

                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }else{

                  formDataFS = new Map();

                  List<DocumentSnapshot> forms = snapshot.data.documents;
                  print('forms: '+forms[0].data.toString());

                  formDataFS = forms[0].data;

                  List fields = formDataFS['fields'];

//                  print('fields.length: '+fields.length.toString());

                  return Column(
                    children: <Widget>[
                      new JsonSchema(
                        decorations: decorations,
    //            form: form,
                        formMap: formDataFS,
                        onChanged: (dynamic response) {
                          this.response = response;
                        },
                        actionSave: (data) {
                          print('[JsonSchema][actionSave] data:'+data);
                        },
//                        buttonSave: new Container(
//                          child: Center(
//                            child: RaisedButton(
//                              color: Colors.blueAccent,
//                              child: Text("Submit", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
//                              onPressed: (){
//                                print('Login tapped!!!!!!!!!!!!!!!!!');
////                          print('response: '+response.toString());
//                                print('formDataFS: '+ formDataFS.toString());
//                              },
//                            ),
//                          ),
//                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: fields.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index){

                              Map singleItem = fields[index];

                              if(singleItem['type']=='Image') {

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 8, top: 8, bottom: 15, right: 8),
                                      child: Text(singleItem['label'].toString(), textAlign: TextAlign.left, style: TextStyle(
                                       color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    _image==null?
                                    Container(
                                      child: FlatButton(
                                          child: Text('Take Photo'),
                                          onPressed: getImage
                                      ),
                                    ):
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: <Widget>[
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: Image.file(_image, fit: BoxFit.fill,),
                                        ),
                                        Container(
                                          color: Colors.black45,
                                          height: 30,
                                          width: 30,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            iconSize: 16,
                                            color: Colors.white,
                                            onPressed: (){
                                              setState(() {
                                                _image = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );

                              }
                              else if(singleItem['type']=='Audio') {

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 8, top: 8, bottom: 15, right: 8),
                                      child: Text(singleItem['label'].toString(), textAlign: TextAlign.left, style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    _audio==null?
                                    Container(
                                      child: FlatButton(
                                          child: Text('Pick Audio'),
                                          onPressed: getAudio
                                      ),
                                    ):
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Text(_audio.path),
                                    )
                                  ],
                                );

                              }else{

                                return Container();

                              }
                            }
                        ),
                      ),

                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
