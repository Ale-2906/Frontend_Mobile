import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/theme/colors.dart';
import '../../ui/components/buttons/primary_button.dart';
//import '../../ui/components/inputs/email_input.dart';
//import '../../ui/components/layout/page_title.dart';
import '../../ui/components/layout/section_card.dart';
import '../../ui/components/layout/spacing.dart';
import 'verify_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // TODO: Llamada al endpoint POST /api/auth/forgot-password
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyCodePage(
                email: _emailController.text,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al enviar el código: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Esto hace que la barra de estado (hora, batería) sea visible
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle.dark, // Iconos oscuros en la barra de estado
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Reducir padding horizontal
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(horizontal: 20), // Reducido de 24 a 20
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo con imagen - movido hacia arriba
              Transform.translate(
                offset: const Offset(0, -30), // Números negativos lo suben
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_navbar.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      color: AppColors.navy,
                    ),
                  ],
                ),
              ),
              Spacing.vertical(4),

              // Card con formulario
              Transform.translate(
                offset: const Offset(
                    0, -70), // Ajusta el valor para subirlo más o menos
                child: SectionCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32), // Reducido de 24
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Recuperación de\nContraseña',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26, // Reducido de 28
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        Spacing.vertical(16), // Reducido de 16

                        const Text(
                          'Ingresa tu correo electrónico y te enviaremos un código de verificación.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, // Reducido de 16
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        Spacing.vertical(40), // Reducido de 32

                        // Campo de Email
                        // Reemplaza EmailInput por esto:
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              //color: AppColors.navy,
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: AppColors.navy,
                            ),
                            hintText: 'empleado@negocio.com',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.mail_outline),
                            filled: true,
                            fillColor: const Color(0xFFF3F4F6),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.navy,
                                  width: 1.5), // Azul cuando tiene focus
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Ingrese su correo';
                            final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$')
                                .hasMatch(v);
                            return ok ? null : 'Correo no válido';
                          },
                        ),
                        Spacing.vertical(28), // Reducido de 32

                        // Botón
                        PrimaryButton(
                          text: 'Enviar código',
                          loading: _isLoading,
                          onPressed: _sendCode,
                        ),
                        Spacing.vertical(20), // Reducido de 24

                        // Link volver al login
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              '¿Recordaste tu contraseña? Inicia sesión',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacing.vertical(20), // Espacio inferior
            ],
          ),
        ),
      ),
    );
  }
}
