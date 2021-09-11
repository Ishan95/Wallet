import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final Stream<QuerySnapshot> _contributionStream = FirebaseFirestore.instance.collection("contribution").snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: _contributionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return new Text("Something went Wrong!");
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
          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                return Dismissible(
                  background: Container(
                      child: Icon(Icons.delete)
                  ),
                  onDismissed: (direction){
                    FirebaseFirestore.instance.collection("task")
                        .doc(document["task_id"])
                        .update({
                      "contribution_total": FieldValue.increment(-1 * document["amount"])
                    });
                    FirebaseFirestore.instance.collection("contribution")
                        .doc(document.id)
                        .delete();
                  },
                  key: Key(document.id),
                  child: ListTile(
                    title: Text(document['note'], textScaleFactor: 1.4),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(document["amount"].toString()),
                        Text(document["date"].toDate().toString())
                      ],
                    ),
                  ),
                );
              }).toList()
          );
        },
      ),
    );
  }
}
