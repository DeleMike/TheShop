import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

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

  var _isInit = true;
  var _initVals = {'title': '', 'description': '', 'price': '', 'imageUrl': ''};

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initVals = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text =  _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
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
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if(_editedProduct.id != null) {
      //we are editing product
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }else{
       Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
   
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Products'), actions: [
        IconButton(
          onPressed: _saveForm,
          icon: Icon(Icons.save),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initVals['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: val,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide add a title';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: _initVals['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (val) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(val),
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide a price for the product';
                  }

                  if (double.tryParse(val) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.tryParse(val) == 0) {
                    return 'Please enter an amount greater than 0';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: _initVals['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                onSaved: (val) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: val,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite);
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please provide add a description';
                  }
                  if (val.length < 10) {
                    return 'Should be at least 10 characters';
                  } else {
                    return null;
                  }
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
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: val,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please provide add an image URL';
                        }
                        if (!val.startsWith('http') &&
                            !val.startsWith('https')) {
                          return 'Please provide a URL';
                        } else {
                          return null;
                        }
                      },
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
