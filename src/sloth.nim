type
  Lazy*[T] = object
    f: proc(): T {.noSideEffect.}
  LazyImpure*[T] = object
    f: proc(): T

template lazy*[T](x: T): Lazy[T] =
  Lazy[T](f: func(): T = x)

converter `[]`*[T](l: Lazy[T]): T =
  l.f()

template lazyImpure*[T](x: T): LazyImpure[T] =
  LazyImpure[T](f: proc(): T = x)

converter `[]`*[T](l: LazyImpure[T]): T =
  l.f()
