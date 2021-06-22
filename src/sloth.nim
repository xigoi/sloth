type
  Lazy*[T] = object
    f: proc(): T
  LazyList*[T] = ref object
    h: Lazy[T]
    t: Lazy[LazyList[T]]

template lazy*[T](x: T): Lazy[T] =
  Lazy[T](f: proc(): T = x)

converter `[]`*[T](x: Lazy[T]): T =
  x.f()

proc head*[T](xs: LazyList[T]): Lazy[T] =
  xs.h

proc tail*[T](xs: LazyList[T]): LazyList[T] =
  xs.t

template cons*[T](x: T, xs: LazyList[T]): LazyList[T] =
  LazyList[T](h: lazy(x), t: lazy(xs))

template cons*[T](x: T, xs: typeof(nil)): LazyList[T] =
  LazyList[T](h: lazy(x), t: lazy(LazyList[T](nil)))

iterator items*[T](xs: LazyList[T]): Lazy[T] =
  var xs = xs
  while xs != nil:
    yield xs.head
    xs = xs.tail

proc `[]`*[T](xs: LazyList[T], i: Natural): Lazy[T] =
  var xs = xs
  for _ in 0..<i:
    xs = xs.tail
  xs.head

func lazyCountup*[T](start: T): LazyList[T] =
  cons(start, lazyCountup(start.succ))

let lazyNats* = lazyCountup(0)
