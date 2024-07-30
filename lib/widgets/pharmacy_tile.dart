import 'package:flutter/material.dart';

class PharmacyTile extends StatelessWidget {
  final String name;
  final String distance;
  final String address;

  const PharmacyTile({
    Key? key,
    required this.name,
    required this.distance,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Distance: $distance Km\nAddress: $address'),
    );
  }
}
