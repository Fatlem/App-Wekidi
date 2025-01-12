import 'package:flutter/material.dart';  
import 'package:shared_preferences/shared_preferences.dart';  
import '../services/api_service.dart';  
  
class LoginScreen extends StatefulWidget {  
  const LoginScreen({super.key});  
  
  @override  
  State<LoginScreen> createState() => _LoginScreenState();  
}  
  
class _LoginScreenState extends State<LoginScreen> {  
  final _usernameController = TextEditingController();  
  final _passwordController = TextEditingController();  
  final ApiService _apiService = ApiService();  
  bool _isLoading = false; // To manage loading state  
  
  void _login() async {  
    final username = _usernameController.text.trim();  
    final password = _passwordController.text.trim();  
  
    if (username.isEmpty || password.isEmpty) {  
      ScaffoldMessenger.of(context).showSnackBar(  
        const SnackBar(content: Text('Harap isi semua kolom')),  
      );  
      return;  
    }  
  
    setState(() {  
      _isLoading = true; // Start loading  
    });  
  
    try {  
      final response = await _apiService.loginUser(username, password);  
  
      // Simpan userId, role, username, dan password ke SharedPreferences  
      final prefs = await SharedPreferences.getInstance();  
      await prefs.setInt('user_id', response['userId']);  
      await prefs.setString('role', response['role']);  
      await prefs.setString('username', username); // Simpan username  
      await prefs.setString('password', password); // Simpan password (jika diperlukan)  
  
      // Tampilkan pesan sukses  
      ScaffoldMessenger.of(context).showSnackBar(  
        const SnackBar(content: Text('Login berhasil')),  
      );  
  
      // Navigasi ke halaman dashboard  
      Navigator.pushReplacementNamed(context, '/dashboard');  
    } catch (e) {  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(content: Text('Gagal login: ${e.toString()}')),  
      );  
    } finally {  
      setState(() {  
        _isLoading = false; // Stop loading  
      });  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: const Text('Login', style: TextStyle(fontFamily: 'DynaPuff')),  
        automaticallyImplyLeading: false, // Remove back button  
      ),  
      body: Container(  
        decoration: BoxDecoration(  
          gradient: LinearGradient(  
            begin: Alignment.topCenter,  
            end: Alignment.bottomCenter,  
            colors: [  
              Color(0xFFF2A65A), // Light orange for the top  
              Color(0xFFD76D2E), // Deeper orange for the middle  
              Color(0xFF7B3E19), // Brown for the bottom  
            ],  
          ),  
        ),  
        child: Center( // Center the content  
          child: Padding(  
            padding: const EdgeInsets.all(16.0),  
            child: Column(  
              mainAxisSize: MainAxisSize.min, // Minimize the height of the column  
              crossAxisAlignment: CrossAxisAlignment.stretch,  
              children: [  
                TextField(  
                  controller: _usernameController,  
                  decoration: const InputDecoration(  
                    labelText: 'Username',  
                    labelStyle: TextStyle(color: Colors.white), // White label  
                    enabledBorder: UnderlineInputBorder(  
                      borderSide: BorderSide(color: Colors.white), // White underline  
                    ),  
                    focusedBorder: UnderlineInputBorder(  
                      borderSide: BorderSide(color: Colors.white), // White underline on focus  
                    ),  
                  ),  
                  style: const TextStyle(color: Colors.white, fontFamily: 'DynaPuff'), // White text with DynaPuff font  
                ),  
                const SizedBox(height: 16),  
                TextField(  
                  controller: _passwordController,  
                  decoration: const InputDecoration(  
                    labelText: 'Password',  
                    labelStyle: TextStyle(color: Colors.white), // White label  
                    enabledBorder: UnderlineInputBorder(  
                      borderSide: BorderSide(color: Colors.white), // White underline  
                    ),  
                    focusedBorder: UnderlineInputBorder(  
                      borderSide: BorderSide(color: Colors.white), // White underline on focus  
                    ),  
                  ),  
                  obscureText: true,  
                  style: const TextStyle(color: Colors.white, fontFamily: 'DynaPuff'), // White text with DynaPuff font  
                ),  
                const SizedBox(height: 32),  
                ElevatedButton(  
                  onPressed: _isLoading ? null : _login, // Disable button while loading  
                  child: _isLoading  
                      ? const CircularProgressIndicator() // Show loading indicator  
                      : const Text('Login', style: TextStyle(fontFamily: 'DynaPuff')), // DynaPuff font  
                ),  
                const SizedBox(height: 16),  
                // Tombol untuk navigasi ke halaman register  
                TextButton(  
                  onPressed: () {  
                    Navigator.pushNamed(context, '/register'); // Ganti dengan route yang sesuai  
                  },  
                  child: const Text(  
                    'Belum punya akun? Daftar di sini',  
                    style: TextStyle(color: Colors.white, fontFamily: 'DynaPuff'), // White text with DynaPuff font  
                  ),  
                ),  
              ],  
            ),  
          ),  
        ),  
      ),  
    );  
  }  
}  
