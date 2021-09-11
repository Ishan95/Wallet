import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtNote = TextEditingController();

  final Stream<QuerySnapshot> _taskStream = FirebaseFirestore.instance
      .collection("task").snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(

          stream: _taskStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong!");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Center(
                    child: CircularProgressIndicator()
                ),
              );
            }

            return ExpansionPanelList(
                children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                      dynamic doc = document.data();
                      return ExpansionPanel(
                          headerBuilder: (BuildContext context,
                              bool isExpanded) {
                            return Container(
                              padding: EdgeInsets.all(11.0),
                              child: Text(doc["taskname"], textScaleFactor: 1.5,),
                            );
                          },
                          body: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text("AMOUNT: " + doc["amount"].toString(),
                                      textScaleFactor: 1.1,),
                                    Text("DATE: " +
                                        doc["date"].toDate().toString().split(
                                            " ")[0], textScaleFactor: 1.1),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(doc["contribution_total"].toString() +
                                        " / " + doc["amount"].toString()),
                                    IconButton(
                                      icon: Icon(Icons.attach_money),
                                      splashColor: Colors.green,
                                      highlightColor: Colors.greenAccent,
                                      color: Colors.green,
                                      onPressed: () {
                                        String tid = document.id;
                                        _showMyDialog(tid);
                                      },
                                    )
                                  ],
                                ),
                                LinearProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                  value: doc["contribution_total"] /
                                      doc["amount"],
                                )
                              ],
                            ),
                          ),
                          isExpanded: true
                      );
                    }
                ).toList()
            );
          }
      ),
    );
  }

  Future<void> _showMyDialog(tid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ENTER CONTRIBUTION'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter Amount'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: txtAmount,
                ),
                Text('Enter Note'),
                TextFormField(
                  controller: txtNote,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(

              child: const Text('ADD', style: TextStyle(fontSize: 10.0)),
              onPressed: () {

                String amount = txtAmount.text;
                String note = txtNote.text;

                FirebaseFirestore.instance.collection("contribution")
                    .add({
                  'amount': int.parse(amount),
                  'note': note,
                  'date': new DateTime.now(),
                  'task_id': tid
                });

                FirebaseFirestore.instance.collection('task')
                    .doc(tid)
                    .update({
                  'contribution_total': FieldValue.increment(int.parse(amount))
                });

                txtAmount.text = "";
                txtNote.text = "";

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
