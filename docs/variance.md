This is our example function:

```python
f: F
def f(x: X) -> Y:
  return y
z: Z = f()
```

Functions are contravariant in their arguments but covariant in their return
values, so in this case, `f` is contravariant in A but covariant in B. It also
means that `x` is contravariant in `A`, `z` is contravariant in `B`, and z is
covariant in `B`.

Contravariant `x` in `X` means:

- `x`'s type must be at least as specific as `X`
- `x` can be `list` even when `X` is `Sequence`
- type(x) is a subclass of X
- type(x) subset of X
- type(x) <= X

Contravariant `f` in `X` means:

- `x` can be `list` even when `X` is `Sequence`
- `f(Sequence)` is subset of `f(list)`
- `f(Sequence)` is a subclass of `f(list)`
- `f(Sequence)` <= `f(list)`
- if A1 >= A2 then f(A1) <= f(A2)
- `f(Sequence)` can be passed whereever a `f(list)` is accepted

y is contravariant in Y:

- `y`'s type must be at least as specific as `Y`
- `y` can be `list` even when `Y` is `Sequence`
- type(y) is a subclass of Y
- type(y) subset of Y
- type(y) <= Y
- if Sequence > list then y:Y=Sequence < y:Y=qqtuple
- if Y1 > Y2 then y:Y1 < y:Y2

Covariance of f in Y means:

- `f->list` is a smaller set than `f->Sequence`
- `f->list` is a subclass of `f->Sequence`
- `f->list` can be passed whereever a `f->Sequence` is accepted

```python
class A(B): pass
```

- A is a subclass of B
- A is smaller than B
- A <= B
- A[list] can be passed whereever A[Sequence] is accepted
- A[list] is a subclass of A[Sequence]
- A[list] < A[Sequence] because list < Sequence
- if B1 < B2 then A[B1] < A[B2]
- A is covariant in B

```python
f: F[X]
def f(x: X): ...
```

- F[Sequence] can be passed whereever F[list] is accepted
- F[Sequence] is a subclass of F[list]
- F[list] > F[Sequence] because list < Sequence
- if X1 < X2 then F[X1] > F[X2]
- F is contravariant in X

```python
T = TypeVar("T", bound=C)
```

- T <= C
- T is a subclass of C
- T can be passed whereever C is accepted
