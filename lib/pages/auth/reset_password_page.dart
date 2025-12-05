import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/theme/colors.dart';
import '../../ui/components/buttons/primary_button.dart';
import '../../ui/components/layout/section_card.dart';
import '../../ui/components/layout/spacing.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String verificationCode;
  
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Estado de requisitos
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordRequirements);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkPasswordRequirements);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordRequirements() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      _hasNumber = RegExp(r'\d').hasMatch(password);
    });
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // TODO: Llamada al endpoint POST /api/auth/reset-password
        await Future.delayed(const Duration(seconds: 2));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contraseña restablecida exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al restablecer contraseña: $e'),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo - movido hacia arriba
              Transform.translate(
                offset: const Offset(0, -30),
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
                offset: const Offset(0, -70),
                child: SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Crear Nueva Contraseña',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        Spacing.vertical(10),

                        const Text(
                          'Tu nueva contraseña debe ser diferente a las contraseñas usadas anteriormente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        Spacing.vertical(16),

                        // Campo Nueva Contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Nueva contraseña',
                          
    floatingLabelStyle: const TextStyle(
      color: AppColors.navy, // Color azul cuando tiene focus
    ),
                            hintText: 'Mínimo 8 caracteres',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                              borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            if (!_hasMinLength || !_hasUppercase || !_hasLowercase || !_hasNumber) {
                              return 'Debe cumplir todos los requisitos';
                            }
                            return null;
                          },
                        ),
                        Spacing.vertical(20),

                        // Campo Confirmar Contraseña
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            floatingLabelStyle: const TextStyle(
      color: AppColors.navy, // Color azul cuando tiene focus
    ),
                            hintText: 'Ingresa la contraseña',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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
                              borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        Spacing.vertical(24),

                        // Requisitos de contraseña con validación visual
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.navy.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.navy.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tu contraseña debe contener:',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildRequirement(
                                'Al menos 8 caracteres',
                                _hasMinLength,
                              ),
                              _buildRequirement(
                                'Una letra mayúscula',
                                _hasUppercase,
                              ),
                              _buildRequirement(
                                'Una letra minúscula',
                                _hasLowercase,
                              ),
                              _buildRequirement(
                                'Un número',
                                _hasNumber,
                              ),
                            ],
                          ),
                        ),
                        Spacing.vertical(28),

                        // Botón Restablecer
                        PrimaryButton(
                          text: 'Restablecer contraseña',
                          loading: _isLoading,
                          onPressed: _resetPassword,
                        ),
                        Spacing.vertical(20),

                        // Volver al login
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Text(
                            'Volver al inicio de sesión',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacing.vertical(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isMet ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
              color: isMet ? Colors.green : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMet ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}