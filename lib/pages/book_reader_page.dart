import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookReaderPage extends StatefulWidget {
  final Book book;
  
  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  String? _localPath;
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      final bytes = await rootBundle.load(widget.book.bookPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.book.id}.pdf');
      
      await file.writeAsBytes(bytes.buffer.asUint8List());
      setState(() {
        _localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat PDF: $e')),
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
          ? const Center(child: Text('Gagal memuat PDF'))
          : Column(
              children: [
                // Indikator halaman
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Halaman $_currentPage dari $_totalPages',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                // PDF Viewer
                Expanded(
                  child: PDFView(
                    filePath: _localPath!,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onRender: (pages) {
                      if (pages != null && mounted) {
                        setState(() {
                          _totalPages = pages;
                        });
                      }
                    },
                    onViewCreated: (controller) {
                      _pdfController = controller;
                    },
                    onPageChanged: (page, total) {
                      if (page != null && mounted) {
                        setState(() {
                          _currentPage = page + 1;
                        });
                      }
                    },
                    onError: (error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      }
                    },
                    onPageError: (page, error) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error pada halaman $page: $error')),
                        );
                      }
                    },
                  ),
                ),
                // Navigasi halaman
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
                        child: const Text('Sebelumnya'),
                      ),
                      ElevatedButton(
                        onPressed: _currentPage < _totalPages
                            ? () {
                                _pdfController?.setPage(_currentPage);
                              }
                            : null,
                        child: const Text('Selanjutnya'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
} 