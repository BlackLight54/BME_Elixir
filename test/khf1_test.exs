defmodule Khf1Test do
  use ExUnit.Case
  doctest Khf1
  test "1_1" do
    assert Khf1.to_internal("khf1_f1.txt") == {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}
  end
  test "1_2" do
    assert Khf1.to_internal("khf1_f2.txt") == {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}

  end
end
