import 'package:flutter/material.dart';
import 'package:cep_eczane/services/notification_helper.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  Future<List<String>> _loadNotifications() async {
    return await _notificationHelper.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: _notificationHelper.clearNotifications)
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _loadNotifications(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<String> notifications = snapshot.data ?? [];
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(child: ListTile(title: Text(notifications[index])));
              },
            );
          }
        },
      ),
    );
  }
}
