defmodule Khf1Test do
  # use ExUnit.Case
  # doctest Khf1

  # test "Show output" do
    Khf1.to_internal("khf1_f1.txt") |> IO.inspect()
    IO.puts("---")
    Khf1.to_internal("khf1_f2.txt") |> IO.inspect()
    IO.puts("---")
  # end
end
