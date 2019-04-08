import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReadEvents {

   Query query = Firestore.instance.collection('Events').limit(999);
 



}