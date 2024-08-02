import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadImage();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && !user.isAnonymous) {
        _loadUserProfile();
      }
    });
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAnonymousWarningDialog();
      });
    }
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        if (mounted) {
          setState(() {
            _nameController.text = userDoc['name'] ?? '';
            _emailController.text = user.email ?? '';
          });
        }
      } else {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
        });
        if (mounted) {
          setState(() {
            _nameController.text = user.displayName ?? '';
            _emailController.text = user.email ?? '';
          });
        }
      }
    }
  }

  Future<void> _loadImage() async {
    _prefs = await SharedPreferences.getInstance();
    String? imagePath = _prefs.getString('profile_image');
    if (imagePath != null) {
      if (mounted) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
      _prefs.setString('profile_image', pickedFile.path);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final fileName = path.basename(_image!.path);
      // Resmi yükleme işlemi buraya eklenebilir
    }
  }

  void _toggleEditingName() {
    setState(() {
      _isEditingName = !_isEditingName;
    });
  }

  void _toggleEditingEmail() {
    setState(() {
      _isEditingEmail = !_isEditingEmail;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _convertAnonymousUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.currentUser!
          .linkWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': email,
      });

      if (mounted) {
        setState(() {
          _nameController.text = _nameController.text.trim();
          _emailController.text = email;
        });
      }

      _showSuccessDialog("Hesabınız başarıyla kaydedildi!");
    } on FirebaseAuthException catch (e) {
      print("Hata: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: ${e.message}")),
        );
      }
    }
  }

  void _saveProfile() {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      _convertAnonymousUser(
          _emailController.text.trim(), _newPasswordController.text.trim());
    } else {
      _showSuccessDialog("Hesabınız başarıyla güncellendi!");
    }
  }

  void _showAnonymousWarningDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Dikkat',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Bir sonraki girişte verilerinizi kaybetmemek için kayıt olun!',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Color.fromARGB(255, 133, 187, 222), // Yazı rengi
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Başarılı',
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Color.fromARGB(255, 133, 187, 222), // Yazı rengi
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1F3C51),
        title: const Text(
          'Kullanıcı Profili',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(color: Color(0xff1F3C51)),
                ),
                Positioned(
                  top: 25,
                  left: MediaQuery.of(context).size.width / 2 - 75,
                  child: GestureDetector(
                    onTap: _showImageOptions,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      backgroundColor: _image == null ? Colors.grey : null,
                      child: _image == null
                          ? Text(
                              _nameController.text.isNotEmpty
                                  ? _nameController.text[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.white),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(48, 200, 197, 197),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            enabled: _isEditingName,
                            decoration: InputDecoration(
                              hintText: 'Ad Soyad',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 0.0, 16.0),
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isEditingName ? Icons.check : Icons.edit),
                          onPressed: _toggleEditingName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(48, 200, 197, 197),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            enabled: _isEditingEmail,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 0.0, 16.0),
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(_isEditingEmail ? Icons.check : Icons.edit),
                          onPressed: _toggleEditingEmail,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(48, 200, 197, 197),
                    ),
                    child: TextField(
                      controller: _currentPasswordController,
                      obscureText: !_isCurrentPasswordVisible,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'Mevcut Şifre',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isCurrentPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCurrentPasswordVisible =
                                  !_isCurrentPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(48, 200, 197, 197),
                    ),
                    child: TextField(
                      controller: _newPasswordController,
                      obscureText: !_isNewPasswordVisible,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'Yeni Şifre',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _logout,
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('Çıkış Yap',
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _saveProfile();
                          _uploadImage();
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff1F3C51)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('Kaydet',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
