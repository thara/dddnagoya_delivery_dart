library delivery;

class Cargo {
  final num id;
  Cargo(this.id);
}

class DeliveryPlan {
  final Date planedDate;
  final Cargo cargo;
  final Receiver receiver;
  final Driver planedDriver;
  
  DeliveryPlan(this.planedDate, this.cargo, this.receiver, this.planedDriver);
}

class DeliveryActual {
  final DeliveryPlan plan;
  final Date actualDate;
  final Driver actualDriver;
  final bool completed;
  
  DeliveryActual(this.plan, this.actualDate, this.actualDriver, this.completed);
  
  DeliveryActual.completion(DeliveryPlan plan, Date actualDate, Driver actualDriver) 
    : this(plan, actualDate, actualDriver, true);
  
  DeliveryActual.notYet(DeliveryPlan plan, Date actualDate, Driver actualDriver) 
    : this(plan, actualDate, actualDriver, false);
}

class DeliveryRepository {
  
  final Map<num, List<DeliveryPlan>> plans = new Map();
  final Map<num, List<DeliveryActual>> actuals = new Map();
  
  void addPlan(DeliveryPlan plan) {
    plans.putIfAbsent(plan.cargo.id, () => []).add(plan);
  }
  
  void addActual(DeliveryActual actual) {
    actuals.putIfAbsent(actual.plan.cargo.id, () => []).add(actual);
  }
}

class Receiver {
  final String name;
  Receiver(this.name);
}

class Driver {
  final String name;
  Driver(this.name);
}