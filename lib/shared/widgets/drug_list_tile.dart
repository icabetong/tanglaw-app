import 'package:flutter/material.dart';
import 'package:tanglaw/features/detail/page.dart';
import 'package:tanglaw/shared/models/drug.dart';

class DrugListTile extends StatelessWidget {
  const DrugListTile({super.key, required this.drug});

  final Drug drug;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(drug.name),
      subtitle: Text(drug.genericName),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(drug: drug)),
      ),
    );
  }
}
