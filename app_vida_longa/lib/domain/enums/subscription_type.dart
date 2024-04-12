enum SubscriptionEnum {
  paying("paying", "Assinante"),
  nonPaying("nonpaying", "Não assinante");

  final String name;
  final String value;
  const SubscriptionEnum(this.name, this.value);
}
