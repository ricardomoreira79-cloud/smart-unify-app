import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  Future<void> toggleDevice(String id, bool currentStatus) async {
    await FirebaseFirestore.instance.collection('devices').doc(id).update({
      'status': !currentStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final userName = user?.displayName ?? user?.email ?? 'Usuário';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Olá, $userName! 👋',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('devices')
                  .where('user_id', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar dispositivos: ${snapshot.error}'),
                  );
                }

                final devices = snapshot.data?.docs
                        .map((doc) => {
                              'id': doc.id,
                              ...doc.data(),
                            })
                        .toList() ??
                    [];

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
                    final name = device['name'] as String? ?? 'Dispositivo';
                    final type = device['type'] as String? ?? 'Desconhecido';
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
          ),
        ],
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
