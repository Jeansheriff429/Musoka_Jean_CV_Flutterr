import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

const String kBaseUrl = 'http://localhost/api-test/public';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CvApp());
}

class Competence {
  final String categorie;
  final List<String> items;
  const Competence(this.categorie, this.items);
}

class Projet {
  final String titre;
  final String description;
  final String tag;
  const Projet(this.titre, this.description, this.tag);
}

class Membre {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  Membre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  factory Membre.fromJson(Map<String, dynamic> json) {
    return Membre(
      id: json['id'],
      nom: json['nom'] ?? '',
      postnom: json['postnom'] ?? '',
      prenom: json['prenom'] ?? '',
      lieuNaissance: json['lieu_naissance'] ?? '',
      dateNaissance: json['date_naissance'] ?? '',
      parente: json['parente'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  Map<String, String> toJson() {
    return {
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
    };
  }
}

class ApiService {
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$kBaseUrl/accounts/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['success'] == true) {
      return data;
    }
    throw Exception(data['message'] ?? 'Erreur de connexion');
  }

  static Future<List<Membre>> getMembres() async {
    final res = await http.get(
      Uri.parse('$kBaseUrl/famille-membres'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data['data'] as List;
      return list.map((e) => Membre.fromJson(e)).toList();
    }
    throw Exception('Erreur lors du chargement');
  }

  static String _parseError(http.Response res) {
    try {
      final data = jsonDecode(res.body);
      if (data['errors'] != null) {
        return (data['errors'] as Map).values.first.toString();
      }
      return data['message'] ?? 'Erreur inconnue';
    } catch (_) {
      return 'Erreur serveur (${res.statusCode})';
    }
  }

  static Future<void> addMembre(Membre m, {File? image}) async {
    try {
      if (image != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$kBaseUrl/famille-membres'),
        );
        request.headers.addAll({'Accept': 'application/json'});
        request.fields.addAll(m.toJson());
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );

        final response = await request.send();
        final res = await http.Response.fromStream(response);
        if (res.statusCode != 201) throw Exception(_parseError(res));
      } else {
        final res = await http.post(
          Uri.parse('$kBaseUrl/famille-membres'),
          headers: _headers,
          body: jsonEncode(m.toJson()),
        );
        if (res.statusCode != 201) throw Exception(_parseError(res));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  static Future<void> updateMembre(Membre m, {File? image}) async {
    try {
      if (image != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$kBaseUrl/famille-membres/${m.id}'),
        );
        request.headers.addAll({'Accept': 'application/json'});
        request.fields.addAll(m.toJson());
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );

        final response = await request.send();
        final res = await http.Response.fromStream(response);
        if (res.statusCode != 200) throw Exception(_parseError(res));
      } else {
        final res = await http.put(
          Uri.parse('$kBaseUrl/famille-membres/${m.id}'),
          headers: _headers,
          body: jsonEncode(m.toJson()),
        );
        if (res.statusCode != 200) throw Exception(_parseError(res));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  static Future<void> deleteMembre(int id) async {
    final res = await http.delete(
      Uri.parse('$kBaseUrl/famille-membres/$id'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Erreur lors de la suppression');
  }
}

class Donnees {
  static const nomComplet = 'Musoka Hamuli Jean';
  static const titre = 'Développeur Logiciel & Systèmes Embarqués';
  static const photo = 'assets/images/jean.jpg';

  static const telephone = '0991928450';
  static const email = 'Jeansheriff429@gmail.com';
  static const localisation = 'Goma, RD Congo';

  static const profil =
      "Développeur logiciel et passionné des systèmes embarqués, avec une expérience en développement web, mobile et électronique. Actuellement en formation en génie logiciel, je conçois des solutions innovantes combinant hardware et software.";

  static const competences = <Competence>[
    Competence('Développement Web', [
      'HTML',
      'CSS',
      'JavaScript',
      'PHP',
      'Python',
    ]),
    Competence('Frameworks', ['Laravel']),
    Competence('Mobile', ['Flutter']),
    Competence('Bases de données', ['MySQL', 'SQL', 'Supabase']),
    Competence('Systèmes embarqués', ['Arduino', 'Raspberry Pi']),
    Competence('Méthodes', ['Développement full-stack']),
  ];

  static const posteActuel = 'CEO';
  static const entreprise = 'DmbGroup';
  static const missions = [
    "Gestion et direction d'une entreprise technologique",
    "Développement d'applications mobiles et web",
    "Conception de solutions électroniques et robotiques",
  ];

  static const projets = <Projet>[
    Projet(
      'Feux de signalisation intelligents',
      'Réalisation des systèmes de feux de signalisation (feux rouges) à Goma.',
      'IoT & Hardware',
    ),
    Projet(
      'Sites web DmbGroup',
      'Développement de sites web pour les activités de l\'entreprise.',
      'Web',
    ),
    Projet(
      'Projets robotiques',
      'Conception de projets robotiques et électroniques intelligents.',
      'Robotics',
    ),
    Projet('BuyPaye', 'Application de transfert d\'argent', 'FinTech'),
  ];

  static const formations = [
    ['Licence en Génie Logiciel', 'En cours'],
    ['Diplôme d\'État (Option Électricité)', 'Secondaire'],
  ];

  static const langues = [
    ['Français', 'Bon niveau'],
    ['Anglais', 'Intermédiaire'],
  ];

  static const interets = [
    'Technologie',
    'Robotique',
    'Innovation',
    'Musique',
    'Électricité',
  ];
}

const kBg = Color(0xFFF8FAFC);
const kSurface = Color(0xFFFFFFFF);
const kInk = Color(0xFF0F172A);
const kInk2 = Color(0xFF475569);
const kInk3 = Color(0xFF94A3B8);
const kBorder = Color(0xFFE2E8F0);
const kAccent = Color(0xFF4F46E5);
const kAccentSoft = Color(0xFFEEF2FF);
const kDanger = Color(0xFFEF4444);

TextStyle figtree(
  double size, {
  FontWeight w = FontWeight.w400,
  Color c = kInk,
  double? h,
  double? ls,
}) => GoogleFonts.figtree(
  fontSize: size,
  fontWeight: w,
  color: c,
  height: h,
  letterSpacing: ls,
);

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Jean Musoka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAccent,
          brightness: Brightness.light,
        ).copyWith(primary: kAccent, surface: kSurface, onSurface: kInk),
        scaffoldBackgroundColor: kBg,
        splashFactory: InkSparkle.splashFactory,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: kAccent,
          selectionColor: kAccent.withOpacity(0.2),
          selectionHandleColor: kAccent,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class Photo extends StatelessWidget {
  final String? asset;
  final String? networkUrl;
  final String nom;
  final double size;
  final double radius;
  final bool circle;

  const Photo({
    super.key,
    this.asset,
    this.networkUrl,
    required this.nom,
    this.size = 56,
    this.radius = 16,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    final initiale = nom.isNotEmpty ? nom.trim()[0].toUpperCase() : '?';
    final placeholder = Container(
      width: size,
      height: size,
      color: kAccentSoft,
      alignment: Alignment.center,
      child: Text(
        initiale,
        style: figtree(size * 0.4, w: FontWeight.w700, c: kAccent),
      ),
    );

    Widget child;
    if (networkUrl != null) {
      child = Image.network(
        networkUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else if (asset != null) {
      child = Image.asset(
        asset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      child = placeholder;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: circle ? null : BorderRadius.circular(radius),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        color: kAccentSoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Text(text, style: figtree(18, w: FontWeight.w700, ls: -0.3)),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CardBox({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSurface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder),
            boxShadow: [
              BoxShadow(
                color: kInk.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}

void toast(BuildContext context, String msg, {bool isError = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: figtree(13, w: FontWeight.w500, c: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 90),
        backgroundColor: isError ? kDanger : kInk,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  bool _hide = true;
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      await ApiService.login(_idCtrl.text.trim(), _mdpCtrl.text);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => const MainShell(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _mdpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const SizedBox(height: 36),
              Text(
                'Connexion',
                style: figtree(34, w: FontWeight.w800, h: 1.1, ls: -1.0),
              ),
              const SizedBox(height: 12),
              Text(
                'Accédez au CV de Musoka Hamuli.',
                style: figtree(15, c: kInk2, h: 1.5),
              ),
              const SizedBox(height: 48),

              _buildField(
                label: 'Identifiant (Email)',
                ctrl: _idCtrl,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              _buildField(
                label: 'Mot de passe',
                ctrl: _mdpCtrl,
                obscure: _hide,
                onSubmitted: (_) => _submit(),
                suffix: IconButton(
                  iconSize: 20,
                  icon: Icon(
                    _hide
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: kInk3,
                  ),
                  onPressed: () => setState(() => _hide = !_hide),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kDanger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: kDanger),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: figtree(13, w: FontWeight.w500, c: kDanger),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: kAccent,
                    disabledBackgroundColor: kAccent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Se connecter',
                          style: figtree(
                            16,
                            w: FontWeight.w700,
                            c: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    bool obscure = false,
    Widget? suffix,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: figtree(13, w: FontWeight.w600, c: kInk2),
          ),
        ),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          cursorColor: kAccent,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: figtree(15, w: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: kSurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0;

  void _logout() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      AccueilPage(onLogout: _logout),
      const ProjetsPage(),
      const FamillePage(),
    ];

    return Scaffold(
      backgroundColor: kBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(key: ValueKey(_i), child: pages[_i]),
      ),
      bottomNavigationBar: _NavBar(
        index: _i,
        onChange: (v) => setState(() => _i = v),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;
  const _NavBar({required this.index, required this.onChange});

  static const _items = [
    (
      icon: Icons.person_outline_rounded,
      active: Icons.person_rounded,
      label: 'Profil',
    ),
    (
      icon: Icons.grid_view_rounded,
      active: Icons.grid_view_rounded,
      label: 'Projets',
    ),
    (
      icon: Icons.people_outline_rounded,
      active: Icons.people_rounded,
      label: 'Famille',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++) Expanded(child: _item(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int i) {
    final active = i == index;
    final it = _items[i];
    return InkWell(
      onTap: () => onChange(i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(it.icon, size: 24, color: active ? kAccent : kInk3),
          const SizedBox(height: 4),
          Text(
            it.label,
            style: figtree(
              11,
              w: active ? FontWeight.w700 : FontWeight.w500,
              c: active ? kAccent : kInk3,
            ),
          ),
        ],
      ),
    );
  }
}

class AccueilPage extends StatelessWidget {
  final VoidCallback? onLogout;
  const AccueilPage({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mon CV',
                    style: figtree(15, w: FontWeight.w600, c: kInk2),
                  ),
                  Material(
                    color: kSurface,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onLogout,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: kInk2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Photo(
                    asset: Donnees.photo,
                    nom: Donnees.nomComplet,
                    size: 80,
                    radius: 24,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Donnees.nomComplet,
                          style: figtree(22, w: FontWeight.w800, ls: -0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Donnees.titre,
                          style: figtree(
                            13,
                            c: kAccent,
                            w: FontWeight.w600,
                            h: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CardBox(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _contactLine(Icons.phone_rounded, Donnees.telephone),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: kBorder, height: 1),
                    ),
                    _contactLine(Icons.email_rounded, Donnees.email),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: kBorder, height: 1),
                    ),
                    _contactLine(
                      Icons.location_on_rounded,
                      Donnees.localisation,
                    ),
                  ],
                ),
              ),

              const SectionTitle('Profil'),
              Text(Donnees.profil, style: figtree(14, c: kInk2, h: 1.6)),

              const SectionTitle('Expérience'),
              CardBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            Donnees.posteActuel,
                            style: figtree(
                              11,
                              w: FontWeight.w700,
                              c: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          Donnees.entreprise,
                          style: figtree(16, w: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (var m in Donnees.missions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 10),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: kAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                m,
                                style: figtree(13.5, c: kInk2, h: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SectionTitle('Compétences'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var comp in Donnees.competences)
                    for (var item in comp.items)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: Text(
                          item,
                          style: figtree(13, w: FontWeight.w500, c: kInk),
                        ),
                      ),
                ],
              ),

              const SectionTitle('Formation'),
              CardBox(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (int i = 0; i < Donnees.formations.length; i++) ...[
                      if (i > 0) const Divider(color: kBorder, height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                Donnees.formations[i][0],
                                style: figtree(14, w: FontWeight.w600),
                              ),
                            ),
                            Text(
                              Donnees.formations[i][1],
                              style: figtree(12, c: kInk3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SectionTitle('Langues'),
              CardBox(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (int i = 0; i < Donnees.langues.length; i++) ...[
                      if (i > 0) const Divider(color: kBorder, height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Donnees.langues[i][0],
                              style: figtree(14, w: FontWeight.w600),
                            ),
                            Text(
                              Donnees.langues[i][1],
                              style: figtree(13, c: kInk2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SectionTitle("Centres d'intérêt"),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var interet in Donnees.interets)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kAccentSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        interet,
                        style: figtree(13, w: FontWeight.w600, c: kAccent),
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

  Widget _contactLine(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: kInk2),
        ),
        const SizedBox(width: 14),
        Text(text, style: figtree(13.5, w: FontWeight.w500)),
      ],
    );
  }
}

class ProjetsPage extends StatelessWidget {
  const ProjetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'Mes Projets',
                style: figtree(28, w: FontWeight.w800, ls: -0.8),
              ),
              const SizedBox(height: 8),
              Text(
                'Réalisations techniques et innovantes.',
                style: figtree(14, c: kInk2),
              ),
              const SizedBox(height: 24),

              for (int i = 0; i < Donnees.projets.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CardBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                Donnees.projets[i].titre,
                                style: figtree(17, w: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: kAccentSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                Donnees.projets[i].tag,
                                style: figtree(
                                  10,
                                  w: FontWeight.w700,
                                  c: kAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          Donnees.projets[i].description,
                          style: figtree(13.5, c: kInk2, h: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});
  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  List<Membre> _membres = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _membres = await ApiService.getMembres();
    } catch (e) {
      if (mounted) toast(context, 'Erreur: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showForm({Membre? membre}) {
    final nomCtrl = TextEditingController(text: membre?.nom ?? '');
    final postnomCtrl = TextEditingController(text: membre?.postnom ?? '');
    final prenomCtrl = TextEditingController(text: membre?.prenom ?? '');
    final lieuCtrl = TextEditingController(text: membre?.lieuNaissance ?? '');
    final dateCtrl = TextEditingController(text: membre?.dateNaissance ?? '');
    final parenteCtrl = TextEditingController(text: membre?.parente ?? '');
    File? image;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: kBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      membre == null
                          ? 'Ajouter un membre'
                          : 'Modifier le membre',
                      style: figtree(20, w: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField('Nom', nomCtrl, required: true),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            'Postnom',
                            postnomCtrl,
                            required: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField('Prénom', prenomCtrl, required: true),
                    const SizedBox(height: 12),
                    _buildField('Lieu de naissance', lieuCtrl, required: true),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: dateCtrl,
                      readOnly: true,
                      style: figtree(14, w: FontWeight.w500),
                      decoration: _inputDeco(
                        'Date de naissance',
                        suffix: const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: kInk3,
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setSheetState(() {
                            dateCtrl.text = DateFormat('yyyy-MM-dd')
                                .format(picked);
                          });
                        }
                      },
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      'Lien de parenté (ex: Père)',
                      parenteCtrl,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null)
                          setSheetState(() => image = File(picked.path));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: kBorder),
                        foregroundColor: kAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.image_outlined),
                      label: Text(
                        image == null
                            ? 'Choisir une photo (Optionnel)'
                            : 'Photo sélectionnée',
                        style: figtree(13, w: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final m = Membre(
                            id: membre?.id,
                            nom: nomCtrl.text,
                            postnom: postnomCtrl.text,
                            prenom: prenomCtrl.text,
                            lieuNaissance: lieuCtrl.text,
                            dateNaissance: dateCtrl.text,
                            parente: parenteCtrl.text,
                          );

                          try {
                            if (membre == null) {
                              await ApiService.addMembre(m, image: image);
                            } else {
                              await ApiService.updateMembre(m, image: image);
                            }
                            if (ctx.mounted) Navigator.pop(ctx);
                            _load();
                          } catch (e) {
                            if (ctx.mounted)
                              toast(ctx, 'Erreur: $e', isError: true);
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: kAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Enregistrer',
                          style: figtree(
                            15,
                            w: FontWeight.w700,
                            c: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool required = false,
  }) {
    return TextFormField(
      controller: ctrl,
      style: figtree(14, w: FontWeight.w500),
      decoration: _inputDeco(label),
      validator: (v) => (required && v!.isEmpty) ? 'Requis' : null,
    );
  }

  InputDecoration _inputDeco(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: figtree(13, c: kInk2),
      suffixIcon: suffix,
      filled: true,
      fillColor: kBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kAccent, width: 1.5),
      ),
    );
  }

  void _delete(Membre m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Supprimer', style: figtree(18, w: FontWeight.bold)),
        content: Text('Voulez-vous supprimer ${m.nom} ?', style: figtree(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler', style: figtree(14, c: kInk2)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kDanger),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ApiService.deleteMembre(m.id!);
                _load();
              } catch (e) {
                if (context.mounted) toast(context, '$e', isError: true);
              }
            },
            child: Text('Supprimer', style: figtree(14, c: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: kAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: kAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Ma Famille',
                        style: figtree(28, w: FontWeight.w800, ls: -0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_membres.length} membres.',
                        style: figtree(14, c: kInk2),
                      ),
                      const SizedBox(height: 24),

                      if (_membres.isEmpty)
                        CardBox(
                          padding: const EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              'Aucun membre pour le moment.',
                              style: figtree(14, c: kInk3),
                            ),
                          ),
                        )
                      else
                        for (int i = 0; i < _membres.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardBox(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Photo(
                                    networkUrl: _membres[i].imageUrl,
                                    nom: _membres[i].nom,
                                    size: 60,
                                    circle: true,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_membres[i].nom} ${_membres[i].prenom}',
                                          style: figtree(
                                            16,
                                            w: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _membres[i].parente,
                                          style: figtree(
                                            13,
                                            c: kInk2,
                                            w: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: kInk3,
                                      size: 20,
                                    ),
                                    onSelected: (val) {
                                      if (val == 'edit')
                                        _showForm(membre: _membres[i]);
                                      if (val == 'delete') _delete(_membres[i]);
                                    },
                                    itemBuilder: (c) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Modifier'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text(
                                          'Supprimer',
                                          style: TextStyle(color: kDanger),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
