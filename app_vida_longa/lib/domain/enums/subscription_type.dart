enum SubscriptionEnum {
  paying("paying", "Assinante"),
  nonPaying("nonPaying", "Não assinante");

  final String name;
  final String value;
  const SubscriptionEnum(this.name, this.value);
}
