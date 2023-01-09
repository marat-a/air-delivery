import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewOrderForm extends StatefulWidget {
  final String url;

  const NewOrderForm({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => NewOrderFormState();
}// TestHttp

class NewOrderFormState extends State<NewOrderForm> {
  final _formKey = GlobalKey<FormState>();

  late String _url, _body;
  late int _status;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  }//initState





  _sendRequestPostBodyHeaders() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();//update form data

      try {
        var response = await http.post(_url,
            body: {"customer": {
              "name": null,
              "phone": "+79221788587",
              "email": null
            },
              "orderProducts": [],
              "dateCreated": null,
              "transferType": "DELIVERY",
              "delivery": {
                "deliveryTime": {
                  "startTime": "2023-01-02T08:00:00",
                  "endTime": "2023-01-02T09:00:00"
                },
                "comment": "3690",
                "address": "Яскина 12-207",
                "cost": 0.0
              },
              "status": null,
              "orderComment": "3690, ",
              "payStatus": null,
              "receivingType": null,
              "sum": 5830.0,
              "numberOfProducts": 0,
              "totalOrderPrice": 0.0},
            headers: {'Accept':'application/json'}
        );

        _status = response.statusCode;
        _body = response.body;
      } catch (error) {
        _status = 0;
        _body = error.toString();
      }
      setState(() {});//reBuildWidget
    }
  }//_sendRequestPost


  Widget build(BuildContext context) {
    return Form(key: _formKey, child: SingleChildScrollView(child: Column(
      children: <Widget>[
        Container(
            child: Text('API url', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
            padding: EdgeInsets.all(10.0)
        ),
        Container(
            child: TextFormField(initialValue: _url, validator: (value){if (value.isEmpty) return 'API url isEmpty';}, onSaved: (value){_url = value;}, autovalidate: true),
            padding: EdgeInsets.all(10.0)
        ),
        SizedBox(height: 20.0),
        RaisedButton(child: Text('Send request GET'), onPressed: _sendRequestGet),
        RaisedButton(child: Text('Send request POST'), onPressed: _sendRequestPost),
        RaisedButton(child: Text('Send request POST with Body and Headers'), onPressed: _sendRequestPostBodyHeaders),
        SizedBox(height: 20.0),
        Text('Response status', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
        Text(_status == null ? '' :_status.toString()),
        SizedBox(height: 20.0),
        Text('Response body', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
        Text(_body == null ? '' : _body),
      ],
    )));
  }//build
}//TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: NewOrderForm(url: 'https://json.flutter.su/echo')
    );
  }
}
