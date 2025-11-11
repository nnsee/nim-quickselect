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

Run `nim c -r -d:release src/quickselect.nim` to see performance comparisons on your machine.

Sample run from my machine (AMD Ryzen 7 PRO 7840U (16) @ 5.13 GHz):
```sh
=== array size: 1000 ===
quickselect avg: 0.01 ms
floydRivest avg: 0.00 ms
sort avg:        0.03 ms
quickselect vs sort: 3.50x
floydRivest vs sort: 7.47x
floydRivest vs qs:   2.13x

=== array size: 10000 ===
quickselect avg: 0.07 ms
floydRivest avg: 0.03 ms
sort avg:        0.83 ms
quickselect vs sort: 11.68x
floydRivest vs sort: 32.42x
floydRivest vs qs:   2.78x

=== array size: 100000 ===
quickselect avg: 0.71 ms
floydRivest avg: 0.48 ms
sort avg:        8.98 ms
quickselect vs sort: 12.65x
floydRivest vs sort: 18.87x
floydRivest vs qs:   1.49x

=== array size: 500000 ===
quickselect avg: 3.60 ms
floydRivest avg: 1.75 ms
sort avg:        54.50 ms
quickselect vs sort: 15.15x
floydRivest vs sort: 31.10x
floydRivest vs qs:   2.05x

=== array size: 1000000 ===
quickselect avg: 7.36 ms
floydRivest avg: 3.64 ms
sort avg:        109.60 ms
quickselect vs sort: 14.90x
floydRivest vs sort: 30.07x
floydRivest vs qs:   2.02x

=== array size: 5000000 ===
quickselect avg: 37.66 ms
floydRivest avg: 18.97 ms
sort avg:        646.20 ms
quickselect vs sort: 17.16x
floydRivest vs sort: 34.06x
floydRivest vs qs:   1.98x
```

## Testing

```bash
nimble test
```

## License

MIT
