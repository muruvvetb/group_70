import 'dart:io';
import 'package:flutter/material.dart';
import '../components/colors.dart';

class MedicineCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final int remainingCount;
  final String type;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onAddAlarm; // Yeni eklenen callback

  const MedicineCard({
    required this.imagePath,
    required this.name,
    required this.remainingCount,
    required this.type,
    required this.onDelete,
    required this.onEdit,
    required this.onAddAlarm, // Yeni eklenen callback
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imagePath.isEmpty
                ? Container(
                    width: 130,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.medication,
                        size: 50, color: Colors.white),
                  )
                : Image.file(File(imagePath),
                    width: 130, height: 100, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kalan adet: $remainingCount',
                    style: TextStyle(
                      fontSize: 16,
                      color: remainingCount <= 3 ? Colors.red : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: medicineTypeColors[type] ?? Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'edit') {
                  onEdit();
                } else if (result == 'delete') {
                  onDelete();
                } else if (result == 'add_alarm') {
                  onAddAlarm(); // Alarm ekle callback
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Düzenle'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Sil'),
                ),
                const PopupMenuItem<String>(
                  value: 'add_alarm',
                  child: Text('Alarm Ekle'), // Yeni eklenen seçenek
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
