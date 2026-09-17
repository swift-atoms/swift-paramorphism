import Paramorphism_Macro
import Product
import Testing

@Paramorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `paramorphism exposes each child and its folded result`() {
    let two = Natural.successor(.successor(.zero))
    let count = two.paramorphism {
        (layer: Natural.Base<Product<Natural, Int>>) -> Int in
        switch layer {
        case .zero: 0
        case let .successor(child): child.values.1 + 1
        }
    }
    #expect(count == 2)
}
