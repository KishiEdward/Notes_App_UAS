import 'package:flutter/material.dart';
import 'package:notesapp/pages/register_page.dart';
import 'package:notesapp/services/auth_service.dart';
import 'package:notesapp/pages/home_page.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // controller tetap ada agar textfield bisa diisi
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // variable untuk liat pw
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Icon(Icons.lock, size: 100, color: Colors.blueAccent),
                const SizedBox(height: 20),
                const Text(
                  "Halaman login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const Text(
                  "Silakan masukkan email Anda untuk melanjutkan.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),

                // input email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // input pw
                TextField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // logic untuk liat pw
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "Lupa password?",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 20),

                // tombol login di sini tanpa logic
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon isi email dan password'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    try {
                      final user = await AuthService().signInWithEmail(email, password);
                      if (user != null && context.mounted) {
                        // Tampilkan notifikasi sukses login
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login berhasil! Selamat datang.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      setState(() => _isLoading = false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login gagal: ${e.toString().replaceAll('Exception: ', '')}'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text("Login", style: TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      final user = await AuthService().signInWithGoogle();
                      if (user != null) {
                        if (context.mounted) {
                          // Tampilkan notifikasi sukses login
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login berhasil! Selamat datang.'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false,
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login dibatalkan oleh user'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.g_mobiledata_rounded,
                    color: Colors.grey,
                    size: 24,
                  ),
                  label: const Text(
                    'Login dengan Google',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
