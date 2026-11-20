import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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

class MembreFamille {
  final String nom;
  final String role;
  final String photo;
  const MembreFamille(this.nom, this.role, this.photo);
}

class Donnees {
  static const identifiant = 'jean';
  static const motDePasse = 'jean0101';

  static const nomComplet = 'Musoka Hamuli Jean';
  static const titre = 'Développeur Logiciel & Systèmes Embarqués';
  static const photo = 'assets/images/jean.jpg';

  static const telephone = '0991928450';
  static const email = 'Jeansheriff429@gmail.com';
  static const localisation = 'Goma, RD Congo';

  static const profil =
      "Développeur logiciel et passionné des systèmes embarqués, avec une expérience en développement web, mobile et électronique. Actuellement en formation en génie logiciel, je conçois des solutions innovantes combinant hardware et software.";

  static const competences = <Competence>[
    Competence('Développement Web', ['HTML', 'CSS', 'JavaScript', 'PHP', 'Python']),
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

      Projet(
      'BuyPaye',
      'Application de transfert d\'argent',
      'FinTech',
    ),
  ];

  static const formations = [
    ['Licence en Génie Logiciel', 'En cours'],
    ['Diplôme d\'État (Option Électricité)', 'Secondaire'],
  ];

  static const langues = [
    ['Français', 'Bon niveau'],
    ['Anglais', 'Intermédiaire'],
  ];

  static const interets = ['Technologie', 'Robotique', 'Innovation', 'Musique', 'Électricité'];

  static const famille = <MembreFamille>[
    MembreFamille('Bahati Musoka', 'Frère', 'assets/images/bahati.jpg'),
    MembreFamille('Dieum Hamuli', 'Frère', 'assets/images/dieum.jpg'),
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
}) =>
    GoogleFonts.figtree(
        fontSize: size, fontWeight: w, color: c, height: h, letterSpacing: ls);

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
        ).copyWith(
          primary: kAccent,
          surface: kSurface,
          onSurface: kInk,
        ),
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
  final String nom;
  final double size;
  final double radius;
  final bool circle;

  const Photo({
    super.key,
    this.asset,
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
      child: Text(initiale, style: figtree(size * 0.4, w: FontWeight.w700, c: kAccent)),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: circle ? null : BorderRadius.circular(radius),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        color: kAccentSoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: asset == null
          ? placeholder
          : Image.asset(
              asset!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
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
      child: Text(
        text,
        style: figtree(18, w: FontWeight.w700, ls: -0.3),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CardBox({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

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

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg, style: figtree(13, w: FontWeight.w500, c: Colors.white)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 90),
      backgroundColor: kInk,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
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

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    if (_idCtrl.text.trim().toLowerCase() == Donnees.identifiant &&
        _mdpCtrl.text == Donnees.motDePasse) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );
    } else {
      setState(() {
        _loading = false;
        _error = 'Identifiant ou mot de passe incorrect.';
      });
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

              
              Text('Connexion', style: figtree(34, w: FontWeight.w800, h: 1.1, ls: -1.0)),
              const SizedBox(height: 12),
              Text('Accédez au CV de Musoka Hamuli.', style: figtree(15, c: kInk2, h: 1.5)),
              const SizedBox(height: 48),

              _buildField(
                label: 'Identifiant',
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
                  icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kInk3),
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
                        child: Text(_error!, style: figtree(13, w: FontWeight.w500, c: kDanger)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text('Se connecter', style: figtree(16, w: FontWeight.w700, c: Colors.white)),
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
          child: Text(label, style: figtree(13, w: FontWeight.w600, c: kInk2)),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kAccent, width: 1.5)),
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
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
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
    (icon: Icons.person_outline_rounded, active: Icons.person_rounded, label: 'Profil'),
    (icon: Icons.grid_view_rounded, active: Icons.grid_view_rounded, label: 'Projets'),
    (icon: Icons.people_outline_rounded, active: Icons.people_rounded, label: 'Famille'),
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
            style: figtree(11, w: active ? FontWeight.w700 : FontWeight.w500, c: active ? kAccent : kInk3),
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
                  Text('Mon CV', style: figtree(15, w: FontWeight.w600, c: kInk2)),
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
                        child: const Icon(Icons.logout_rounded, size: 18, color: kInk2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Photo(asset: Donnees.photo, nom: Donnees.nomComplet, size: 80, radius: 24),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Donnees.nomComplet, style: figtree(22, w: FontWeight.w800, ls: -0.5)),
                        const SizedBox(height: 4),
                        Text(Donnees.titre, style: figtree(13, c: kAccent, w: FontWeight.w600, h: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CardBox(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    _contactLine(Icons.location_on_rounded, Donnees.localisation),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(8)),
                          child: Text(Donnees.posteActuel, style: figtree(11, w: FontWeight.w700, c: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        Text(Donnees.entreprise, style: figtree(16, w: FontWeight.w700)),
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
                              decoration: const BoxDecoration(color: kAccent, shape: BoxShape.circle),
                            ),
                            Expanded(child: Text(m, style: figtree(13.5, c: kInk2, h: 1.5))),
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorder),
                        ),
                        child: Text(item, style: figtree(13, w: FontWeight.w500, c: kInk)),
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
                            Expanded(child: Text(Donnees.formations[i][0], style: figtree(14, w: FontWeight.w600))),
                            Text(Donnees.formations[i][1], style: figtree(12, c: kInk3)),
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
                            Text(Donnees.langues[i][0], style: figtree(14, w: FontWeight.w600)),
                            Text(Donnees.langues[i][1], style: figtree(13, c: kInk2)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: kAccentSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(interet, style: figtree(13, w: FontWeight.w600, c: kAccent)),
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
              Text('Mes Projets', style: figtree(28, w: FontWeight.w800, ls: -0.8)),
              const SizedBox(height: 8),
              Text('Réalisations techniques et innovantes.', style: figtree(14, c: kInk2)),
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
                              child: Text(Donnees.projets[i].titre, style: figtree(17, w: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: kAccentSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(Donnees.projets[i].tag, style: figtree(10, w: FontWeight.w700, c: kAccent)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(Donnees.projets[i].description, style: figtree(13.5, c: kInk2, h: 1.5)),
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

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

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
              Text('Ma Famille', style: figtree(28, w: FontWeight.w800, ls: -0.8)),
              const SizedBox(height: 8),
              Text('Mes deux frères.', style: figtree(14, c: kInk2)),
              const SizedBox(height: 24),

              for (int i = 0; i < Donnees.famille.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CardBox(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Photo(
                          asset: Donnees.famille[i].photo,
                          nom: Donnees.famille[i].nom,
                          size: 60,
                          circle: true,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Donnees.famille[i].nom, style: figtree(16, w: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(Donnees.famille[i].role, style: figtree(13, c: kInk2, w: FontWeight.w500)),
                            ],
                          ),
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