use "random"
use "collections"

actor Main
  let env  : Env
  var mt : MT

  new create(e: Env) =>
    env = e
    run( )
    mt = MT

  be run( ) =>
      env.out.print("--- Checking causality ---")
      let b : Bank = Bank(env)
      let s : Store  = Store(b)
      let c1 : Customer = Customer(s,b)
      let c2 : Customer = Customer(s,b)
      let c3 : Customer = Customer(s,b)
      let c4 : Customer = Customer(s,b)
      let limit : U16 = 130
      var k: U16 = 0
      run2(c1,c2,c3,c4,limit)

    be run2(c1:Customer, c2:Customer, c3:Customer, c4:Customer, limit: U16 ) =>
      if (limit>0) then
        c1.run()
        c2.run()
        c3.run()
        c4.run()
        run2(c1,c2,c3,c4,limit-1)
      end

trait Waiting

  fun busyWait(mt:Random): U16 =>
          var test: U16 = 0
          var k: U16 = 0
          let limit : U16 = mt.u16()
          while (k < limit) do
              MT.real()
              test = test + 1
              k = k + 1000
          end
          test

actor Customer is Waiting
  let _store : Store
  let _bank : Bank
  let _mt : MT ref

new create(s:Store, b:Bank) =>
  _store = s
  _bank = b
  _mt = MT

 be run() =>
    busyWait(_mt)
    let price : U8 = _mt.u8()
    _bank.credit(this,price.u32())
    _store.buy(this,price.u32())
    busyWait(_mt)

actor Store  is Waiting
  let _bank : Bank
  let _mt : Random ref

  new create(b:Bank) =>
     _bank = b
     _mt = MT

  be buy(cust:Customer, price: U32) =>
    busyWait(_mt)
    _bank.debit(cust,price)
    busyWait(_mt)

actor Bank   is Waiting
  let _mt : MT ref
  let _env : Env
  let _balances : MapIs[Customer,U32] ref

  new create(env:Env) =>
    _mt = MT
    _env = env
    _balances = MapIs[Customer,U32]()

  be credit(cust:Customer, amount: U32) =>
    busyWait(_mt)
    let b = _balances.get_or_else(cust,0)
    let balance = b+amount
    _balances.update(cust,balance)
    if (balance<b) then
         _env.out.print(" ============ OVERFLOW ============ ")
    end
    busyWait(_mt)

  be debit(cust:Customer, price: U32) =>
      busyWait(_mt)
    try
      var balance = _balances(cust)
       if balance < price then
          _env.out.print(" ============ HORROR, no moneys ============ ")
          error
       end
       _env.out.print(" OK ")
       _balances.update(cust,balance-price)
       busyWait(_mt)
    else
      _env.out.print(" ============ HORROR, not found ============ ")
    end
