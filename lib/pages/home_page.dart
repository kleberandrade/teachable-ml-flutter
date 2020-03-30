import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:teachable_ml/helpers/camera_helper.dart';
import 'package:teachable_ml/helpers/tflite_helper.dart';
import 'package:teachable_ml/models/tflite_result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Teachable Machine'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: _pickImage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildResult(),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _image == null
                ? Text('Sem imagem')
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('Sem resultados'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label} ( ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                lineHeight: 14.0,
                percent: _outputs[index].confidence,
              ),
            ],
          );
        },
      ),
    );
  }
}
