defmodule Khf3 do
  @moduledoc """
  Kemping helyessége
  @author "Farkas Martin <martin.farkas@edu.bme.hu>"
  @date   "2022-10-04"
  ...
  """

  # sor száma (1-től n-ig)
  @type row :: integer
  # oszlop száma (1-től m-ig)
  @type col :: integer
  # egy parcella koordinátái
  @type field :: {row, col}

  # a sátrak száma soronként
  @type tents_count_rows :: [integer]
  # a sátrak száma oszloponként
  @type tents_count_cols :: [integer]

  # a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
  @type trees :: [field]
  # a feladványleíró hármas
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

  # a sátorpozíciók iránya: north, east, south, west
  @type dir :: :n | :e | :s | :w
  # a sátorpozíciók irányának listája a fákhoz képest
  @type tent_dirs :: [dir]

  # a fák száma a kempingben
  @type cnt_tree :: integer
  # az elemek száma a sátorpozíciók irányának listájában
  @type cnt_tent :: integer
  # a sátrak száma rossz a felsorolt sorokban
  @type err_rows :: %{err_rows: [integer]}
  # a sátrak száma rossz a felsorolt oszlopokban
  @type err_cols :: %{err_cols: [integer]}
  # a felsorolt koordinátájú sátrak másikat érintenek
  @type err_touch :: %{err_touch: [field]}
  # hibaleíró hármas
  @type errs_desc :: {err_rows, err_cols, err_touch}

  @spec check_sol(pd :: puzzle_desc, ds :: tent_dirs) :: ed :: errs_desc
  # Az {rs, cs, ts} = pd feladványleíró és a ds sátorirány-lista
  # alapján elvégzett ellenőrzés eredménye a cd hibaleíró, ahol
  #   rs a sátrak soronként elvárt számának a listája,
  #   cs a sátrak oszloponként elvárt számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának a listája
  # Az {e_rows, e_cols, e_touch} = ed hármas elemei olyan
  # kulcs-érték párok, melyekben a kulcs a hiba jellegére utal, az
  # érték pedig a hibahelyeket felsoroló lista (üres, ha nincs hiba)

  def check_sol(pd, ds) do
    tents =
      getTents(pd, ds)
      |> IO.inspect(label: "tents")

    err_rows = checkRows(tents, pd)
    err_cols = checkCols(tents, pd)
    err_touch = checkTouch(tents, pd)
    {err_rows, err_cols, err_touch}
  end

  defp getTents(pd, ds) do
    {_rs, _cs, ts} = pd

    if ts != [] do
      for i <- 0..(length(ds) - 1) do
        tree = Enum.at(ts, i)

        case Enum.at(ds, i) do
          :n -> {elem(tree, 0) - 1, elem(tree, 1)}
          :s -> {elem(tree, 0) + 1, elem(tree, 1)}
          :e -> {elem(tree, 0), elem(tree, 1) + 1}
          :w -> {elem(tree, 0), elem(tree, 1) - 1}
        end
      end
    end
  end

  defp checkRows(tents, pd) do
    {rs, _cs, _ts} = pd
    # IO.inspect(tents)
    # IO.inspect(rs)
    %{
      :err_rows =>
        for rowIndex <- 1..length(rs) do
          # IO.puts("i: #{rowIndex}");
          if Enum.at(rs, rowIndex - 1) >= 0 do
            # IO.puts("r: #{Enum.at(rs, rowIndex - 1 )}");
            tentCount = fn tent ->
              if tent == nil or tent == [] do
                0
              else
                Enum.count(
                  tents,
                  fn cell ->
                    {r, _c} = cell
                    r == rowIndex
                  end
                )
              end
            end

            #IO.puts("i: #{rowIndex}, r: #{Enum.at(rs, rowIndex - 1)}, c: #{tentCount.(tents)}")

            if Enum.at(rs, rowIndex - 1) != tentCount.(tents) do
              rowIndex
            end
          end
        end
        |> Enum.reject(fn x -> x == nil end)
    }
  end

  defp checkCols(tents, pd) do
    {_rs, cs, _ts} = pd
    # IO.inspect(tents)
    # IO.inspect(cs)
    %{
      :err_cols =>
        for colIndex <- 1..length(cs) do
          # IO.puts("i: #{colIndex}");
          if Enum.at(cs, colIndex - 1) >= 0 do
            # IO.puts("r: #{Enum.at(cs, colIndex - 1 )}");
            tentCount = fn tent ->
              if tent == nil or tent == [] do
                0
              else
                Enum.count(
                  tents,
                  fn cell ->
                    {_r, c} = cell
                    c == colIndex
                  end
                )
              end
            end

            #IO.puts("i: #{colIndex}, r: #{Enum.at(cs, colIndex - 1)}, c: #{tentCount.(tents)}")

            if Enum.at(cs, colIndex - 1) != tentCount.(tents) do
              colIndex
            end
          end
        end
        |> Enum.reject(fn x -> x == nil end)
    }
  end

  defp checkTouch(tents, pd) do
    {rs, cs, _ts} = pd

    %{
      :err_touch =>
        if tents == nil or tents == [] do
          []
        else
          for tent <- tents do
            {r, c} = tent

            if r > 0 and c > 0 and r < length(rs) + 1 and c < length(cs) + 1 do
              if Enum.member?(tents, {r - 1, c - 1}) or
                   Enum.member?(tents, {r - 1, c}) or
                   Enum.member?(tents, {r - 1, c + 1}) or
                   Enum.member?(tents, {r, c - 1}) or
                   Enum.member?(tents, {r, c + 1}) or
                   Enum.member?(tents, {r + 1, c - 1}) or
                   Enum.member?(tents, {r + 1, c}) or
                   Enum.member?(tents, {r + 1, c + 1}) do
                tent
              end
            end
          end
          |> Enum.filter(fn x -> x != nil end)
        end
    }
  end

  defp create_map(pd) do
    {rows, clms, _ts} = pd

    for row <- 0..length(rows), clm <- 0..length(clms), reduce: %{} do
      acc -> Map.put(acc, {row, clm}, "-")
    end
  end

  defp fillMapwTrees(map, pd) do
    {_rows, _clms, ts} = pd

    Enum.reduce(ts, map, fn {row, clm}, acc ->
      Map.put(acc, {row, clm}, "*")
    end)
  end

  defp fillMapwTents(map, ds) do
    Enum.reduce(ds, map, fn {row, clm, dir}, acc ->
      Map.put(acc, {row, clm}, dir)
    end)
  end

  defp toMapString(map, rows, clms) do
    for row <- 0..length(rows) do
      for clm <- 0..length(clms) do
        map |> Map.fetch({row, clm}) |> elem(1)
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end
end
