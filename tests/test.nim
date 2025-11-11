import std/[random, algorithm, unittest]
import quickselect

suite "quickselect tests":
  test "finds minimum (k=0)":
    let data = @[5, 2, 9, 1, 7, 3]
    check quickselect(data, 0) == 1

  test "finds maximum (k=n-1)":
    let data = @[5, 2, 9, 1, 7, 3]
    check quickselect(data, data.high) == 9

  test "finds median in odd-length array":
    let data = @[5, 2, 9, 1, 7]
    check quickselect(data, 2) == 5

  test "finds median in even-length array":
    let data = @[5, 2, 9, 1, 7, 3]
    check quickselect(data, 3) == 5

  test "handles single element":
    let data = @[42]
    check quickselect(data, 0) == 42

  test "handles two elements":
    let data = @[5, 2]
    check quickselect(data, 0) == 2
    check quickselect(data, 1) == 5

  test "handles duplicates":
    let data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check quickselect(data, 0) == 1
    check quickselect(data, 4) == 4

  test "handles all identical elements":
    let data = @[7, 7, 7, 7, 7]
    check quickselect(data, 2) == 7

  test "handles sorted array":
    let data = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
    check quickselect(data, 4) == 5

  test "handles reverse sorted array":
    let data = @[9, 8, 7, 6, 5, 4, 3, 2, 1]
    check quickselect(data, 4) == 5

  test "raises on negative k":
    let data = @[1, 2, 3]
    expect(IndexDefect):
      discard quickselect(data, -1)

  test "raises on k >= len":
    let data = @[1, 2, 3]
    expect(IndexDefect):
      discard quickselect(data, 3)

  test "works with floats":
    let data = @[3.14, 1.41, 2.71, 0.57]
    check quickselect(data, 1) == 1.41

  test "works with strings":
    let data = @["zebra", "apple", "mango", "banana"]
    check quickselect(data, 0) == "apple"
    check quickselect(data, 3) == "zebra"

  test "large random array correctness":
    randomize(42)
    var data = newSeq[int](1000)
    for i in 0..<1000:
      data[i] = rand(10000)

    let sorted = sorted(data)
    for k in [0, 100, 499, 500, 999]:
      check quickselect(data, k) == sorted[k]


suite "quickselectInplace tests":
  test "finds minimum (k=0)":
    var data = @[5, 2, 9, 1, 7, 3]
    check quickselectInplace(data, 0) == 1

  test "finds maximum (k=n-1)":
    var data = @[5, 2, 9, 1, 7, 3]
    check quickselectInplace(data, data.high) == 9

  test "finds median in odd-length array":
    var data = @[5, 2, 9, 1, 7]
    check quickselectInplace(data, 2) == 5

  test "finds median in even-length array":
    var data = @[5, 2, 9, 1, 7, 3]
    check quickselectInplace(data, 3) == 5

  test "handles single element":
    var data = @[42]
    check quickselectInplace(data, 0) == 42

  test "handles two elements":
    var data = @[5, 2]
    check quickselectInplace(data, 0) == 2
    data = @[5, 2]
    check quickselectInplace(data, 1) == 5

  test "handles duplicates":
    var data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check quickselectInplace(data, 0) == 1
    data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check quickselectInplace(data, 4) == 4

  test "handles all identical elements":
    var data = @[7, 7, 7, 7, 7]
    check quickselectInplace(data, 2) == 7

  test "handles sorted array":
    var data = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
    check quickselectInplace(data, 4) == 5

  test "handles reverse sorted array":
    var data = @[9, 8, 7, 6, 5, 4, 3, 2, 1]
    check quickselectInplace(data, 4) == 5

  test "raises on negative k":
    var data = @[1, 2, 3]
    expect(IndexDefect):
      discard quickselectInplace(data, -1)

  test "raises on k >= len":
    var data = @[1, 2, 3]
    expect(IndexDefect):
      discard quickselectInplace(data, 3)

  test "works with floats":
    var data = @[3.14, 1.41, 2.71, 0.57]
    check quickselectInplace(data, 1) == 1.41

  test "works with strings":
    var data = @["zebra", "apple", "mango", "banana"]
    check quickselectInplace(data, 0) == "apple"
    data = @["zebra", "apple", "mango", "banana"]
    check quickselectInplace(data, 3) == "zebra"

  test "large random array correctness":
    randomize(42)
    for k in [0, 100, 499, 500, 999]:
      var data = newSeq[int](1000)
      for i in 0..<1000:
        data[i] = rand(10000)
      let sorted = sorted(data)
      check quickselectInplace(data, k) == sorted[k]

  test "actually modifies array in-place":
    var data = @[5, 2, 9, 1, 7, 3]
    let original = data
    let result = quickselectInplace(data, 2)
    check result == 3  # sorted: [1, 2, 3, 5, 7, 9], k=2 is 3
    check data != original  # array should be modified

  test "result is at correct position after partial sort":
    var data = @[5, 2, 9, 1, 7, 3]
    let result = quickselectInplace(data, 2)
    check data[2] == result

  test "partitioning invariant holds":
    var data = @[5, 2, 9, 1, 7, 3, 8, 4, 6]
    let k = 4
    let result = quickselectInplace(data, k)
    # all elements before k should be <= result
    for i in 0..<k:
      check data[i] <= result
    # all elements after k should be >= result
    for i in (k+1)..<data.len:
      check data[i] >= result


