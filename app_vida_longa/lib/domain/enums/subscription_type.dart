enum SubscriptionEnum {
  paying("paying", "Premium"),
  nonPaying("nonPaying", "Comum");

  final String name;
  final String value;
  const SubscriptionEnum(this.name, this.value);
}
