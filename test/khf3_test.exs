defmodule Khf3Test do
  use ExUnit.Case
  @moduletag khf3: true

  # setup_all do
  # end

  setup do
    IO.puts("setup: \n")
  end

  @tag khf3_c: true
  test "3_c" do
   _p4 =
    {pd4, ts4} =
      {{[1, 0, 2, 2, 0], [1, 0, 0, 2, 1], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
       [:e, :e, :n, :n, :n]}

    pd4 |> IO.inspect(label: "pd4")
    ts4 |> IO.inspect(label: "ts4")
    Khf2.to_external(pd4, ts4, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd4, ts4) |> IO.inspect(label: "check_sol")
  end

  test "3_0" do
    _p0 = {pd0, ts0} = {{[-1, 0, 0, -3, 0], [0, 0, -2, 0, 0], []}, []}
    pd0 |> IO.inspect(label: "pd0")
    ts0 |> IO.inspect(label: "ts0")
    Khf2.to_external(pd0, ts0, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd0, ts0) |> IO.inspect(label: "check_sol")

    assert Khf3.check_sol(pd0, ts0) == {%{err_rows: []}, %{err_cols: []}, %{err_touch: []}}
  end

  test "3_1" do
    _p1 = {pd1, ts1} = {{[1, 0, 0, 3, 0], [0, 0, 2, 0, 0], []}, []}
    pd1 |> IO.inspect(label: "pd1")
    ts1 |> IO.inspect(label: "ts1")
    Khf2.to_external(pd1, ts1, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd1, ts1) |> IO.inspect(label: "check_sol")
  end

  test "3_2" do
    _p2 =
      {pd2, ts2} =
      {{[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
       [:e, :s, :n, :n, :n]}

    pd2 |> IO.inspect(label: "pd2")
    ts2 |> IO.inspect(label: "ts2")
    Khf2.to_external(pd2, ts2, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd2, ts2) |> IO.inspect(label: "check_sol")
  end

  test "3_3" do
    _p3 =
      {pd3, ts3} =
      {{[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
       [:e, :e, :n, :n, :n]}

    pd3 |> IO.inspect(label: "pd3")
    ts3 |> IO.inspect(label: "ts3")
    Khf2.to_external(pd3, ts3, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd3, ts3) |> IO.inspect(label: "check_sol")
  end

  test "3_4" do
    _p4 =
      {pd4, ts4} =
      {{[1, 0, 2, 2, 0], [1, 0, 0, 2, 1], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
       [:e, :e, :n, :n, :n]}

    pd4 |> IO.inspect(label: "pd4")
    ts4 |> IO.inspect(label: "ts4")
    Khf2.to_external(pd4, ts4, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd4, ts4) |> IO.inspect(label: "check_sol")
  end

  test "3_5" do
    _p5 =
      {pd5, ts5} =
      {{[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]},
       [:e, :s, :n, :n, :w]}

    pd5 |> IO.inspect(label: "pd5")
    ts5 |> IO.inspect(label: "ts5")
    Khf2.to_external(pd5, ts5, "x.txt")
    File.read!("x.txt") |> IO.write()
    Khf3.check_sol(pd5, ts5) |> IO.inspect(label: "check_sol5")
  end
end
