import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cep_eczane/components/medicines.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prospektüs Bul")),
      body: _isBusy == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                maxLines: MediaQuery.of(context).size.height.toInt(),
                controller: controller,
                decoration:
                    const InputDecoration(hintText: "Fotoğrafta metin yok"),
              ),
            ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    // Metni parçalayarak kelimeleri bir listeye dönüştür
    List<String> words = recognizedText.text.split(RegExp(r'\s+'));

    // Tekrar eden kelimeleri kaldır
    Set<String> uniqueWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toSet();

    // İlaç isimlerini bul
    List<String> foundMedicines =
        uniqueWords.where((word) => medicineNames.contains(word)).toList();

    // Eğer ilaç ismi bulunduysa, Firestore'dan prospektüsleri getir
    if (foundMedicines.isNotEmpty) {
      // İlk bulunan ilacı kullanarak sorgu yapalım
      String medicine = foundMedicines.first;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Prospectuses')
          .where('medicine_name', isEqualTo: medicine)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Eğer prospektüs bulunduysa, içeriğini göster
        String content = snapshot.docs.first['content'];
        controller.text = "İlaç: $medicine\n\nProspektüs:\n$content";
      } else {
        controller.text = "Prospektüs bulunamadı.";
      }
    } else {
      controller.text = "Tanımlanan bir ilaç ismi bulunamadı.";
    }

    // End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
