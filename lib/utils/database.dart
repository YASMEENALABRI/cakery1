import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Authenticate User
  static Future<bool> authenticateUser(String name, String password) async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('user')
        .orderByChild('name')
        .equalTo(name)
        .once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;
      for (var user in userData.values) {
        if (user['password'] == password) {
          return true; // Login successful
        }
      }
    }
    return false; // Login failed
  }

  // Authenticate Admin
  static Future<bool> authenticateAdmin(String name, String password) async {
    DatabaseEvent event = await FirebaseDatabase.instance
        .ref('admins')
        .orderByChild('name')
        .equalTo(name)
        .once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> adminData = event.snapshot.value as Map<dynamic, dynamic>;
      for (var admin in adminData.values) {
        if (admin['password'] == password) {
          return true; // Login successful
        }
      }
    }
    return false; // Login failed
  }

  // Add User
  Future<void> addUser(Map<String, dynamic> userData) async {
    await _db.child('user').push().set(userData);
  }

  // Add Admin
  Future<void> addAdmin(Map<String, dynamic> adminData) async {
    await _db.child('admins').push().set(adminData);
  }

  // Add Chef
  Future<void> addChef(Map<String, dynamic> chefData) async {
    await _db.child('chefs').push().set(chefData);
  }

  // Retrieves
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _db.child('user').onValue.map((event) {
      Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return userData.entries.map((entry) {
        var user = Map<String, dynamic>.from(entry.value as Map);
        user['id'] = entry.key; // Save Firebase key as 'id'
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getAdmins() {
    return _db.child('admins').onValue.map((event) {
      Map<dynamic, dynamic> adminData = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return adminData.entries.map((entry) {
        var admin = Map<String, dynamic>.from(entry.value as Map);
        admin['id'] = entry.key; // Save Firebase key as 'id'
        return admin;
      }).toList();
    });
  }

  // Retrieve Chefs
  Stream<List<Map<String, dynamic>>> getChefs() {
    return _db.child('chefs').onValue.map((event) {
      Map<dynamic, dynamic> chefData = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return chefData.entries.map((entry) {
        var chef = Map<String, dynamic>.from(entry.value as Map);
        chef['id'] = entry.key; // Save Firebase key as 'id'
        return chef;
      }).toList();
    });
  }

  // Updates
  Future<void> updateUser(String id, Map<String, dynamic> userData) async {
    await _db.child('user').child(id).update(userData);
  }

  Future<void> updateAdmin(String id, Map<String, dynamic> adminData) async {
    await _db.child('admins').child(id).update(adminData);
  }

  // Update Chef
  Future<void> updateChef(String id, Map<String, dynamic> chefData) async {
    await _db.child('chefs').child(id).update(chefData);
  }

  // Deletes
  Future<void> deleteUser(String id) async {
    await _db.child('user').child(id).remove();
  }

  Future<void> deleteAdmin(String id) async {
    await _db.child('admins').child(id).remove();
  }

  // Delete Chef
  Future<void> deleteChef(String id) async {
    await _db.child('chefs').child(id).remove();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    // Implement password reset functionality
  }
}