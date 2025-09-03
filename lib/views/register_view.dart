import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/auth/register_controller.dart';
import 'package:kaseapp_ui/models/register_model.dart';
import 'package:kaseapp_ui/utils/gender_enum.dart';
import 'package:kaseapp_ui/widgets/custom_drop_down_button.dart';
import 'package:kaseapp_ui/widgets/custom_material_button.dart'; 
import 'package:kaseapp_ui/widgets/text_form_field.dart';

class RegisterTestView extends StatefulWidget {
  const RegisterTestView({super.key});

  @override
  State<RegisterTestView> createState() => _RegisterTestViewState();
}

class _RegisterTestViewState extends State<RegisterTestView> {
  final RegisterController c = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final first = TextEditingController();
  final last = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();

  Gender? _selectGender;
  bool isShowPassword = false;
  bool isShowCfPassword = false;
  bool agreePersonalData = true;

  void _onRegister() {
    if (!_formKey.currentState!.validate() || !agreePersonalData) return;

    final model = RegisterModel(
      firstName: first.text,
      lastName: last.text,
      sex: _selectGender?.displayGender,
      email: email.text,
      phone: phone.text,
      password: pass.text,
      confirmPassword: pass2.text,
    );
    c.register(registerModel: model);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo
                SizedBox(
                  height: size.height * 0.1,
                  child: Center(
                    child: Image.asset(
                      'lib/assets/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// Title
                Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// First name
                CustomTextFormField(
                  controller: first,
                  emptyText: "First name is required",
                  hintText: "Enter first name",
                  title: "First name",
                ),
                const SizedBox(height: 16),

                /// Last name
                CustomTextFormField(
                  controller: last,
                  emptyText: "Last name is required",
                  hintText: "Enter last name",
                  title: "Last name",
                ),
                const SizedBox(height: 16),

                /// Gender dropdown
                CustomDropDownButtonFormField(
                  items: Gender.values
                      .map((g) => DropdownMenuItem<Gender>(
                            value: g,
                            child: Text(g.displayGender),
                          ))
                      .toList(),
                  hintText: "Select gender",
                  onChanged: (val) {
                    setState(() => _selectGender = val);
                  },
                  onSaved: (val) => _selectGender = val,
                ),
                const SizedBox(height: 16),

                /// Phone
                CustomTextFormField(
                  controller: phone,
                  emptyText: "Phone number cannot be empty",
                  hintText: "Enter phone number",
                  title: "Phone",
                  iconData: Icons.phone_android_outlined,
                  isPhoneNumberType: true,
                ),
                const SizedBox(height: 16),

                /// Email
                CustomTextFormField(
                  controller: email,
                  emptyText: "Email cannot be empty",
                  hintText: "Enter email",
                  title: "Email",
                  isEmail: true,
                  iconData: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                /// Password
                CustomTextFormField(
                  controller: pass,
                  emptyText: "Password cannot be empty",
                  hintText: "Enter password",
                  title: "Password",
                  iconData: Icons.lock,
                  obscureText: !isShowPassword,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => isShowPassword = !isShowPassword),
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ),
                const SizedBox(height: 16),

                /// Confirm password
                CustomTextFormField(
                  controller: pass2,
                  emptyText: "Confirm password cannot be empty",
                  hintText: "Enter confirm password",
                  title: "Confirm password",
                  iconData: Icons.lock,
                  obscureText: !isShowCfPassword,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => isShowCfPassword = !isShowCfPassword),
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                ),
                const SizedBox(height: 20),

                /// Privacy & terms check
                Row(
                  children: [
                    Checkbox(
                      value: agreePersonalData,
                      onChanged: (val) =>
                          setState(() => agreePersonalData = val!),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "I agree to Privacy Policy and Terms of Use",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Register button
                Obx(() => CustomMaterialButton(
                      width: size.width,
                      height: size.height * 0.06,
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      onTap: _onRegister,
                      child: c.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
