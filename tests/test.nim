import sloth
import std/unittest

suite "lazy evaluation":
  test "pure lazy values":
    var plusCalled = 0
    proc plus(a, b: int): int =
      {.cast(noSideEffect).}:
        plusCalled += 1
      a + b
    let n = plus(2, 3)
    check plusCalled == 1
    check n == 5
    check plusCalled == 1
    let l = lazy(plus(2, 3))
    check plusCalled == 1
    check l == 5
    check plusCalled == 2
  test "impure lazy values":
    var plusCalled = 0
    proc plus(a, b: int): int =
      plusCalled += 1
      a + b
    let n = plus(2, 3)
    check plusCalled == 1
    check n == 5
    check plusCalled == 1
    let l = lazyImpure(plus(2, 3))
    check plusCalled == 1
    check l == 5
    check plusCalled == 2
