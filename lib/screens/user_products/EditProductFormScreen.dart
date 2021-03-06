import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/Data.dart';

import '../../providers/products.dart';

class EditProductFormScreen extends StatefulWidget {
  static const route = "/add-product";

  EditProductFormScreen();

  @override
  _EditProductFormScreenState createState() => _EditProductFormScreenState();
}

class _EditProductFormScreenState extends State<EditProductFormScreen> {
  final _descriptionNode = FocusNode();

  final _imageUrlNode = FocusNode();

  final _imageUrlController = TextEditingController();

  Product product;

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  Map<String, dynamic> _map = {'imageUrl': null};

  void _updateUrl() {
    if (!_imageUrlNode.hasFocus) {
      _map['imageUrl'] = _imageUrlController.text;
      setState(() {});
    }
  }

  Future<void> _showErrorDialogue() async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error occured during sending data to the server!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final productProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      setState(() {
        _isLoading = true;
      });
      if (product == null) {
        try {
          await productProvider.addProduct(Product.fromMap(_map));
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context, true);
        } catch (e) {
          await _showErrorDialogue();
          Navigator.of(context).pop();
        }
      } else {
        _map['id'] = product.id;
        try {
          await productProvider.editProduct(Product.fromMap(_map));
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context, true);
        } catch (e) {
          await _showErrorDialogue();
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  void initState() {
    _imageUrlNode.addListener(_updateUrl);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _imageUrlNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initMap();
  }

  void initMap() {
    product = ModalRoute
        .of(context)
        .settings
        .arguments as Product;
    if (product != null) {
      _map = product.toMap();
      print(_map);
      _map['imageUrl'] = null;
      _imageUrlController.text = product.imageUrl;
      return;
    }
    _map['price'] = '';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(product != null ? 'Edit product' : 'New product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration:
                InputDecoration(labelText: 'Name of the product'),
                initialValue: _map['name'],
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionNode),
                validator: (value) {
                  if (value.isNotEmpty) return null;
                  return 'This field is required';
                },
                onSaved: (value) => _map['name'] = value,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.newline,
                initialValue: _map['description'],
                maxLines: 3,
                focusNode: _descriptionNode,
                validator: (value) {
                  if (value.length > 15) return null;
                  return 'Description must be at least 15 characters long';
                },
                onSaved: (value) => _map['description'] = value,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                initialValue: _map['price'].toString(),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_imageUrlNode),
                validator: (value) {
                  if (value.isNotEmpty && double.parse(value) >= 0)
                    return null;
                  return 'Price must not be negative or empty';
                },
                onSaved: (value) => _map['price'] = double.parse(value),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 8, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black)),
                    width: 100,
                    height: 100,
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Field is empty'))
                        : Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      focusNode: _imageUrlNode,
                      onFieldSubmitted: (_) => _saveForm,
                      validator: (value) {
                        if (RegExp(
                            '(\b(https?|ftp|file)://)?[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]')
                            .hasMatch(value)) return null;
                        return 'Not a valid URL';
                      },
                      onSaved: (value) => _map['imageUrl'] = value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
