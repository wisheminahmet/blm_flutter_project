import 'package:deneme2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haber Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Ekranı'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Şifre'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String enteredEmail = _emailController.text;
                String enteredPassword = _passwordController.text;

                if (await _registerUser(enteredEmail, enteredPassword)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsApp(enteredEmail),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Hata'),
                        content: Text('E-mail veya şifre hatalı!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Tamam'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Giriş Yap'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(),
                  ),
                );
              },
              child: Text('Kaydol'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _registerUser(String enteredEmail, String enteredPassword) async {
    try {
      // Firebase Authentication kullanarak yeni kullanıcı kaydı yap
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: enteredEmail,
        password: enteredPassword,
      );
      return true; // Kayıt başarılıysa true döndür
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false; // Kayıt başarısızsa false döndür
    }
  }
}



class RegistrationScreen extends StatelessWidget {
  TextEditingController _newUsernameController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newUsernameController,
              decoration: InputDecoration(labelText: 'Yeni e-mail'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Yeni Şifre'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String newUsername = _newUsernameController.text;
                String newPassword = _newPasswordController.text;

                // Yeni kullanıcı adı ve şifreyi kullanarak kayıt işlemi, örnek olarak burada yapmıyorum
                // Gerçek bir uygulamada sunucu ile iletişime geçtikten sonra ancak yapabiliriz

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Başarılı'),
                      content: Text('Kayıt işlemi başarıyla tamamlandı!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Tamam'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Kaydol'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsApp extends StatelessWidget {
  final String username;

  NewsApp(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AED NEWS - $username'),
        centerTitle: true,
      ),
      body: NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                'HABERLER',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                  color: Colors.purple,
                  fontFamily: "Gatile", // ? olmadı
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 20.0),
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/5304/5304115.png',
              width: 30.0,
              height: 30.0,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Genel'),
              Tab(text: 'Spor'),
              Tab(text: 'Magazin'),
              Tab(text: 'Siyaset'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return NewsList(
                      category: "Genel",
                      constraints: constraints,
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return NewsList(
                      category: "Spor",
                      constraints: constraints,
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return NewsList(
                      category: "Magazin",
                      constraints: constraints,
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return NewsList(
                      category: "Siyaset",
                      constraints: constraints,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Çıkış butonuna basıldığında, kullanıcıyı giriş ekranına yönlendir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        tooltip: 'Çıkış',
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final String category;
  final BoxConstraints constraints;

  NewsList({required this.category, required this.constraints});

  final List<Map<String, String>> newsList = [
    {"title": "Genel Haber", "content": "Haberin İçeriği", "category": "Genel"},
    {"title": "Spor Haber", "content": "Haberin İçeriği", "category": "Spor"},
    {
      "title": "Magazin Haber",
      "content": "Haberin İçeriği",
      "category": "Magazin"
    },
    {
      "title": "Siyasi Haber",
      "content": "Haberin İçeriği",
      "category": "Siyaset"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredNews =
        newsList.where((news) => news["category"] == category).toList();

    return ListView.builder(
      itemCount: filteredNews.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NewsDetailScreen(news: filteredNews[index]),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(filteredNews[index]["title"]!),
              subtitle: Text(filteredNews[index]["content"]!),
            ),
          ),
        );
      },
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Map<String, String> news;

  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news["title"]!),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(news["content"]!),
      ),
    );
  }
}
