use "random"

actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")
    let act1 : Act = Act(env,"   A", 100)
    let act2 : Act = Act(env,"        B", 1000)
    let act3 : Act = Act(env,"             C", 120)
    let act4 : Act = Act(env,"                   D", 220)
    let act5 : Act = Act(env,"                        E", 340)
    var i : U32 = 1
    while (i<1000) do
        i = i+1
        act1.poke()
        act2.poke()
        act3.poke()
        act4.poke()
        act5.poke()
    end

actor Act
    let env : Env
    let str : String
    let lim : U64

    fun busyWaiting(limit: U64): U64 =>
        var test: U64 = 0
        var k: U64 = 0

        while (k < limit) do
            MT.real()
            test = test + 1
            k = k + 1
        end
    test

    new create(e: Env, s: String, l: U64) =>
        env = e
        str = s
        lim  = l

    be poke() =>
       let i : U64 = busyWaiting(10*lim)
             env.out.print(str)
