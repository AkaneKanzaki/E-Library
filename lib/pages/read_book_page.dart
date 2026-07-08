import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class ReadBookPage extends StatefulWidget {
  final Book book;
  
  const ReadBookPage({super.key, required this.book});
  
  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage> {
  String? _localPath;
  bool _isLoading = true;
  PDFViewController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  int _initialPage = 0;
  
  @override
  void initState() {
    super.initState();
    _loadPDF();
  }
  
  Future<void> _loadPDF() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPage = prefs.getInt('last_page_${widget.book.id}') ?? 0;

      final bytes = await rootBundle.load(widget.book.bookPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.book.id}.pdf');
      
      await file.writeAsBytes(bytes.buffer.asUint8List());
      
      setState(() {
        _initialPage = lastPage;
        _currentPage = lastPage + 1;
        _localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading PDF: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.judul),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _localPath == null
          ? const Center(child: Text('Failed to load PDF'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Halaman $_currentPage dari ${_totalPages == 0 ? '?' : _totalPages}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: PDFView(
                    filePath: _localPath!,
                    defaultPage: _initialPage,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onViewCreated: (PDFViewController pdfController) {
                      _pdfController = pdfController;
                    },
                    onPageChanged: (int? page, int? total) async {
                      if (mounted && page != null && total != null) {
                        setState(() {
                          _currentPage = page + 1;
                          _totalPages = total;
                        });
                        
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('last_page_${widget.book.id}', page);
                      }
                    },
                    onError: (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentPage > 1
                            ? () {
                                _pdfController?.setPage(_currentPage - 2);
                              }
                            : null,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: _totalPages == 0 || _currentPage < _totalPages
                            ? () {
                                _pdfController?.setPage(_currentPage);
                              }
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}