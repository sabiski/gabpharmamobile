/// Style carte Gab'Pharma (clair, soigné, peu saturé).
class MapsStyle {
  MapsStyle._();

  static const String gabPharmaClair = r'''
[
  {"elementType":"geometry","stylers":[{"color":"#f5f7fa"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#374151"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"}]},
  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c7d0da"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eef2f6"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e3f5ea"}]},
  {"featureType":"poi.business","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#dbe3ec"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dfe7f2"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9dff5"}]}
]
''';
}
