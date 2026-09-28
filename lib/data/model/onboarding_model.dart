class OnboardingItem {
  final String bgImage;
  final String? logoImage;
  final String title;
  final String description;
  final String buttonText;

  OnboardingItem({
    required this.bgImage,
    this.logoImage,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}