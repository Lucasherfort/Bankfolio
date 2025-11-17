import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/asset.dart';

class PeaPage extends StatefulWidget {
  final Account account; // PEA existant
  const PeaPage({super.key, required this.account});

  @override
  State<PeaPage> createState() => _PeaPageState();
}

class _PeaPageState extends State<PeaPage> {
  late List<Asset> assets;

  @override
  void initState() {
    super.initState();
    assets = widget.account.assets ?? [];
  }

  @override
  Widget build(BuildContext context) {
    double totalInvested = assets.fold(0, (sum, a) => sum + a.totalValue);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total investi : ${totalInvested.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${asset.name} (${asset.type.name})'),
                    subtitle: Text(
                        'Quantité : ${asset.quantity} • PRU : ${asset.pru.toStringAsFixed(2)} €'),
                    trailing: Text('Total : ${asset.totalValue.toStringAsFixed(2)} €'),
                    onTap: () => _editAsset(asset),
                    onLongPress: () => _deleteAsset(asset),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAsset,
        child: const Icon(Icons.add),
      ),
    );
  }

  // _addAsset, _editAsset, _deleteAsset identiques à la version précédente
  // après chaque modification, on met à jour widget.account.assets
  void _addAsset() {
    String name = '';
    AssetType? type;
    String quantity = '';
    String pru = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Ajouter un actif'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<AssetType>(
                    value: type,
                    hint: const Text('Type d’actif'),
                    isExpanded: true,
                    items: AssetType.values.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t.name),
                      );
                    }).toList(),
                    onChanged: (value) => setStateDialog(() => type = value),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nom'),
                    onChanged: (value) => name = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Quantité'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => quantity = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'PRU'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => pru = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (name.isNotEmpty && type != null && quantity.isNotEmpty && pru.isNotEmpty) {
                      setState(() {
                        final asset = Asset(
                          name: name,
                          type: type!,
                          quantity: double.parse(quantity.replaceAll(',', '.')),
                          pru: double.parse(pru.replaceAll(',', '.')),
                        );
                        assets.add(asset);
                        widget.account.assets = assets;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // _editAsset et _deleteAsset aussi doivent mettre à jour widget.account.assets après modification
  void _editAsset(Asset asset) {
    String name = asset.name;
    AssetType type = asset.type;
    String quantity = asset.quantity.toString();
    String pru = asset.pru.toString();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Modifier un actif'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<AssetType>(
                    value: type,
                    isExpanded: true,
                    items: AssetType.values.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t.name),
                      );
                    }).toList(),
                    onChanged: (value) => setStateDialog(() => type = value!),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nom'),
                    controller: TextEditingController(text: name),
                    onChanged: (value) => name = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Quantité'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController(text: quantity),
                    onChanged: (value) => quantity = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'PRU'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: TextEditingController(text: pru),
                    onChanged: (value) => pru = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler')),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      asset.name = name;
                      asset.type = type;
                      asset.quantity = double.parse(quantity.replaceAll(',', '.'));
                      asset.pru = double.parse(pru.replaceAll(',', '.'));
                      widget.account.assets = assets;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAsset(Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l’actif'),
        content: Text('Voulez-vous vraiment supprimer "${asset.name}" ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  assets.remove(asset);
                  widget.account.assets = assets;
                });
                Navigator.pop(context);
              },
              child: const Text('Supprimer')),
        ],
      ),
    );
  }
}