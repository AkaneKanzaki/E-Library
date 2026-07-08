import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/book_provider.dart';

class FormBukuPage extends StatefulWidget {
  final Book? book; // null jika tambah buku, berisi data jika edit buku

  const FormBukuPage({super.key, this.book});

  @override
  State<FormBukuPage> createState() => _FormBukuPageState();
}

class _FormBukuPageState extends State<FormBukuPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _penulisController;
  late TextEditingController _penerbitController;
  late TextEditingController _tahunTerbitController;
  late TextEditingController _deskripsiController;
  late TextEditingController _kategoriController;
  late bool _tersedia;
  late TextEditingController _jumlahHalamanController;

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    _judulController = TextEditingController(text: book?.judul);
    _penulisController = TextEditingController(text: book?.penulis);
    _penerbitController = TextEditingController(text: book?.penerbit);
    _tahunTerbitController = TextEditingController(text: book?.tahunTerbit);
    _deskripsiController = TextEditingController(text: book?.kategori);
    _kategoriController = TextEditingController(text: book?.kategori);
    _tersedia = book?.tersedia ?? true;
    _jumlahHalamanController =
        TextEditingController(text: book?.jumlahHalaman.toString() ?? '0');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    _tahunTerbitController.dispose();
    _deskripsiController.dispose();
    _kategoriController.dispose();
    _jumlahHalamanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        id: widget.book?.id ?? DateTime.now().toString(),
        judul: _judulController.text,
        penulis: _penulisController.text,
        penerbit: _penerbitController.text,
        tahunTerbit: _tahunTerbitController.text,
        deskripsi: _deskripsiController.text,
        coverUrl: 'assets/images/default_book.png',
        tersedia: _tersedia,
        kategori: _kategoriController.text,
        bookPath: 'assets/books/default.pdf',
        jumlahHalaman: int.tryParse(_jumlahHalamanController.text) ?? 0,
      );

      if (widget.book == null) {
        // Tambah buku baru
        Provider.of<BookProvider>(context, listen: false).addBook(book);
      } else {
        // Update buku yang ada
        Provider.of<BookProvider>(context, listen: false).updateBook(book);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.book == null
              ? 'Book successfully added'
              : 'Buku berhasil diperbarui'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul buku harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penulis harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penerbitController,
                decoration: const InputDecoration(labelText: 'Publisher'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penerbit harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tahunTerbitController,
                decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tahun terbit harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahHalamanController,
                decoration: const InputDecoration(labelText: 'Jumlah Halaman'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah halaman harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah halaman harus berupa angka';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Jumlah halaman harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                value: _tersedia,
                onChanged: (bool value) {
                  setState(() {
                    _tersedia = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                    widget.book == null ? 'Add Book' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
