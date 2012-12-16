
library cargo_booking;

import "dart:math";

/**
 * Contract of one delivery.
 */
class Contract {
  
  static final rng = new Random();
  
  final num id;
  Receiver _receiver;
  Sender _sender;
  Cargo _cargo;
  
  Contract._Contract(num id) : id = id;
  
  factory Contract(Receiver receiver, Sender sender, Cargo cargo) {
    Contract c = new ContractFactory().create();
    c._receiver = receiver;
    c._sender = sender;
    c._cargo = cargo;
    return c;
  }
  
  Receiver get receiver => this._receiver;
  Sender get sender => this._sender;
  Cargo get cargo => this._cargo;
}

/**
 * A factory of [Contract].
 */
class ContractFactory {

  static final ContractFactory singleton = new ContractFactory._(99999);
  
  final Random rng = new Random();
  final num limit;
  
  ContractFactory._(this.limit);
  
  factory ContractFactory() {
    return singleton;
  }
  
  Contract create() {
    num id = rng.nextInt(limit);
    return  new Contract._Contract(id);
  }
}

/**
 * A repository of [Contract].
 */
class ContractRepository {
  
  final Map<num, Contract> store = new Map<num, Contract>();
  
  void add(Contract contract) {
    store[contract.id] = contract;
  }
  
  Contract findBy(num id) {
    return store[id];
  }
}

/**
 * A receiver
 */
class Receiver {
  final String name;
  Receiver(this.name);
}

/**
 * A sender.
 */
class Sender {
  final String name;
  Sender(this.name);
}

/**
 * A cargo.
 */
class Cargo {
  final num weight;
  final Size size;
  Cargo(this.weight, this.size);
}

/**
 * Category of cargo size.
 */
class Size {
  
  static final S = new Size("S");
  static final M = new Size("M");
  static final L = new Size("L");
  
  final String _name;
  const Size(this._name);
  
  String toString() => this._name;
}