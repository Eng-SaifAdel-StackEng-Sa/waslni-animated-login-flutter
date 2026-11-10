import 'package:flutter/material.dart';

void main() {
  runApp(const DeliveryApp());
}

// ألوان التطبيق
const Color darkColor = Color(0xFF0B1220);
const Color cardColor = Color(0xFF162238);
const Color orangeColor = Color(0xFFFFAE43);

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WASLNI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: orangeColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: DeliveryLoginPage(),
      ),
    );
  }
}

class DeliveryLoginPage extends StatefulWidget {
  const DeliveryLoginPage({super.key});

  @override
  State<DeliveryLoginPage> createState() {
    return _DeliveryLoginPageState();
  }
}

class _DeliveryLoginPageState
    extends State<DeliveryLoginPage>
    with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;
  bool isLoading = false;

  late final AnimationController heroController;
  late final AnimationController entryController;

  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    // حركة الصورة الرئيسية المستمرة
    heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // حركة ظهور عناصر الشاشة
    entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    fadeAnimation = CurvedAnimation(
      parent: entryController,
      curve: const Interval(
        0.1,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: entryController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  // التحقق التجريبي من الحقول
  Future<void> login() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    // تأخير تجريبي لإظهار حركة التحميل
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "تم التحقق من الحقول. لم يتم ربط تسجيل الدخول بالخادم بعد.",
        ),
      ),
    );
  }

  @override
  void dispose() {
    heroController.dispose();
    entryController.dispose();

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // الصورة المتحركة في أعلى الشاشة
  Widget buildHero() {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [

          // تأثير تكبير وتصغير الصورة
          AnimatedBuilder(
            animation: heroController,
            child: Image.asset(
              'assets/images/hero.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF263B51),
                  child: const Center(
                    child: Icon(
                      Icons.delivery_dining_rounded,
                      size: 130,
                      color: orangeColor,
                    ),
                  ),
                );
              },
            ),
            builder: (context, child) {
              return Transform.scale(
                scale: 1.04 + heroController.value * 0.08,
                child: child,
              );
            },
          ),

          // تدرج مظلم فوق الصورة
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x990B1220),
                  Color(0x440B1220),
                  darkColor,
                ],
              ),
            ),
          ),

          // اسم التطبيق أعلى الصورة
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            left: 24,
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_rounded,
                  color: orangeColor,
                  size: 34,
                ),
                const SizedBox(width: 10),
                const Text(
                  "وصّلني",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x66303B4E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "توصيل سريع ⚡",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // أيقونة توصيل تتحرك باستمرار
          Positioned(
            top: 145,
            left: 30,
            child: AnimatedBuilder(
              animation: heroController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    heroController.value * 25,
                    -heroController.value * 12,
                  ),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: orangeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: orangeColor.withAlpha(90),
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  size: 40,
                  color: darkColor,
                ),
              ),
            ),
          ),

          // عنوان يظهر بحركة انزلاق وتلاشي
          Positioned(
            right: 24,
            left: 24,
            bottom: 58,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "كل طلباتك...",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "توصل لحد بابك!",
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        color: orangeColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "مطاعم، مقاضي وأكثر في مكان واحد",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFCFD6E1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // صورة صغيرة مع اسم القسم
  Widget photoChip(
    String imagePath,
    String title,
    IconData fallbackIcon,
  ) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF23334A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 37,
              height: 37,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 37,
                  height: 37,
                  color: const Color(0xFF35445C),
                  child: Icon(
                    fallbackIcon,
                    color: orangeColor,
                    size: 22,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  // تصميم حقول البريد وكلمة المرور
  Widget buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 9),

        TextFormField(
          controller: controller,
          obscureText: isPassword && !showPassword,
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textInputAction: isPassword
              ? TextInputAction.done
              : TextInputAction.next,
          onFieldSubmitted: isPassword
              ? (_) => login()
              : null,
          style: const TextStyle(color: Colors.white),

          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "هذا الحقل مطلوب";
            }

            if (!isPassword &&
                !RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(value.trim())) {
              return "أدخل بريدًا إلكترونيًا صحيحًا";
            }

            if (isPassword && value.length < 6) {
              return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
            }

            return null;
          },

          decoration: InputDecoration(
            hintText: isPassword
                ? "••••••••"
                : "name@example.com",

            hintStyle: const TextStyle(
              color: Color(0xFF8895AA),
            ),

            prefixIcon: Icon(
              icon,
              color: orangeColor,
            ),

            suffixIcon: isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: const Color(0xFFADBAD0),
                    ),
                  )
                : null,

            filled: true,
            fillColor: const Color(0xFF23334A),

            contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF3B4B63),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: orangeColor,
                width: 2,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // زر الدخول المتدرج والمتحرك
  Widget buildLoginButton() {
    return AnimatedScale(
      scale: isLoading ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 250),

      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFBB55),
              Color(0xFFFF762C),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: orangeColor.withAlpha(55),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: isLoading ? null : login,

            child: Center(
              child: AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 300),

                child: isLoading
                    ? const SizedBox(
                        key: ValueKey("loading"),
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: darkColor,
                        ),
                      )
                    : const Row(
                        key: ValueKey("login"),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_back_rounded,
                            color: darkColor,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // بطاقة تسجيل الدخول
  Widget buildLoginCard() {
    return FadeTransition(
      opacity: fadeAnimation,

      child: SlideTransition(
        position: slideAnimation,

        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF304057),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 30,
                offset: Offset(0, 16),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "أهلًا بعودتك 👋",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                "سجّل الدخول وتابع طلباتك لحظة بلحظة",
                style: TextStyle(
                  color: Color(0xFFABBCD1),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              // الصور التي ستضيفها
              Row(
                children: [
                  photoChip(
                    'assets/images/food.jpg',
                    "مطاعم",
                    Icons.restaurant_rounded,
                  ),
                  const SizedBox(width: 10),
                  photoChip(
                    'assets/images/groceries.jpg',
                    "مقاضي",
                    Icons.shopping_basket_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 26),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    buildInput(
                      label: "البريد الإلكتروني",
                      controller: emailController,
                      icon: Icons.mail_outline_rounded,
                    ),

                    const SizedBox(height: 18),

                    buildInput(
                      label: "كلمة المرور",
                      controller: passwordController,
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),

                    const SizedBox(height: 26),

                    buildLoginButton(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8895AA),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHero(),

              Transform.translate(
                offset: const Offset(0, -24),
                child: buildLoginCard(),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}