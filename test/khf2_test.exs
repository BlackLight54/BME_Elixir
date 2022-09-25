defmodule KhfTest do
  use ExUnit.Case
  doctest Khf2
setup %{} do
  IO.puts("")
end
  test "Test0" do
    puzzle0 = {[-1, 0, 0, -3, 0], [0, 0, -2, 0, 0], []}
    Khf2.to_external(puzzle0, [], "x.txt")
    File.read!("x.txt") |> IO.write()
    assert true
  end

  test "Test1" do
    puzzle1 = {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
    Khf2.to_external(puzzle1, [:e, :s, :n, :n, :n], "x.txt")
    File.read!("x.txt") |> IO.write()
    assert true
  end

  test "Test2" do
    puzzle2 = {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
    Khf2.to_external(puzzle2, [:e, :s, :n, :n, :w], "x.txt")
    File.read!("x.txt") |> IO.write()
    assert true
  end

  test "Test3" do
    puzzle3 = {[2], [0, 1, -1, 0, -1], [{1, 1}, {1, 4}]}
    Khf2.to_external(puzzle3, [:e, :e], "x.txt")
    File.read!("x.txt") |> IO.write()
    assert true
  end

  test "Test4" do
    puzzle4 = {[0, -1, 0, 1, 1, 0], [3], [{1, 1}, {3, 1}, {6, 1}]}
    Khf2.to_external(puzzle4, [:s, :s, :n], "x.txt")
    File.read!("x.txt") |> IO.write()
    assert true
  end
end
