import sloth
import std/sequtils
import std/unittest

template defineCounter() {.dirty.} =
  var counter = 0
  proc count[T](x: T): T =
    inc counter
    x

template checkCount(n: int, body: untyped) =
  counter = 0
  body
  check counter == n

suite "lazy evaluation":
  test "lazy values":
    defineCounter
    checkCount 1:
      let n = count(2 + 3)
    checkCount 0:
      check n == 5
    checkCount 0:
      let l = lazy(count(2 + 3))
    checkCount 1:
      check l == 5
suite "lazy lists":
  test "construction, head, tail":
    defineCounter
    checkCount 0:
      let list = cons(count(6), cons(count(2), cons(count(8), nil)))
    checkCount 1:
      check list.head == 6
    checkCount 1:
      check list.tail.head == 2
    checkCount 1:
      check list.tail.tail.head == 8
  test "construction, iterating":
    defineCounter
    checkCount 0:
      let list = cons(count(6), cons(count(2), cons(count(8), nil)))
    checkCount 3:
      check toSeq(list).mapIt(it[]) == @[6, 2, 8]
  test "construction, indexing":
    defineCounter
    checkCount 0:
      let list = cons(count(6), cons(count(2), cons(count(8), nil)))
    checkCount 1:
      check list[0] == 6
    checkCount 1:
      check list[1] == 2
    checkCount 1:
      check list[2] == 8
  test "countup, indexing":
    let c = lazyCountup(42)
    for i in 0..100:
      check c[i] == 42 + i
  test "nats, indexing":
    for i in 0..100:
      check lazyNats[i] == i
