import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

enum LegendShape { circle, rectangle }

class PieChartCustom extends StatefulWidget {
  const PieChartCustom({super.key, required this.dataMap});

  final Map<String, double> dataMap;

  @override
  PieChartCustomState createState() => PieChartCustomState();
}

class PieChartCustomState extends State<PieChartCustom> {

  final colorList = <Color>[
    const Color.fromARGB(255, 3, 146, 15),
    const Color.fromARGB(255, 85, 84, 94),
  ];

  final ChartType _chartType = ChartType.disc;
  final bool _showCenterText = false;
  final bool _showCenterWidget = false;
  final double _ringStrokeWidth = 32;
  final double _chartLegendSpacing = 32;

  final bool _showLegendsInRow = false;
  final bool _showLegends = false;

  final bool _showChartValueBackground = true;
  final bool _showChartValues = true;
  final bool _showChartValuesInPercentage = true;
  final bool _showChartValuesOutside = false;

  final LegendShape _legendShape = LegendShape.circle;
  final LegendPosition _legendPosition = LegendPosition.right;

  int key = 0;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      key: ValueKey(key),
      dataMap: widget.dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing,
      chartRadius: math.min(MediaQuery.of(context).size.width / 4.0, 300),
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType,
      centerText: _showCenterText ? "HYBRID" : null,
      centerWidget: _showCenterWidget
          ? Container(color: Colors.red, child: const Text("Center"))
          : null,
      // legendLabels: _showLegendLabel ? legendLabels : {},
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth,
      emptyColor: Colors.grey,
      gradientList: null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
  }
}
