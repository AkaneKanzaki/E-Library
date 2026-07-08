import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';

class FormPenggunaPage extends StatefulWidget {
  final User? user;

  const FormPenggunaPage({super.key, this.user});

  @override
  State<FormPenggunaPage> createState() => _FormPenggunaPageState();
}

class _FormPenggunaPageState extends State<FormPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _namaController;
  late TextEditingController _passwordController;
  String _selectedRole = 'siswa';

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _emailController = TextEditingController(text: user?.email);
    _namaController = TextEditingController(text: user?.nama);
    _passwordController = TextEditingController();
    if (user != null) {
      _selectedRole = user.role;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Tambah Pengguna' : 'Edit Pengguna'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email harus diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (widget.user == null) ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus diisi';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'siswa', child: Text('Siswa')),
                  DropdownMenuItem(
                      value: 'pustakawan', child: Text('Pustakawan')),
                  DropdownMenuItem(
                      value: 'administrator', child: Text('Administrator')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.user == null
                    ? 'Tambah Pengguna'
                    : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: widget.user?.password ?? _passwordController.text,
        nama: _namaController.text,
        role: _selectedRole,
      );

      if (widget.user == null) {
        // Tambah pengguna baru
        Provider.of<AuthProvider>(context, listen: false)
            .addUser(user, _passwordController.text);
      } else {
        // Update pengguna yang ada
        Provider.of<AuthProvider>(context, listen: false).updateUser(user);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.user == null
              ? 'Pengguna berhasil ditambahkan'
              : 'Pengguna berhasil diperbarui'),
        ),
      );
    }
  }
}
