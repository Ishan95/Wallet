import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Achieve extends StatefulWidget {
  const Achieve({Key? key}) : super(key: key);

  @override
  _AchieveState createState() => _AchieveState();
}

class _AchieveState extends State<Achieve> {

  late List<charts.Series> seriesList;
  final bool animate = true;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("task")
        .snapshots().listen((data) {
      num amount = 0;
      num complete = 0;
      data.docs.forEach((doc) {
        amount += doc["amount"];
        complete += doc["contribution_total"];
      });
      setState(() {
        seriesList = _createSampleData(amount, complete);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
        seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60)
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(amount, complete) {
    final data = [
      new LinearSales(0, complete),
      new LinearSales(1, amount-complete),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}


/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}