# swift-paramorphism

Use this package when a fold over a recursive enum needs, at each layer, both the original child and the result already computed for it, for example to inspect the shape of a subterm while combining its folded value. Start from the `@Paramorphism` macro, attached to an enum that also carries `@Recursive` and `@FunctorBase`; it adds a `paramorphism` method whose algebra receives one layer of the enum's `Base` functor holding `Product` pairs. When the original child is not needed, use swift-catamorphism; when the results of every earlier layer are needed, use swift-histomorphism; when an auxiliary fold runs alongside, use swift-zygomorphism.

## Laws

- Each recursive position of the layer passed to the algebra holds a `Product` whose `values.0` is the original child and whose `values.1` is that child's own paramorphism under the same algebra.
- A layer with no recursive positions is passed to the algebra directly, so a base case folds without visiting any child.
- Children are folded before their parent, by direct recursion: every subterm is folded once per call, the stack grows with the depth of the value, and nothing is cached between calls.
- The generated method is `public` when the enum is declared `public`, and has default access otherwise.
- Attaching `@Paramorphism` to anything other than an enum is a compile-time error.
