import 'package:cep_eczane/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;

  const ProfilePage({super.key, required this.selectedIndex});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F3C51),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Kullanıcı Profili',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(color: Color(0xff1F3C51)),
              ),
              Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('icons/pfp.png'),
                  ))
            ]),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('İsim Soyisim', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Jane Doe',
                      suffixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Email', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'janedoe@gmail.com',
                      suffixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Şifre', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: '**********',
                      suffixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all(const Color(0xff1F3C51)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Kaydet', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}