suite "floydRivest tests":
  test "finds minimum (k=0)":
    let data = @[5, 2, 9, 1, 7, 3]
    check floydRivest(data, 0) == 1

  test "finds maximum (k=n-1)":
    let data = @[5, 2, 9, 1, 7, 3]
    check floydRivest(data, data.high) == 9

  test "finds median in odd-length array":
    let data = @[5, 2, 9, 1, 7]
    check floydRivest(data, 2) == 5

  test "finds median in even-length array":
    let data = @[5, 2, 9, 1, 7, 3]
    check floydRivest(data, 3) == 5

  test "handles single element":
    let data = @[42]
    check floydRivest(data, 0) == 42

  test "handles two elements":
    let data = @[5, 2]
    check floydRivest(data, 0) == 2
    check floydRivest(data, 1) == 5

  test "handles duplicates":
    let data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check floydRivest(data, 0) == 1
    check floydRivest(data, 4) == 4

  test "handles all identical elements":
    let data = @[7, 7, 7, 7, 7]
    check floydRivest(data, 2) == 7

  test "handles sorted array":
    let data = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
    check floydRivest(data, 4) == 5

  test "handles reverse sorted array":
    let data = @[9, 8, 7, 6, 5, 4, 3, 2, 1]
    check floydRivest(data, 4) == 5

  test "raises on negative k":
    let data = @[1, 2, 3]
    expect(IndexDefect):
      discard floydRivest(data, -1)

  test "raises on k >= len":
    let data = @[1, 2, 3]
    expect(IndexDefect):
      discard floydRivest(data, 3)

  test "works with floats":
    let data = @[3.14, 1.41, 2.71, 0.57]
    check floydRivest(data, 1) == 1.41

  test "works with strings":
    let data = @["zebra", "apple", "mango", "banana"]
    check floydRivest(data, 0) == "apple"
    check floydRivest(data, 3) == "zebra"

  test "large random array correctness":
    randomize(42)
    var data = newSeq[int](1000)
    for i in 0..<1000:
      data[i] = rand(10000)

    let sorted = sorted(data)
    for k in [0, 100, 499, 500, 999]:
      check floydRivest(data, k) == sorted[k]


