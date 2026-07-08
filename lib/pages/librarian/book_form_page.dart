import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/book_provider.dart';

class BookFormPage extends StatefulWidget {
  final Book? book; // null if adding a book, contains data if editing

  const BookFormPage({super.key, this.book});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _publisherController;
  late TextEditingController _publishYearController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late bool _isAvailable;
  late TextEditingController _pageCountController;

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    _titleController = TextEditingController(text: book?.title);
    _authorController = TextEditingController(text: book?.author);
    _publisherController = TextEditingController(text: book?.publisher);
    _publishYearController = TextEditingController(text: book?.publishYear);
    _descriptionController = TextEditingController(text: book?.category);
    _categoryController = TextEditingController(text: book?.category);
    _isAvailable = book?.isAvailable ?? true;
    _pageCountController =
        TextEditingController(text: book?.pageCount.toString() ?? '0');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _publishYearController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _pageCountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        id: widget.book?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        author: _authorController.text,
        publisher: _publisherController.text,
        publishYear: _publishYearController.text,
        description: _descriptionController.text,
        coverUrl: 'assets/images/default_book.png',
        isAvailable: _isAvailable,
        category: _categoryController.text,
        bookPath: 'assets/books/default.pdf',
        pageCount: int.tryParse(_pageCountController.text) ?? 0,
      );

      if (widget.book == null) {
        // Add new book
        Provider.of<BookProvider>(context, listen: false).addBook(book);
      } else {
        // Update existing book
        Provider.of<BookProvider>(context, listen: false).updateBook(book);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.book == null
              ? 'Book successfully added'
              : 'Book successfully updated'),
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
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Book title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Author is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _publisherController,
                decoration: const InputDecoration(labelText: 'Publisher'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Publisher is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _publishYearController,
                decoration: const InputDecoration(labelText: 'Publish Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Publish year is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pageCountController,
                decoration: const InputDecoration(labelText: 'Page Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Page count is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Page count must be a number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Page count must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) {
                  setState(() {
                    _isAvailable = value;
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
