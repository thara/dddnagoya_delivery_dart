library transport;

class Cargo {
  final num id;
  final _TransportSpec _spec = new _TransportSpec();

  Cargo._(this.id);
  
  factory Cargo(num id, List<DeliveryCenter> deliveryCenters) {
    Cargo newCargo = new Cargo._(id);
    newCargo._spec.deliveryCenters.addAll(deliveryCenters);
    return newCargo;
  }
}

class _TransportSpec {
 final List<DeliveryCenter> deliveryCenters = [];
}

class DeliveryCenter {
  final String name;
  const DeliveryCenter(this.name);
}

class HandlingEvent {
  final CarrierMovement carrierMovement;
  
  HandlingEvent(this.carrierMovement);
  
  HandlingEvent.move({DeliveryCenter from, DeliveryCenter to}) 
    : this.carrierMovement = new CarrierMovement(from, to);
}

class HandlingEventRepository {
  
  final Map<num, List<HandlingEvent>> store = new Map();
  
  void addEvent(Cargo cargo, HandlingEvent event) {
    store.putIfAbsent(cargo.id, () => []).add(event);
  }
  
  List<HandlingEvent> findEventsByContract(Cargo cargo) {
    return store[cargo.id];
  }
}

class CarrierMovement {
  
  final DeliveryCenter from;
  final DeliveryCenter to;
  
  CarrierMovement(this.from, this.to);
}