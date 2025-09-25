import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_transit/auth/auth_provider.dart';
import 'package:smart_transit/components/button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:smart_transit/components/input_otp.dart';

enum LoginStep { phone, otp }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneFormKey = GlobalKey<FormBuilderState>();
  final _otpFormKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  LoginStep _currentStep = LoginStep.phone;
  String _fullPhoneNumber = '';

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();
    if (_phoneFormKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
        final phoneNumber =
            _phoneFormKey.currentState?.value['phone'] as String;
        _fullPhoneNumber = '+91$phoneNumber';
      });
      await Future.delayed(const Duration(seconds: 2));
      print('Sending OTP to: $_fullPhoneNumber');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = LoginStep.otp;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();
    if (_otpFormKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);
      final otp = _otpFormKey.currentState?.value['otp'];
      await Future.delayed(const Duration(seconds: 2));
      print('Verifying OTP: $otp for phone: $_fullPhoneNumber');
      await context.read<AuthProvider>().login(_fullPhoneNumber, otp);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          _AnimatedBackground(isDarkMode: isDarkMode),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _GlassmorphicCard(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentStep == LoginStep.phone
                        ? _buildPhoneStep(context)
                        : _buildOtpStep(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneStep(BuildContext context) {
    return Column(
      key: const ValueKey('phone_step'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Logo(),
        const SizedBox(height: 32),
        const Text('Enter Your Number',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text("We'll send a verification code to continue",
            style: TextStyle(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        FormBuilder(
          key: _phoneFormKey,
          child: _GlassmorphicTextField(
            name: 'phone',
            hintText: 'XXXXX XXXXX',
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.equalLength(10,
                  errorText: 'Must be 10 digits'),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        _LoginButton(
          isLoading: _isLoading,
          label: 'Send OTP',
          icon: LucideIcons.messageSquare,
          onPressed: _sendOtp,
        ),
      ],
    );
  }

  Widget _buildOtpStep(BuildContext context) {
    return Column(
      key: const ValueKey('otp_step'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Logo(),
        const SizedBox(height: 32),
        const Text('Enter Verification Code',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text("Sent to $_fullPhoneNumber",
            style: TextStyle(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        FormBuilder(
          key: _otpFormKey,
          child: FormBuilderField(
            name: 'otp',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6, errorText: 'Incomplete code'),
            ]),
            builder: (field) {
              return AppInputOTP(
                onCompleted: (pin) {
                  field.didChange(pin);
                  _verifyOtp();
                },
                errorText: field.errorText,
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _LoginButton(
          isLoading: _isLoading,
          label: 'Verify & Sign In',
          icon: LucideIcons.logIn,
          onPressed: _verifyOtp,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() {
            _otpFormKey.currentState?.reset();
            _currentStep = LoginStep.phone;
          }),
          child: const Text('Go Back'),
        )
      ],
    );
  }
}

// --- Smaller, Self-Contained Widgets for the Login Screen ---

class _GlassmorphicCard extends StatelessWidget {
  final Widget child;
  const _GlassmorphicCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: (isDarkMode ? Colors.black : Colors.white).withOpacity(0.35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  (isDarkMode ? Colors.white : Colors.black).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/login.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// --- THIS WIDGET IS NOW FIXED ---
class _GlassmorphicTextField extends StatelessWidget {
  final String name;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _GlassmorphicTextField({
    required this.name,
    required this.hintText,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassmorphicCard(
      child: IntrinsicHeight(
        child: Row(
          children: [
            // --- The Permanent Prefix ---
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 8.0),
              child: Text('+91', style: TextStyle(fontSize: 16)),
            ),
            const VerticalDivider(
                width: 1, thickness: 1, indent: 12, endIndent: 12),
            const SizedBox(width: 8),
            // --- The Text Field ---
            Expanded(
              child: FormBuilderTextField(
                name: name,
                validator: validator,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const _LoginButton(
      {required this.isLoading,
      required this.onPressed,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AppButton(
        onPressed: isLoading ? null : onPressed,
        label: isLoading ? 'Please wait...' : label,
        isLoading: isLoading,
        icon: icon,
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  final bool isDarkMode;
  const _AnimatedBackground({required this.isDarkMode});
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
                  const Color(0xFF0F172A),
                  const Color(0xFF1E293B),
                  const Color(0xFF1E3A8A)
                ]
              : [
                  const Color(0xFFE0F7FA),
                  Colors.white,
                  const Color(0xFFE8F5E9)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14,
                child: child,
              );
            },
            child: const Stack(
              children: [
                _Orb(
                    color: Colors.indigo,
                    size: 400,
                    alignment: Alignment(-1.5, -1.5)),
                _Orb(
                    color: Colors.green,
                    size: 300,
                    alignment: Alignment(1.5, 1.5)),
                _Orb(
                    color: Colors.purple,
                    size: 200,
                    alignment: Alignment(0, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;
  final Alignment alignment;

  const _Orb(
      {required this.color, required this.size, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
        ),
      ),
    );
  }
}
