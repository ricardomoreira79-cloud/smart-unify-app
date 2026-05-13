import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'add_device_page.dart';
import 'video_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<void> toggleDevice(String id, bool currentStatus) async {
    await Supabase.instance.client
        .from('devices')
        .update({'status': !currentStatus})
        .eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartUnify Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('devices')
            .stream(primaryKey: ['id'])
            .eq('user_id', userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dispositivos: ${snapshot.error}'),
            );
          }

          final devices = snapshot.data ?? [];

          if (devices.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum dispositivo cadastrado.\nAdicione um novo dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final id = device['id'] as String;
              final name = device['name'] as String;
              final type = device['type'] as String;
              final status = device['status'] as bool? ?? false;
              final icon = type == 'iCSee' ? Icons.camera : Icons.power;

              return ListTile(
                leading: Icon(icon),
                title: Text(name),
                subtitle: Text(type),
                onTap: () {
                  if (type == 'Tuya/SmartLife') {
                    toggleDevice(id, status);
                  } else {
                    // Câmera
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          deviceName: name,
                          streamUrl: device['rtsp_url'] as String,
                        ),
                      ),
                    );
                  }
                },
                trailing: type == 'Tuya/SmartLife'
                    ? Switch(
                        value: status,
                        onChanged: (value) => toggleDevice(id, status),
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddDevicePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

