
import "com/delivery/cargo_booking.dart";
import "com/delivery/transport.dart" as transport;
import "com/delivery/delivery.dart" as delivery;


void main() {
  
  Contract contract = doCargoBooking();

  doTransport(contract);
  
  doDelivery();
}

Contract doCargoBooking() {
  
  var repos = new ContractRepository();
  
  var receiver = new Receiver("hoge");
  var sender = new Sender("sender");
  var cargo = new Cargo(100, Size.M);
  
  var contract = new Contract(receiver, sender, cargo);
  
  repos.add(contract);
  
  var result = repos.findBy(contract.id);
  
  print("contract : ${contract.id}");
  
  assert(contract.cargo.size == Size.M);
  assert(contract.cargo.weight == 100);
  assert(contract.sender == sender);
  assert(contract.receiver == receiver);
  return contract;
}

void doTransport(Contract contract) {
  
  // Enterprise Segment
  num cargoId = new CargoIdentifier().toCargoId(contract.id);
  var deliveryCenters = new RoutingService().routing(contract.receiver, contract.sender);
  
  var handlingEvents = new transport.HandlingEventRepository();
  
  var newCargo = new transport.Cargo(cargoId, deliveryCenters);

  print("newCargo : ${newCargo.id}");
  
  assert(handlingEvents.findEventsByContract(newCargo) == null);

  var event1 = new transport.HandlingEvent.move(from : AICHI, to : MIE);
  handlingEvents.addEvent(newCargo, event1);
  
  var event2 = new transport.HandlingEvent.move(from : MIE, to : WAKAYAMA);
  handlingEvents.addEvent(newCargo, event2);
  
  assert(handlingEvents.findEventsByContract(newCargo)[0].carrierMovement.from == AICHI);
  assert(handlingEvents.findEventsByContract(newCargo)[1].carrierMovement.to == WAKAYAMA);
}

class CargoIdentifier {
  // for DI
  CargoIdentifier._();
  factory CargoIdentifier() => new CargoIdentifier._();
  
  num toCargoId(num contractId) {
    //TODO XD
    return contractId * 2;
  }
}

const AICHI = const transport.DeliveryCenter("Aichi");
const MIE = const transport.DeliveryCenter("Mie");
const WAKAYAMA = const transport.DeliveryCenter("Wakayama");
const NARA = const transport.DeliveryCenter("Nara");
const KYOTO = const transport.DeliveryCenter("Kyoto");

class RoutingService {
  // for DI
  RoutingService._();
  factory RoutingService() => new RoutingService._();
  
  List<transport.DeliveryCenter> routing(Receiver receiver, Sender sender) {
    var list = [];
    list.add(AICHI);
    list.add(MIE);
    list.add(WAKAYAMA);
    list.add(NARA);
    list.add(KYOTO);
    return list;
  }
}

void doDelivery() {
  // Need more consider...
  
  var repos = new delivery.DeliveryRepository();
  
  Date plandDate = new Date(2013, 4, 16);
  var cargo = new delivery.Cargo(100);
  var receiver = new delivery.Receiver("sender");
  var driver = new delivery.Driver("gen san");
  
  var plan = new delivery.DeliveryPlan(plandDate, cargo, receiver, driver);
  repos.addPlan(plan);
  
  var actual = new delivery.DeliveryActual.notYet(plan, new Date(2013, 4, 13), driver);
  repos.addActual(actual);
  
  // I want to have a group of Plan & Actual like a "tupple" ...
  // ex. [DeliveryPlan : DeliveryActual = 1 : 1]
}