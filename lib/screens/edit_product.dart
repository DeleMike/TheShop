import 'package:flutter/material.dart';

import '../models/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  //to move from one field form to the other
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      isFavorite: false);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _formKey.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      id: DateTime.now().toString(),
                      title: val,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      id: DateTime.now().toString(),
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(val),
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                onSaved: (val) {
                  _editedProduct = Product(
                      id: DateTime.now().toString(),
                      title: _editedProduct.title,
                      description: val,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Enter a URL',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ClipRRect(
                            child: Image.network(
                              _imageUrlController.text,
                              width: double.infinity,
                              repeat: ImageRepeat.repeat,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (val) {
                        _editedProduct = Product(
                            id: DateTime.now().toString(),
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: val,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Container(
                width: 120,
                height: 56,
                child: FittedBox(
                  child: ElevatedButton.icon(
                    onPressed: _saveForm,
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
