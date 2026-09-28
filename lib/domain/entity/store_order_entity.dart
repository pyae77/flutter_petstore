class OrderEntity {
  final int id;
  final int petId;
  final int quantity;
  final DateTime? shipDate;
  final String status;
  final bool complete;

  const OrderEntity({
    required this.id,
    required this.petId,
    required this.quantity,
    this.shipDate,
    required this.status,
    required this.complete,
  });
}