suite "floydRivestInplace tests":
  test "finds minimum (k=0)":
    var data = @[5, 2, 9, 1, 7, 3]
    check floydRivestInplace(data, 0) == 1

  test "finds maximum (k=n-1)":
    var data = @[5, 2, 9, 1, 7, 3]
    check floydRivestInplace(data, data.high) == 9

  test "finds median in odd-length array":
    var data = @[5, 2, 9, 1, 7]
    check floydRivestInplace(data, 2) == 5

  test "finds median in even-length array":
    var data = @[5, 2, 9, 1, 7, 3]
    check floydRivestInplace(data, 3) == 5

  test "handles single element":
    var data = @[42]
    check floydRivestInplace(data, 0) == 42

  test "handles two elements":
    var data = @[5, 2]
    check floydRivestInplace(data, 0) == 2
    data = @[5, 2]
    check floydRivestInplace(data, 1) == 5

  test "handles duplicates":
    var data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check floydRivestInplace(data, 0) == 1
    data = @[3, 1, 4, 1, 5, 9, 2, 6, 5]
    check floydRivestInplace(data, 4) == 4

  test "handles all identical elements":
    var data = @[7, 7, 7, 7, 7]
    check floydRivestInplace(data, 2) == 7

  test "handles sorted array":
    var data = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
    check floydRivestInplace(data, 4) == 5

  test "handles reverse sorted array":
    var data = @[9, 8, 7, 6, 5, 4, 3, 2, 1]
    check floydRivestInplace(data, 4) == 5

  test "raises on negative k":
    var data = @[1, 2, 3]
    expect(IndexDefect):
      discard floydRivestInplace(data, -1)

  test "raises on k >= len":
    var data = @[1, 2, 3]
    expect(IndexDefect):
      discard floydRivestInplace(data, 3)

  test "works with floats":
    var data = @[3.14, 1.41, 2.71, 0.57]
    check floydRivestInplace(data, 1) == 1.41

  test "works with strings":
    var data = @["zebra", "apple", "mango", "banana"]
    check floydRivestInplace(data, 0) == "apple"
    data = @["zebra", "apple", "mango", "banana"]
    check floydRivestInplace(data, 3) == "zebra"

  test "large random array correctness":
    randomize(42)
    for k in [0, 100, 499, 500, 999]:
      var data = newSeq[int](1000)
      for i in 0..<1000:
        data[i] = rand(10000)
      let sorted = sorted(data)
      check floydRivestInplace(data, k) == sorted[k]

  test "actually modifies array in-place":
    var data = @[5, 2, 9, 1, 7, 3]
    let original = data
    let result = floydRivestInplace(data, 2)
    check result == 3  # sorted: [1, 2, 3, 5, 7, 9], k=2 is 3
    check data != original  # array should be modified

  test "result is at correct position after partial sort":
    var data = @[5, 2, 9, 1, 7, 3]
    let result = floydRivestInplace(data, 2)
    check data[2] == result

  test "partitioning invariant holds":
    var data = @[5, 2, 9, 1, 7, 3, 8, 4, 6]
    let k = 4
    let result = floydRivestInplace(data, k)
    # all elements before k should be <= result
    for i in 0..<k:
      check data[i] <= result
    # all elements after k should be >= result
    for i in (k+1)..<data.len:
      check data[i] >= result

  test "handles large arrays triggering recursive sampling":
    # test with array > 600 elements to trigger the recursive sampling path
    randomize(123)
    var data = newSeq[int](1000)
    for i in 0..<1000:
      data[i] = rand(10000)

    let sorted = sorted(data)
    let k = 500
    let result = floydRivestInplace(data, k)
    check result == sorted[k]


suite "algorithm comparison":
  test "both algorithms produce same results":
    randomize(123)
    var data = newSeq[int](500)
    for i in 0..<500:
      data[i] = rand(5000)

    for k in [0, 50, 249, 250, 499]:
      check quickselect(data, k) == floydRivest(data, k)

  test "both handle edge cases identically":
    let testCases = @[
      @[1],
      @[2, 1],
      @[5, 5, 5],
      @[1, 2, 3, 4, 5]
    ]

    for data in testCases:
      for k in 0..<data.len:
        check quickselect(data, k) == floydRivest(data, k)

  test "inplace versions produce same results as copying versions":
    randomize(456)
    var data = newSeq[int](500)
    for i in 0..<500:
      data[i] = rand(5000)

    for k in [0, 50, 249, 250, 499]:
      let expected = quickselect(data, k)
      var copy1 = data
      var copy2 = data
      check quickselectInplace(copy1, k) == expected
      check floydRivestInplace(copy2, k) == expected
