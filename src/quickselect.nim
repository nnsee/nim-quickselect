## Quickselect and Floyd-Rivest selection algorithms
##
## This module provides efficient algorithms for finding the kth smallest element
## in an unsorted array without fully sorting it.
##
## Floyd-Rivest is generally roughly 2x faster than Quickselect. However, depending
## on the shape of the data you're working with, Quickselect might be a better option.

import std/[random, math]

proc floydRivestImpl[T](data: var seq[T], left, right, k: int) =
  var left = left
  var right = right

  while right > left:
    # use select recursively to sample a smaller set
    if right - left > 600:
      let n = float(right - left + 1)
      let i = float(k - left + 1)
      let kf = float(k)
      let z = ln(n.float)
      let s = 0.5 * exp(2.0 * z / 3.0)
      let sd = 0.5 * sqrt(z * s * (n - s) / n) * float(sgn(i - n / 2.0))
      let newLeft = max(left, int(kf - i * s / n + sd))
      let newRight = min(right, int(kf + (n - i) * s / n + sd))
      floydRivestImpl(data, newLeft, newRight, k)

    # partition around pivot at k
    let t = data[k]
    var i = left
    var j = right

    swap(data[left], data[k])
    if data[right] > t:
      swap(data[right], data[left])

    while i < j:
      swap(data[i], data[j])
      inc i
      dec j
      while data[i] < t:
        inc i
      while data[j] > t:
        dec j

    if data[left] == t:
      swap(data[left], data[j])
    else:
      inc j
      swap(data[j], data[right])

    # adjust left and right
    if j <= k:
      left = j + 1
    if k <= j:
      right = j - 1

proc floydRivest*[T](arr: openArray[T], k: int): T =
  ## Find the kth smallest element using Floyd-Rivest algorithm.
  ##
  ## This is typically faster than quickselect for most arrays.
  ##
  ## Average time complexity: O(n)
  runnableExamples:
    let data = @[3, 1, 4, 1, 5, 9, 2, 6]
    assert floydRivest(data, 0) == 1  # smallest
    assert floydRivest(data, 4) == 4  # 5th smallest / median

  if k < 0 or k >= arr.len:
    raise newException(IndexDefect, "k out of bounds")

  var data = @arr
  floydRivestImpl(data, 0, data.high, k)
  return data[k]


proc quickselectImpl[T](data: var seq[T], left, right, k: int): T =
  if left == right:
    return data[left]

  # random pivot
  let pivotIdx = rand(left..right)
  let pivotValue = data[pivotIdx]

  # partition
  swap(data[pivotIdx], data[right])
  var storeIdx = left
  for i in left..<right:
    if data[i] < pivotValue:
      swap(data[i], data[storeIdx])
      inc storeIdx
  swap(data[storeIdx], data[right])

  # recurse
  if k == storeIdx:
    return data[k]
  elif k < storeIdx:
    return quickselectImpl(data, left, storeIdx - 1, k)
  else:
    return quickselectImpl(data, storeIdx + 1, right, k)

proc quickselect*[T](arr: openArray[T], k: int): T =
  ## Find the kth smallest element using the Quickselect algorithm.
  ## Uses a random point for the pivots. You may optionally call
  ## randomize().
  ##
  ## Average time complexity: O(n)
  ##
  ## Worst case: O(n²)
  runnableExamples:
    let data = @[3, 1, 4, 1, 5, 9, 2, 6]
    assert quickselect(data, 0) == 1  # smallest
    assert quickselect(data, 4) == 4  # 5th smallest / median

  if k < 0 or k >= arr.len:
    raise newException(IndexDefect, "k out of bounds")

  var data = @arr
  return quickselectImpl(data, 0, data.high, k)


when isMainModule:
  import std/[algorithm, times]
  randomize()

  const numTrials = 5
  const sizes = [1_000, 10_000, 100_000, 500_000, 1_000_000, 5_000_000]

  for n in sizes:
    echo "\n=== array size: ", n, " ==="

    var data = newSeq[int](n)
    for i in 0..<n:
      data[i] = rand(int.high)

    let k = n div 2 # median
    let sorted = sorted(data)
    let expected = sorted[k]

    # benchmark quickselect
    var quickselectTime = 0.0
    for _ in 0..<numTrials:
      let start = cpuTime()
      let result = quickselect(data, k)
      quickselectTime += cpuTime() - start
      assert result == expected, "quickselect incorrect"

    quickselectTime /= numTrials.float

    # benchmark floydRivest
    var floydRivestTime = 0.0
    for _ in 0..<numTrials:
      let start = cpuTime()
      let result = floydRivest(data, k)
      floydRivestTime += cpuTime() - start
      assert result == expected, "floydRivest incorrect"

    floydRivestTime /= numTrials.float

    # benchmark sort
    var sortTime = 0.0
    for _ in 0..<numTrials:
      var copy = data
      let start = cpuTime()
      copy.sort()
      sortTime += cpuTime() - start

    sortTime /= numTrials.float

    echo "quickselect avg: ", quickselectTime * 1000, " ms"
    echo "floydRivest avg: ", floydRivestTime * 1000, " ms"
    echo "sort avg: ", sortTime * 1000, " ms"
    echo "quickselect vs sort: ", sortTime / quickselectTime, "x"
    echo "floydRivest vs sort: ", sortTime / floydRivestTime, "x"
    echo "floydRivest vs quickselect: ", quickselectTime / floydRivestTime, "x"
