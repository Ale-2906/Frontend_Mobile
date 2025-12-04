import 'package:flutter/material.dart';
import 'package:inventsmart_mobile/services/session_manager.dart';
import '../ui/theme/colors.dart';
import '../ui/components/buttons/primary_button.dart';
import '../ui/components/inputs/email_input.dart';
import '../ui/components/inputs/password_input.dart';
import '../ui/components/layout/page_title.dart';
import '../ui/components/layout/section_card.dart';
import '../ui/components/layout/screen_wrapper.dart';
import '../ui/components/layout/spacing.dart';
import 'home_page.dart';
import '../services/auth_service.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _remember = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final user = await AuthService.login(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );

// ✅ GUARDAR USUARIO EN SESIÓN
      SessionManager.setUsuario(user);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(userName: user.nombre),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll("Exception:", "").trim(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 🔵 ENCABEZADO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
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
                  _LogoBadge(),
                  SizedBox(height: 8),
                  Text(
                    'Gestión de Inventario',
                    style: TextStyle(color: AppColors.text, fontSize: 14),
                  ),
                ],
              ),
            ),

            // 🔵 FORMULARIO EN CARD
            Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SectionCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 26,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PageTitle(title: "Iniciar Sesión"),

                        Spacing.vertical(6),

                        const Text(
                          "Ingresa tus credenciales de empleado",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),

                        Spacing.vertical(22),

                        // INPUT EMAIL
                        EmailInput(
                          controller: _emailCtrl,
                          label: "Correo Electrónico",
                        ),

                        Spacing.vertical(16),

                        // INPUT PASSWORD
                        PasswordInput(
                          controller: _passCtrl,
                          label: "Contraseña",
                        ),

                        Spacing.vertical(10),

                        Row(
                          children: [
                            Checkbox(
                              value: _remember,
                              onChanged: (v) =>
                                  setState(() => _remember = v ?? false),
                              activeColor: AppColors.navy,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Recordarme",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(color: AppColors.navy),
                            ),
                          ),
                        ),

                        Spacing.vertical(16),

                        // ✅ BOTÓN
                        PrimaryButton(
                          text: "Iniciar Sesión",
                          loading: _loading,
                          onPressed: _onSubmit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Spacing.vertical(12),
          ],
        ),
      ),
    );
  }
}

// ✅ LOGO RESPONSIVE
class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    final double size =
        (MediaQuery.of(context).size.width * 0.34).clamp(96, 160).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          'assets/images/logo_navbar.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
