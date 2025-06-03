import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../service/validators_service.dart';
import '../widget/form/custom_form_field.dart';
import '../widget/form/loading_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  label: 'nom',
                  validators: [
                    RequiredValidator(),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'description',
                  validators: [
                    RequiredValidator(),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _priceController,
                  label: 'prix',
                  validators: [RequiredValidator(), IsNumberValidator()],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _imageController,
                  label: 'image',
                  validators: [
                    RequiredValidator(),
                  ],
                ),
                const SizedBox(height: 24),
                LoadingButton(
                  label: 'Envoyer',
                  isSubmitted: _isSubmitted,
                  onPressed: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    setState(() {
      _isSubmitted = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitted = false;
      });
      return;
    }

    final url = 'https://eemi-39b84a24258a.herokuapp.com/products/';
    final body = json.encode({
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      'image': _imageController.text.trim(),
    });
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    setState(() {
      _isSubmitted = false;
    });

    if (!mounted) return;
    if (response.statusCode == 200) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la modification :\n${response.body}'),
        ),
      );
    }
  }
}
