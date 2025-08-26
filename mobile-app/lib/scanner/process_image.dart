import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:mushroom_master/guide/widgets/mushroom.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/scanner/identification_results_page.dart';
import 'package:mushroom_master/utils/database_helper.dart'; // Import DatabaseHelper

class Classify extends StatefulWidget {
  final File image;
  const Classify({Key? key, required this.image}) : super(key: key);

  @override
  _ClassifyState createState() => _ClassifyState();
}

class _ClassifyState extends State<Classify> {
  static Interpreter? _interpreter;
  static List<String> _labels = [];
  static late List<int> _inputShape;
  static late List<int> _outputShape;
  String? error;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processImageSafely();
  }

  // Wrapping the process in a safe method with better error handling
  Future<void> _processImageSafely() async {
    try {
      await processImage();
    } catch (e) {
      print('Uncaught error during image processing: $e');
      if (mounted) {
        setState(() {
          error = 'Unexpected error during processing: $e';
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> processImage() async {
    try {
      await initializeModel();

      final sw = Stopwatch()..start();

      // Check if the image file exists
      if (!widget.image.existsSync()) {
        setState(() {
          error = 'Image file not found or inaccessible.';
          _isProcessing = false;
        });
        return;
      }

      final result = await runModelOnImage(widget.image);

      sw.stop();
      print('Inference took: ${sw.elapsedMilliseconds} ms');

      final topPredictions = result['topPredictions'] as List<Map<String, dynamic>>;

      // Fetch mushroom data for each prediction
      List<Mushroom> topMushrooms = [];

      for (var prediction in topPredictions) {
        final predictedLabel = prediction['label'] as String;
        final confidence = prediction['confidence'] as double;

        Mushroom? mushroom = await getMushroomByName(predictedLabel, confidence);
        if (mushroom != null) {
          topMushrooms.add(mushroom);
        }
      }

      if (topMushrooms.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _isProcessing = false;
        });

        // Navigate to the identification results page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext ctx) => IdentificationResultsPage(
              mushrooms: topMushrooms,
              imagePath: widget.image.path,
            ),
          ),
        );
      } else {
        setState(() {
          error = 'No matching mushrooms found in database.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      print('Error during classification: $e');
      if (mounted) {
        setState(() {
          error = 'Error: $e';
          _isProcessing = false;
        });
      }
    }
  }

  static Future<void> initializeModel() async {
    if (_interpreter != null) return;
    try {
      // Load the model
      print('Loading TFLite model...');
      final modelData = await rootBundle.load('assets/model.tflite');
      final options = InterpreterOptions()..threads = 2; // Use multiple threads for better performance

      print('Creating interpreter...');
      _interpreter = Interpreter.fromBuffer(
        modelData.buffer.asUint8List(),
        options: options,
      );
      print('Interpreter created successfully');

      // Load the labels
      print('Loading label data...');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty)
          .map((label) => label.trim())
          .toList();
      print('Loaded ${_labels.length} labels');

      // Get input and output tensor information
      _inputShape = _interpreter!.getInputTensor(0).shape;
      _outputShape = _interpreter!.getOutputTensor(0).shape;
      print('Model initialized with input shape: $_inputShape, output shape: $_outputShape');
    } catch (e) {
      print('Error loading model or labels: $e');
      throw Exception('Failed to initialize model: $e');
    }
  }

  // Function to preprocess the image
  Float32List preprocessImage(img.Image image) {
    // Get input dimensions from model
    final inputWidth = _inputShape[1];
    final inputHeight = _inputShape[2];
    final channels = _inputShape[3];

    // Resize image to match model input size
    final resizedImage = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.linear,
    );

    // Create buffer for input data
    final Float32List input = Float32List(inputWidth * inputHeight * channels);

    int pixelIndex = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // Normalize pixel values to [-1, 1]
        input[pixelIndex++] = (img.getRed(pixel) - 127.5) / 127.5;
        input[pixelIndex++] = (img.getGreen(pixel) - 127.5) / 127.5;
        input[pixelIndex++] = (img.getBlue(pixel) - 127.5) / 127.5;
      }
    }

    return input;
  }

  Future<Map<String, dynamic>> runModelOnImage(File imageFile) async {
    try {
      // Load and decode the image
      final imageBytes = await imageFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }

      // Preprocess the image
      final input = preprocessImage(decodedImage);

      // Create output buffer with correct shape [1, outputSize]
      final outputSize = _outputShape[1]; // Number of classes
      final output = List.filled(1 * outputSize, 0.0).reshape([1, outputSize]);

      // Run inference
      _interpreter!.run(
        input.reshape([1, _inputShape[1], _inputShape[2], _inputShape[3]]),
        output,
      );

      // Logging raw model output for debugging
      print('Raw model output: ${output[0]}');
      // Log each index with corresponding label and confidence
      for (int i = 0; i < outputSize && i < _labels.length; i++) {
        print('Model output - index: $i, label: ${_labels[i]}, confidence: ${output[0][i]}');
      }

      // Create a list to store all class probabilities
      List<Map<String, dynamic>> topPredictions = [];

      // Add all predictions to the list
      for (int i = 0; i < outputSize && i < _labels.length; i++) {
        if (output[0][i] > 0.01) { // Only include predictions with > 1% confidence
          topPredictions.add({
            'label': _labels[i],
            'confidence': output[0][i],
            'index': i
          });
        }
      }

      // Sort by confidence (highest first)
      topPredictions.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));

      // Take the top 5 (or fewer if there aren't 5 with confidence > 1%)
      topPredictions = topPredictions.take(5).toList();

      // Logging top predictions after filtering and sorting
      print('Top predictions: $topPredictions');

      // If list is empty, add an unknown result
      if (topPredictions.isEmpty) {
        topPredictions.add({
          'label': 'Unknown',
          'confidence': 0.0,
          'index': -1
        });
      }

      return {
        'topPredictions': topPredictions,
        'label': topPredictions.first['label'], // For backward compatibility
        'confidence': topPredictions.first['confidence'] // For backward compatibility
      };
    } catch (e) {
      print('Error during inference: $e');
      throw Exception('Error during inference: $e');
    }
  }

  Future<Mushroom?> getMushroomByName(String name, double confidence) async {
    try {
      // Initialize the database using DatabaseHelper
      String dbPath = await DatabaseHelper.initializeDatabase(
        'fungi_species.db',
        'assets/databases/fungi_species.db'
      );
      Database db = await openDatabase(dbPath);

      // Query the database
      List<Map<String, dynamic>> data = await db.query(
        'fungi_species',
        columns: ['id', 'label', 'description', 'edibility', 'image', 'species_name', 
                 'class', 'phylum', 'order', 'family', 'genus'],
        where: 'label = ?',
        whereArgs: [name],
        limit: 1,
      );

      await db.close();

      if (data.isNotEmpty) {
        Map<String, dynamic> row = data.first;
        Mushroom mushroom = Mushroom(
          id: row['id'].toString(),
          name: row['label'] as String,
          description: (row['description'] ?? '') as String,
          imageUrl: (row['image'] ?? '') as String,
          edibility: row['edibility'] as String?,
          mushroomClass: row['class'] as String?,
          phylum: row['phylum'] as String?,
          order: row['order'] as String?,
          family: row['family'] as String?,
          genus: row['genus'] as String?,
          confidence: confidence,
        );
        return mushroom;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mushroom from database: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Classification Error'),
          elevation: 0,
        ),
        bottomNavigationBar: NavBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Camera'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Processing Image'),
          elevation: 0,
        ),
        bottomNavigationBar: NavBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _isProcessing ? 'Analyzing mushroom...' : 'Classification complete!',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }
}