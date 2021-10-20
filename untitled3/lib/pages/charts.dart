import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  ChartsState createState() => ChartsState();
}

class ChartsState extends State<Charts> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Cartesian chart", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 10,),
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Half yearly sales analysis'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Sales',
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ]),

            SizedBox(height: 10,),
            Text("Spark line chart", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 10,),

            SfSparkLineChart.custom(
              //Enable the trackball
              trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap),
              //Enable marker
              marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all),
              //Enable data label
              labelDisplayMode: SparkChartLabelDisplayMode.all,
              xValueMapper: (int index) => data[index].year,
              yValueMapper: (int index) => data[index].sales,
              dataCount: 5,
            ),

            SizedBox(height: 10,),
            Text("Circular chart", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 10,),

            SfCircularChart(
                title: ChartTitle(text: 'Sales by sales person'),
                legend: Legend(isVisible: true),
                series: <PieSeries<_SalesData, String>>[
                  PieSeries<_SalesData, String>(
                      explode: true,
                      explodeIndex: 0,
                      dataSource: data,
                      xValueMapper: (_SalesData data, _) => data.year,
                      yValueMapper: (_SalesData data, _) => data.sales,
                      //dataLabelMapper: (_SalesData data, _) => data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ]
            ),

            SizedBox(height: 10,),
            Text("Pyramid chart", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 10,),

            SfPyramidChart(
                series:PyramidSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData data, _) => data.year,
                    yValueMapper: (_SalesData data, _) => data.sales
                )
            )
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
  //final String text;
}