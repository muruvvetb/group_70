import 'package:cep_eczane/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();

  // @override
  // State<HomePage> createState() => _HomePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F3C51),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text(
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
                decoration: BoxDecoration(color: const Color(0xff1F3C51)),
              ),
              Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 2 - 80,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('icons/pfp.png'),
                  ))
            ]),
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İsim Soyisim', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Jane Doe',
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Email', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  TextField(
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'janedoe@gmail.com',
                      suffixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Şifre', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: '**********',
                      suffixIcon: Icon(Icons.edit),
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
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xff1F3C51)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: const Column(
                      children: [
                        Text('Kaydet', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
