import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/medicine.dart';
import '../components/colors.dart';

class AddMedicineScreen extends StatefulWidget {
  final Function(Medicine) onAddMedicine;
  final Medicine? existingMedicine;

  const AddMedicineScreen({
    super.key,
    required this.onAddMedicine,
    this.existingMedicine,
  });

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  String? _name;
  int? _count;
  String? _type;

  @override
  void initState() {
    super.initState();
    if (widget.existingMedicine != null) {
      _name = widget.existingMedicine!.name;
      _count = widget.existingMedicine!.count;
      _type = widget.existingMedicine!.type;
      if (!_typeExistsInDropdown(_type!)) {
        _typeController.text = _type!;
        _type = null;
      }
      if (widget.existingMedicine!.imagePath.isNotEmpty) {
        _image = File(widget.existingMedicine!.imagePath);
      }
    }
  }

  bool _typeExistsInDropdown(String type) {
    return medicineTypes.contains(type);
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMedicine = Medicine(
        id: widget.existingMedicine?.id ?? const Uuid().v4(),
        name: _name!,
        count: _count!,
        type: _type ?? _typeController.text,
        imagePath: _image?.path ?? '',
        userId: widget.existingMedicine?.userId ??
            FirebaseAuth.instance.currentUser?.uid ??
            '',
      );
      widget.onAddMedicine(newMedicine);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _image == null
                  ? const Text('Resim seçilmedi.')
                  : Image.file(_image!, height: 200),
              ElevatedButton(
                onPressed: getImage,
                child: const Icon(Icons.camera_alt),
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'İlaç Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ilaç adını girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                initialValue: _count?.toString(),
                decoration: const InputDecoration(labelText: 'Kalan Adet'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kalan adetini girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _count = int.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'İlaç Türü'),
                items: medicineTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value;
                    _typeController.text = '';
                  });
                },
                onSaved: (value) {
                  _type = value;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Diğer (manuel)'),
                validator: (value) {
                  if (_type == null && (value == null || value.isEmpty)) {
                    return 'Lütfen ilaç türünü girin veya seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 133, 187, 222)), // Buton rengi mavi

                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Butonun yuvarlak olması
                    ),
                  ),
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
