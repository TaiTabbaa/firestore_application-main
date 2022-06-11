import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final dateController = TextEditingController();
  final reviewController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference books = FirebaseFirestore.instance.collection('books');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        // padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Book name',
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter book name' : null,
                                controller: nameController,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Book author',
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter book author' : null,
                                controller: authorController,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Book year of publish',
                                ),
                                validator: (val) => val!.isEmpty
                                    ? 'Enter book year of publish'
                                    : null,
                                controller: dateController,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Book rating',
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter Book rating' : null,
                                controller: reviewController,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Book price',
                                ),
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter book price' : null,
                                controller: priceController,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    books.add({
                                      'name': nameController.text,
                                      'author': authorController.text,
                                      'date': dateController.text,
                                      'review': reviewController.text,
                                      'price': priceController.text,
                                    }).then((value) => Navigator.pop(context));
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'MyLibrary',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder(
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final data = snapshot.requireData;
                      return ListView.builder(
                        itemCount: data.size,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Center(
                            child: BookCard(
                              name: data.docs[i]['name'],
                              author: data.docs[i]['author'],
                              date: data.docs[i]['date'],
                              review: data.docs[i]['review'],
                              price: data.docs[i]['price'],
                              selectedDoc: data.docs[i].id,
                            ),
                          );
                        },
                      );
                    }
                  },
                  stream: books.snapshots(),
                ),
              ),
              SizedBox(
                height: 25,
              )
            ],
          ),
          // BookCard(),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String? selectedDoc, name, author, date, review, price;
  const BookCard(
      {Key? key,
      this.selectedDoc,
      this.name,
      this.author,
      this.date,
      this.review,
      this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final authorController = TextEditingController();
    final dateController = TextEditingController();
    final reviewController = TextEditingController();
    final priceController = TextEditingController();

    nameController.text = name!;
    authorController.text = author!;
    dateController.text = date!;
    reviewController.text = review!;
    priceController.text = price!;

    CollectionReference books = FirebaseFirestore.instance.collection('books');

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        author!,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        date!,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber),
                      ),
                      RatingBarIndicator(
                        // rating: 4.5,
                        // rating: double.parse(
                        //     specialPropData.reviewsAvgRating!),
                        rating: double.parse(review!),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 17,
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                // padding: MediaQuery.of(context).viewInsets,
                                child: Container(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Book name',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter book name'
                                            : null,
                                        controller: nameController,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Book author',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter book author'
                                            : null,
                                        controller: authorController,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Book year of publish',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter book year of publish'
                                            : null,
                                        controller: dateController,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Book rating',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter Book rating'
                                            : null,
                                        controller: reviewController,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Book price',
                                        ),
                                        validator: (val) => val!.isEmpty
                                            ? 'Enter book price'
                                            : null,
                                        controller: priceController,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            books.doc(selectedDoc).update({
                                              'name': nameController.text,
                                              'author': authorController.text,
                                              'date': dateController.text,
                                              'review': reviewController.text,
                                              'price': priceController.text,
                                            }).then((value) {
                                              FocusScope.of(context).unfocus();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Book edited successfuly"),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Edit Book',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            books
                                                .doc(selectedDoc)
                                                .delete()
                                                .then((value) {
                                              FocusScope.of(context).unfocus();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Book deleted successfuly"),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Delete Book',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        );
                      });
                },
                child: Text('Edit'),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '\$ $price',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[400]),
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
