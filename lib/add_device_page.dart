import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrand;
  final _nameController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _ipController = TextEditingController();
  final _rtspController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userId = Supabase.instance.client.auth.currentUser!.id;
    final name = _nameController.text.trim();

    Map<String, dynamic> deviceData = {
      'user_id': userId,
      'name': name,
      'type': _selectedBrand,
    };

    if (_selectedBrand == 'Tuya/SmartLife') {
      deviceData['device_id'] = _deviceIdController.text.trim();
      deviceData['status'] = false; // Default status for switches
    } else if (_selectedBrand == 'iCSee') {
      deviceData['ip'] = _ipController.text.trim();
      deviceData['rtsp_url'] = _rtspController.text.trim();
    }

    try {
      await Supabase.instance.client.from('devices').insert(deviceData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo cadastrado com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar dispositivo: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    _ipController.dispose();
    _rtspController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Dispositivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedBrand,
                decoration: const InputDecoration(
                  labelText: 'Marca do Dispositivo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Tuya/SmartLife',
                    child: Text('Tuya/SmartLife'),
                  ),
                  DropdownMenuItem(
                    value: 'iCSee',
                    child: Text('iCSee'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione uma marca';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Dispositivo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome do dispositivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_selectedBrand == 'Tuya/SmartLife') ...[
                TextFormField(
                  controller: _deviceIdController,
                  decoration: const InputDecoration(
                    labelText: 'Device ID (Cloud)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite o Device ID';
                    }
                    return null;
                  },
                ),
              ] else if (_selectedBrand == 'iCSee') ...[
                TextFormField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço IP/Host',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite o endereço IP/Host';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rtspController,
                  decoration: const InputDecoration(
                    labelText: 'URL RTSP',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite a URL RTSP';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDevice,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
