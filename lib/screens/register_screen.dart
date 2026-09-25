import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'widgets/auth_text_field.dart';
import 'main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _selectedLanguage = 'Wolof';
  final List<Map<String, dynamic>> _languages = const [
    {'name': 'Wolof', 'icon': LucideIcons.languages},
    {'name': 'Pulaar', 'icon': LucideIcons.languages},
    {'name': 'Sérère', 'icon': LucideIcons.languages},
  ];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Les mots de passe ne correspondent pas');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.register(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      language: _selectedLanguage,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      await AuthService.saveSession(res['token'], res['user']);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
            (route) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = res['error'] ?? 'Une erreur est survenue';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Créez votre compte',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 6),

                Text(
                  'Rejoignez Fatelia pour ne plus rater vos rappels santé.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ).animate().fadeIn(delay: 80.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 28),

                AuthTextField(
                  controller: _nameController,
                  label: 'Nom complet',
                  hint: 'Aminata Diallo',
                  icon: LucideIcons.user,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Entrez votre nom complet';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 160.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _phoneController,
                  label: 'Numéro de téléphone',
                  hint: '77 000 00 00',
                  icon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Entrez votre numéro de téléphone';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 220.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hint: '••••••••',
                  icon: LucideIcons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return '4 caractères minimum';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 280.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _confirmController,
                  label: 'Confirmer le mot de passe',
                  hint: '••••••••',
                  icon: LucideIcons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmez votre mot de passe';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 340.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 20),

                Text(
                  'Langue préférée',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 380.ms, duration: 400.ms),

                const SizedBox(height: 10),

                Row(
                  children: _languages.map((lang) {
                    final isSelected = _selectedLanguage == lang['name'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedLanguage = lang['name']),
                        child: Container(
                          margin: EdgeInsets.only(right: lang['name'] != 'Sérère' ? 10 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppColors.primaryGradient : null,
                            color: isSelected ? null : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                LucideIcons.languages,
                                size: 18,
                                color: isSelected ? Colors.white : AppColors.textMuted,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang['name'],
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 420.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertCircle, size: 16, color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 12.5, color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).shake(hz: 4, curve: Curves.easeInOut),
                ],

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGradientStart.withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _isLoading ? null : _handleRegister,
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Créer mon compte',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 480.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: RichText(
                      text: TextSpan(
                        text: 'Déjà un compte ? ',
                        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                        children: const [
                          TextSpan(
                            text: 'Connectez-vous',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGradientStart,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 540.ms, duration: 400.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}