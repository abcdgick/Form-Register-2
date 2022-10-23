import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum Pil { Mahasiswa, Umum }

class PemesananTiket extends StatefulWidget {
  const PemesananTiket({Key? key}) : super(key: key);

  @override
  _PemesananTiketState createState() => _PemesananTiketState();
}

class _PemesananTiketState extends State<PemesananTiket> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController no = TextEditingController();
  TextEditingController jml = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  int harga = 0;
  int total = 0;
  int diskon = 0;

  String? selectedTujuan;
  String? formattedDate;

  Pil? _pil = Pil.Umum;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/c/cd/Logo_Pesona_Indonesia_%28Kementerian_Pariwisata%29.png"),
                      fit: BoxFit.cover)),
              child: null),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('About Me'),
            onTap: () {
              pindah();
            },
          )
        ],
      )),
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu, color: Colors.white),
                  tooltip: "Navigation Menu");
            },
          ),
          centerTitle: true,
          title: const Text("Pemesanan Travel YJS Trans",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              tooltip: "Search",
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              tooltip: "More",
            )
          ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    textFormHuruf(const Icon(Icons.account_circle), "Nama",
                        "Tolong inputkan nama anda", nama),
                    sep(15),
                    textFormAngka(const Icon(Icons.phone), "Nomor Handphone",
                        "Tolong inputkan nomor handphone anda", no, 12),
                    sep(5),
                    textFormTanggal(
                        const Icon(Icons.event),
                        "Tanggal Berangkat",
                        "Mohon inputkan tanggal keberangkatan anda",
                        dateInput),
                    sep(15),
                    fieldDropDown(
                        const Icon(Icons.airport_shuttle),
                        "Tujuan Berangkat",
                        "Mohon pilih salah satu tujuan keberangkatan"),
                    sep(15),
                    textFormAngka(
                        const Icon(Icons.confirmation_num),
                        "Jumlah Tiket",
                        "Tolong inputkan jumlah tiket yang ingin dipesan",
                        jml,
                        3),
                    radioBtnPil(),
                    sep(15),
                    Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black),
                              child: const Text('Pesan'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  hitungHarga();
                                  munculDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Mohon isi semua data dengan benar')));
                                }
                              },
                            ),
                            const SizedBox(width: 70),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black),
                              child: const Text('Clear'),
                              onPressed: () {
                                reset();
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About Me',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (int index) {
            switch (index) {
              case 1:
                pindah();
                break;
            }
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }

  Widget textFormHuruf(
      Icon icon, String label, String empty, TextEditingController controller) {
    return TextFormField(
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]+"))],
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 34, 116, 58),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: icon,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10))),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return empty;
        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return "Tolong inputkan huruf (baik kecil maupun besar) saja";
        }
        return null;
      },
    );
  }

  Widget textFormAngka(Icon icon, String label, String empty,
      TextEditingController controller, int maxNum) {
    return TextFormField(
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
      onChanged: (value) => setState(() {}),
      maxLength: maxNum,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 34, 116, 58),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: icon,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10))),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return empty;
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          return "Tolong inputkan huruf (baik kecil maupun besar) saja";
        }
        return null;
      },
    );
  }

  Widget textFormTanggal(
      Icon icon, String label, String empty, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2023));
        if (pickedDate != null) {
          formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
          setState(() {
            controller.text = formattedDate!;
          });
        }
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 34, 116, 58),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: icon,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    controller.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value!.isEmpty) {
          return empty;
        }
        return null;
      },
    );
  }

  Widget fieldDropDown(Icon icon, String label, String empty) {
    return DropdownButtonFormField<String>(
      value: selectedTujuan,
      items: <String>['Blora', 'Sarinah', 'Blok-M'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (tujuan) => setState(() {
        selectedTujuan = tujuan!;
      }),
      validator: (value) => value == null ? empty : null,
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 34, 116, 58),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none),
          prefixIcon: icon,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget radioBtnPil() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: Pil.Umum,
          groupValue: _pil,
          onChanged: (Pil? value) => setState(() {
            _pil = value;
          }),
        ),
        const Text("Umum", style: TextStyle(color: Colors.white)),
        const SizedBox(
          width: 100,
        ),
        Radio(
          value: Pil.Mahasiswa,
          groupValue: _pil,
          onChanged: (Pil? value) => setState(() {
            _pil = value;
          }),
        ),
        const Text("Mahasiswa", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget sep(double h) {
    return SizedBox(height: h);
  }

  void reset() {
    _formKey.currentState?.reset();
    nama.clear();
    no.clear();
    jml.clear();
    dateInput.clear();
    harga = 0;
    total = 0;
    setState(() {});
  }

  void hitungHarga() {
    switch (selectedTujuan) {
      case "Blora":
        harga = 100000;
        break;
      case "Sarinah":
        harga = 120000;
        break;
      case "Blok-M":
        harga = 130000;
        break;
      default:
    }

    total = harga * int.parse(jml.text);
    if (_pil.toString() == "Pil.Mahasiswa") {
      diskon = 10000 * int.parse(jml.text);
      total = total - diskon;
    }
  }

  void munculDialog() {
    String pil;
    if (_pil.toString() == "Pil.Umum")
      pil = "Umum";
    else
      pil = "Mahasiswa";
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Detail Pemesanan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Nama: ${nama.text}"),
                  Text("Nomor Handphone: ${no.text}"),
                  Text("Tanggal Berangkat: $formattedDate"),
                  Text("Pilihan Tujuan: $selectedTujuan"),
                  Text("Jumlah Tiket: ${jml.text}"),
                  Text("Penumpang: $pil"),
                  sep(10),
                  Text("Harga Tiket: ${CurrencyFormat.convertToIdr(harga, 2)}"),
                  Text("Diskon: ${CurrencyFormat.convertToIdr(diskon, 2)}"),
                  Text("Total Bayar: ${CurrencyFormat.convertToIdr(total, 2)}"),
                ],
              ),
            ));
  }

  void pindah() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AboutMe(),
        ));
  }
}

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.purple,
          centerTitle: true,
          title: const Text("About Me",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Image(
                    image: NetworkImage(
                        "https://media.tenor.com/hFF7PF8xvN4AAAAi/neco-arc-taunt.gif"),
                    width: 250,
                    height: 180),
                SizedBox(height: 40),
                Text(
                  "Created by Jonathan Krisna - 2020130017",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ],
        ));
  }
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}
