import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class CounterWidget extends StatefulWidget {
  final DateTime checkInTime;
  final DateTime? checkOutTime;

  const CounterWidget({
    super.key,
    required this.checkInTime,
    this.checkOutTime,
  });

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.checkInTime != null) {
      if (widget.checkOutTime != null) {
        // Calculate fixed duration between check-in and check-out
        _currentDuration = widget.checkOutTime!.difference(widget.checkInTime);
      } else {
        // Start running timer from check-in time
        _startTimer();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentDuration = DateTime.now().difference(widget.checkInTime);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer display
        Text(
          formatDuration(_currentDuration),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.008), // Responsive spacing
        // Check-in/out time display
        Text(
          '${formatDateTime(widget.checkInTime.toString())} - ${widget.checkOutTime != null ? formatDateTime(widget.checkOutTime!.toString()) : 'Pending'}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03, // Responsive font size
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}