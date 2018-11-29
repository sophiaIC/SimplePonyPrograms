class IdentityData

  let name : String val
  let natInsuranceNumber : U32

  new val create(name': String) =>
    name = name'
    natInsuranceNumber = 1000

  fun get_name() : String =>
    name

actor Person

  let id: IdentityData val
  var strength: U64
  let env : Env

  new create(name': String, strength': U64,e:Env) =>
    id =  IdentityData(name')
    strength = strength'
    env=e
    env.out.print(name'.string()+" is "
                  +strength.string()+" strong")

  be eat(food: Food iso)  =>    // change fun ref to be
                                // change the fun to a behaviour
    strength = strength + food.take_a_bite()
    env.out.print(id.get_name().string()+" eats a "+food.name.string()
                  +" and gets "+strength.string()+" strong")

class Food
 let name: String
 var calories: U64

 new create(name': String, calories': U64) =>
   name = name'
   calories = calories'

 fun ref take_a_bite( ) : U64 =>
    calories = calories/2
    calories/3

actor Main
  let env : Env
  var apple : Food iso = recover  iso Food("apple",50) end

  new create(env':Env) =>
    env = env'
    run()

  be run( )   =>
    let pear: Food iso = recover iso Food("pear",160) end
    let laurie: Person tag = Person("Laurie",400,env)
    let jan: Person tag = Person("Jan",300,env)
    jan.eat(consume pear)
    laurie.eat(this.apple= recover iso Food("placeholder",-160) end)
