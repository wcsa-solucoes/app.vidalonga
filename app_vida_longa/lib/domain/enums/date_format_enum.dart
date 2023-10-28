enum DateFormatEnum {
  ddMmYyyy("dd/MM/yyyy"),
  h24Mm("HH:mm"),
  h12Mm("hh:mm"),
  h24MmSs("HH:mm:ss"),
  h12MmSs("hh:mm:ss"),
  h24MmDdMmYyyy("HH:mm dd/MM/yyyy"),
  h24MmHyphenDdMmYyyy("HH:mm - dd/MM/yyyy"),
  h12MmDdMmYyyy("hh:mm dd/MM/yyyy"),
  h24MmSsDdMmYyyy("HH:mm:ss dd/MM/yyyy"),
  h12MmSsDdMmYyyy("hh:mm:ss dd/MM/yyyy");

  final String value;

  const DateFormatEnum(this.value);
}
