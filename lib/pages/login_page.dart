import 'package:flutter/material.dart';
import '../main.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool _remember = false;
  bool _obscure  = true;
  bool _loading  = false;

  String _nameFromEmail(String email) {
    final beforeAt = email.split('@').first.replaceAll('.', ' ').trim();
    if (beforeAt.isEmpty) return 'Usuario';
    return beforeAt
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    final displayName = _nameFromEmail(_emailCtrl.text.trim());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(userName: displayName)),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom; // altura del teclado
    return Scaffold(
      backgroundColor: AppColors.background,
      // ayuda a que el cuerpo se reajuste cuando aparece el teclado
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: viewInsets), // evita que el teclado tape campos
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // HEADER (más compacto y responsive)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.navyDark, AppColors.navy],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(52),
                          bottomRight: Radius.circular(52),
                        ),
                      ),
                      child: Column(
                        children: const [
                          _LogoBadge(), // ahora es responsive
                          SizedBox(height: 14),
                          Text(
                            'Gestión de Inventario',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    // CARD del formulario (levemente superpuesta)
                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Ingresa tus credenciales de empleado',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 22),

                                  const Text(
                                    'Correo Electrónico',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'empleado@negocio.com',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      prefixIcon: const Icon(Icons.mail_outline),
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Ingrese su correo';
                                      final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v);
                                      return ok ? null : 'Correo no válido';
                                    },
                                  ),

                                  const SizedBox(height: 16),
                                  const Text(
                                    'Contraseña',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _passCtrl,
                                    obscureText: _obscure,
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () => setState(() => _obscure = !_obscure),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
                                      ),
                                    ),
                                    validator: (v) => (v == null || v.length < 4) ? 'Mínimo 4 caracteres' : null,
                                  ),

                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _remember,
                                        onChanged: (v) => setState(() => _remember = v ?? false),
                                        activeColor: AppColors.navy,
                                      ),
                                      const Text('Recordarme'),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          '¿Olvidaste tu contraseña?',
                                          style: TextStyle(color: AppColors.navy),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1D4ED8),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 3,
                                      ),
                                      onPressed: _loading ? null : _onSubmit,
                                      child: _loading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                            )
                                          : const Text(
                                              'Iniciar Sesión',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    // Tamaño responsivo según ancho de pantalla
    final double size = (MediaQuery.of(context).size.width * 0.34).clamp(96, 160).toDouble();
    return SizedBox(
      height: size,
      width: size,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo_navbar.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
