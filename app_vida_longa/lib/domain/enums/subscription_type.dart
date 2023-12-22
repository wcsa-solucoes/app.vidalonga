enum SubscriptionTypeEnum {
  free("free"),
  basic("basic"),
  premium("premium"),
  custom("custom"),
  paid("paid");

  final String name;
  const SubscriptionTypeEnum(this.name);
}
