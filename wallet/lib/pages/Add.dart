import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtAmount = new TextEditingController();

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Add New Task", textScaleFactor: 1.6,),
                SizedBox(height: 20.0,),
                Text("Task Name"),
                TextFormField(
                  controller: txtName,
                ),
                SizedBox(height: 20.0,),
                Text("Task Amount"),
                TextFormField(
                  controller: txtAmount,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      date = await showDatePicker(
                          context: context,
                          initialDate: date?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500)
                      );
                    },
                    child: Text("TARGET DATE")
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          txtName.clear();
                          txtAmount.clear();
                          date = null;
                        },
                        child: Text("CLEAR")
                    ),
                    ElevatedButton(
                      onPressed: (){
                        String name = txtName.text;
                        String amount = txtAmount.text;

                        FirebaseFirestore.instance.collection("task")
                            .add({
                          "taskname": name,
                          "amount": int.parse(amount),
                          "date": date,
                          "complete": 0,
                          "contribution_total": 0
                        });
                        txtName.clear();
                        txtAmount.clear();
                        date = null;
                      },
                      child: Text("SAVE"),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
