import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../components/colors.dart';
import '../widgets/medicine_card.dart';
import 'add_medicine.dart';
import '../models/medicine.dart';
import '../services/firestore_service.dart';

class MedicineBox extends StatefulWidget {
  const MedicineBox({super.key});

  @override
  _MedicineBoxState createState() => _MedicineBoxState();
}

class _MedicineBoxState extends State<MedicineBox> {
  final PageStorageBucket _bucket = PageStorageBucket();
  String? _selectedType;
  late Stream<List<Medicine>> _medicineStream;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _medicineStream = FirestoreService().getMedicines(userId);
  }

  void _filterMedicines(String? type) {
    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecza Kutusu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ListView(
                    children: [
                      ListTile(
                        title: const Text('Tümü'),
                        onTap: () {
                          _filterMedicines(null);
                          Navigator.pop(context);
                        },
                      ),
                      ...medicineTypes.map((type) => ListTile(
                            title: Text(type),
                            onTap: () {
                              _filterMedicines(type);
                              Navigator.pop(context);
                            },
                          )),
                      ListTile(
                        title: const Text('Diğer'),
                        onTap: () {
                          _filterMedicines('Diğer');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: PageStorage(
        bucket: _bucket,
        child: StreamBuilder<List<Medicine>>(
          stream: _medicineStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Bir hata oluştu'));
            }
            final medicines = snapshot.data ?? [];
            final filteredMedicines = _selectedType == null
                ? medicines
                : medicines.where((medicine) {
                    if (_selectedType == 'Diğer') {
                      return !medicineTypes.contains(medicine.type);
                    }
                    return medicine.type == _selectedType;
                  }).toList();
            return ListView.builder(
              key: const PageStorageKey<String>('medicine_list'),
              itemCount: filteredMedicines.length,
              itemBuilder: (ctx, index) {
                final medicine = filteredMedicines[index];
                return MedicineCard(
                  imagePath: medicine.imagePath,
                  name: medicine.name,
                  remainingCount: medicine.count,
                  type: medicine.type,
                  onDelete: () {
                    FirestoreService().deleteMedicine(medicine.id);
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMedicineScreen(
                          onAddMedicine: (updatedMedicine) {
                            FirestoreService().updateMedicine(updatedMedicine);
                          },
                          existingMedicine: medicine,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicineScreen(
                onAddMedicine: (medicine) {
                  final newMedicine = Medicine(
                    id: const Uuid().v4(),
                    name: medicine.name,
                    count: medicine.count,
                    type: medicine.type,
                    imagePath: medicine.imagePath,
                    userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                  );
                  FirestoreService().addMedicine(newMedicine);
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
    );
  }
}
