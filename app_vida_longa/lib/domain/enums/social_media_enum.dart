import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialMediaEnum {
  facebook("facebook", Icons.facebook),
  instagram("instagram", FontAwesomeIcons.instagram),
  whatsapp("whatsapp", FontAwesomeIcons.whatsapp),
  linkedin("linkedin", FontAwesomeIcons.linkedin),
  tiktok("tiktok", FontAwesomeIcons.tiktok),
  twitter("twitter", FontAwesomeIcons.twitter),
  other("other", Icons.link);

  final String type;
  final IconData icon;
  const SocialMediaEnum(this.type, this.icon);
}
