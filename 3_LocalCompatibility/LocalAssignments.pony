
class A
  var i : U32

  new create(i':U32) =>
    i = i'

class B

 new create( ) =>
   this

  fun ref test( ) =>
    // ignote the initialization part
    var a_iso : A iso = recover iso A(1) end
    var a_iso': A iso = recover iso A(2) end
    var a_ref : A ref =  A(3)
    var a_val : A val =  recover val A(4) end
    var a_box : A box = A(5)
    var a_tag : A tag = A(6)
    // which of the assigments below are type correct
      a_iso = a_ref
      a_iso = a_iso'
      a_ref = a_iso
      a_ref = a_box
      a_val = a_ref
      a_val = a_box
      a_box = a_ref
      a_box = a_val
      a_tag = a_iso
      a_tag = a_val

actor Main
   new create(env: Env) =>
      env.out.print("Checcking local compatibility")
      let b : B ref = B
      b.test()
