enum BottomItem {
  home,
  appointment,
  schedule,
  payout,
  profile,
  settings,
}

class BottomBarItem {
  final String title;
  final String icon;
  final String activeIcon;
  final String type;

  BottomBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.type,
  });
}
