import Functor_Base_Macro
import Recursive_Macro
import Paramorphism_Macro
import Product
import Testing

@FunctorBase
@Recursive
@Paramorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

@Suite
struct `Paramorphism boundaries` {
    @Test
    func `the base case folds without a child`() {
        let result = Count.zero.paramorphism { (layer: Count.Base<Product<Count, Int>>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child.values.1 + 1
            }
        }
        #expect(result == 0)
    }

    @Test
    func `each layer sees its original child next to the folded one`() {
        let three = Count.successor(.successor(.successor(.zero)))
        let childIsZero = three.paramorphism { (layer: Count.Base<Product<Count, [Bool]>>) -> [Bool] in
            switch layer {
            case .zero: []
            case let .successor(child):
                if case .zero = child.values.0 { child.values.1 + [true] } else { child.values.1 + [false] }
            }
        }
        #expect(childIsZero == [true, false, false])
    }
}
