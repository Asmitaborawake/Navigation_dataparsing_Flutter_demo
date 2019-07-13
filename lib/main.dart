import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'User.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUsers() async{
    
    var data = await http.get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");
    
    var jsonData = json.decode(data.body);
    
    List<User> users = [];
    
    for(var u in jsonData){
      User user = User(u["index"], u["about"], u["name"], u["email"], u["picture"]);
      users.add(user);

    }

    print(users.length);
    return users;
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data == null){
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            }else {

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data[index].picture
                    ),
                  ),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].email),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index])));
                  },

                 );
                },
            );
            }
          },
        ),
      ),

    );
  }
}


class DetailPage extends StatelessWidget {

  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(user.picture),

            ),
              SizedBox(
                height: 10.0,
                width: 150.0,
              ),
              Text(user.name,
                style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,

              ),
              ),
              SizedBox(
                height: 5.0,
                width: 150.0,
              ),
              Text(user.email,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,

                ),
              ),
              SizedBox(
                height: 15.0,
                width: 150.0,
              ),
              Text(user.about,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,

                ),
              ),

            ],
          ),
        ),
       // Image(image:NetworkImage (user.picture),),
      ),
    );
  }
}


