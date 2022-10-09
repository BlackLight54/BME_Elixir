defmodule NHFTEst do
  use ExUnit.Case
  @moduletag khf3: true

  # setup_all do
  # end

  # setup do
  #   IO.puts("setup: \n")
  # end

  @tag nhf: true
    test "nhf" do
      Nhf1.satrak {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5} ]}
      #assert Nhf1.satrak {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]} == [[:e, :s, :n, :n, :n]]
    end
end
