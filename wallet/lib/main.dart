import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallet/pages/Add.dart';
import 'package:wallet/tabs/Achieve.dart';
import 'package:wallet/tabs/History.dart';
import 'package:wallet/tabs/Home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      home:MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.blueGrey
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int index = 0;
  List tabs = [];
  late Widget page;
  bool pageAssigned = false;

  @override
  Widget build(BuildContext context) {

    tabs.add(Home());
    tabs.add(Achieve());
    tabs.add(History());

    return Scaffold(
      appBar: AppBar(
        title: Text("All Tasks"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            page = Add();
            pageAssigned = true;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Profile"),
              decoration: BoxDecoration(
                  color: Colors.blueGrey
              ),
            ),
            ListTile(
              title: Text("Edit Account"),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Notification"),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Feedback"),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Log Out"),
              onTap: (){

              },
            ),
          ],
        ),
      ),
      body: pageAssigned ? page: tabs[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i){
          setState(() {
            index = i;
            pageAssigned = false;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade_outlined),
            label: "ACHIEVE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "HISTORY",
          ),
        ],
      ),
    );
  }
}

