class AppStrings {
  AppStrings._();

  static const List<String> supportedLanguages = ['Wolof', 'Pulaar', 'Sérère', 'Français'];

  static const List<String> _moisFr = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];

  /// Ex: "25 septembre"
  static String shortDateFr(DateTime date) {
    return '${date.day} ${_moisFr[date.month - 1]}';
  }

  static String greeting(String language, String userName) {
    switch (language) {
      case 'Wolof':
        return 'Na nga def, $userName !';
      case 'Pulaar':
        return 'Jam tan, $userName !'; // à vérifier
      case 'Sérère':
        return 'Mbaam, $userName !'; // à vérifier
      default:
        return 'Bonjour, $userName !';
    }
  }

  static String remindersSubtitle(String language, int count) {
    if (count == 0) {
      switch (language) {
        case 'Wolof':
          return "Amul rappel tay. (Aucun rappel aujourd'hui.)";
        default:
          return "Aucun rappel aujourd'hui.";
      }
    }
    switch (language) {
      case 'Wolof':
        return 'Am nañu $count rappel${count > 1 ? "yi" : ""} tay.';
      default:
        return 'Vous avez $count rappel${count > 1 ? "s" : ""} aujourd\'hui.';
    }
  }

  static String voiceActionLabel(String language) {
    switch (language) {
      case 'Wolof':
        return 'Déglu vocal';
      default:
        return 'Écouter (vocal)';
    }
  }

  static String micIdlePrompt(String language) {
    switch (language) {
      case 'Wolof':
        return 'Bëssal bouton bi ngir wax';
      default:
        return 'Appuyez sur le bouton pour parler';
    }
  }

  static String micListeningPrompt(String language) {
    switch (language) {
      case 'Wolof':
        return 'Déglu nañu sa wax... (Appuyez pour arrêter)';
      default:
        return 'Écoute en cours... (Appuyez pour arrêter)';
    }
  }
}