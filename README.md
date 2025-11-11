# Quickselect

Nim implementation of the Quickselect and Floyd-Rivest selection algorithms for finding the kth smallest element in an unsorted array.

## Installation

```bash
nimble install quickselect
```

## Usage

```nim
import quickselect

let data = @[3, 1, 4, 1, 5, 9, 2, 6]

# Find the smallest element (k=0)
echo quickselect(data, 0)

let median = data.high div 2

# Find the median
echo quickselect(data, median)

# Use Floyd-Rivest
echo floydRivest(data, median)
```

## Algorithms

In most cases, you should prefer Floyd-Rivest as it performs better on average. On random data, this difference is roughly ~2x compared to Quickselect.

### Quickselect

<https://en.wikipedia.org/wiki/Quickselect?useskin=vector>

- Average time complexity: O(n)
- Worst case: O(n²)
- Uses random pivot selection, so you may optionally call `randomize()` beforehand (the library does not do this for you)

### Floyd-Rivest

<https://en.wikipedia.org/wiki/Floyd%E2%80%93Rivest_algorithm?useskin=vector>, <https://people.csail.mit.edu/rivest/pubs/FR75b.pdf>

- Average time complexity: O(n)
- Typically faster than quickselect for most arrays, but especially large ones
- Uses statistical sampling to choose better pivots

## Benchmarking

Run `nim c -r -d:release src/quickselect.nim` to see performance comparisons.

## Testing

```bash
nimble test
```

## License

MIT
