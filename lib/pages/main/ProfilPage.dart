import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

//ini diganti menjadi isian sebelumnya (tidak kosong)
  String _photoUrl = "";
  String _nama="";

  //email nanti diganti menjadi tidak dapat diedit
  String _email="";

 // Controller untuk mengelola input nama
  TextEditingController _nameController = TextEditingController();

 @override
  void initState() {
    super.initState();
    _nameController.text = _nama;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menampilkan gambar profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_photoUrl),
            ),
            SizedBox(height: 10),

            // Input untuk mengubah nama
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
              ),
            ),
            SizedBox(height: 5),

            TextFormField(
              initialValue: _email, 
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              readOnly: true,  // Membuat input tidak dapat diedit
              enabled: false, // Membuat input tidak dapat diaktifkan
            ),
            SizedBox(height: 5),


            TextFormField(
              initialValue: _photoUrl,  
              decoration: InputDecoration(
                labelText: 'Photo URL',
              ),
              onChanged: (value) {

                // Tambahkan logika jika perlu ketika nilai berubah
                // Misalnya, Anda dapat memperbarui tampilan gambar di halaman profil


              },
            ),


            
            ElevatedButton(
              onPressed: () {

                // Aksi saat tombol ditekan (simpan perubahan disini)
                
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
