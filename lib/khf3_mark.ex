defmodule Khf3_mark do
  @moduledoc """
  Kemping helyessége
  @author "Molnár Márk - B44W74 <ranlom01@gmail.com>"
  @date   "2022-10-08"
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
    # Először előállítjuk a sátrak helyeit
    tents = getTents(elem(pd, 2), ds)
    # Megszámoljuk a sátrakat
    tentMap = countTentsInRowsandCols(tents)
    # Hibák kijelzése
    wrongColandRow = controllRowsAndCols(elem(pd, 0), elem(pd, 1), tentMap)

    touches = controllTouch(tents)
    # wrong;
    {elem(wrongColandRow, 0), elem(wrongColandRow, 1), touches}
  end

  defp getTents(trees, dirs) do
    # Ha nincs fa, akkor üres mappel térünk vissza
    if trees == [] do
      []
    else
      # Az összes fára megcsináljuk
      for i <- 0..(length(trees) - 1) do
        treeCell = Enum.at(trees, i)

        # Sátor index és betű beállítás
        tentCell =
          case Enum.at(dirs, i) do
            :n -> {elem(treeCell, 0) - 1, elem(treeCell, 1)}
            :s -> {elem(treeCell, 0) + 1, elem(treeCell, 1)}
            :e -> {elem(treeCell, 0), elem(treeCell, 1) + 1}
            :w -> {elem(treeCell, 0), elem(treeCell, 1) - 1}
          end
      end
    end
  end

  defp countTentsInRowsandCols(tents) do
    if length(tents) > 0 do
      map = countTentsInRowsandCols(tl(tents))
      tent = hd(tents)

      keyY = {"col", elem(tent, 1)}
      valueY = Map.get(map, keyY, 0) + 1
      map = Map.put(map, keyY, valueY)

      keyX = {"row", elem(tent, 0)}
      valueX = Map.get(map, keyX, 0) + 1
      Map.put(map, keyX, valueX)
    else
      %{}
    end
  end

  defp controllRowsAndCols(rowSum, colSum, tentMap) do
    rows =
      for i <- 1..length(rowSum) do
        calculated = Map.get(tentMap, {"row", i}, 0)
        mustBe = Enum.at(rowSum, i - 1)

        if calculated != mustBe and mustBe >= 0 do
          i
        end
      end
      |> Enum.filter(fn x -> x != nil end)

    cols =
      for i <- 1..length(colSum) do
        calculated = Map.get(tentMap, {"col", i}, 0)
        mustBe = Enum.at(colSum, i - 1)

        if calculated != mustBe and mustBe >= 0 do
          i
        end
      end
      |> Enum.filter(fn x -> x != nil end)

    {%{err_rows: rows}, %{err_cols: cols}}
  end

  defp controllTouch(tents) do
    if tents == [] do
      %{err_touch: []}
    else
      map = %{}

      map =
        for tent <- tents do
          Map.put(map, tent, "")
        end
        |> Enum.reduce(&Map.merge/2)

      wrong =
        for tent <- tents do
          cells = [
            {elem(tent, 0) - 1, elem(tent, 1) - 1},
            {elem(tent, 0) - 1, elem(tent, 1)},
            {elem(tent, 0) - 1, elem(tent, 1) + 1},
            {elem(tent, 0), elem(tent, 1) - 1}
          ]

          for cell <- cells do
            if Map.has_key?(map, cell) do
              {tent, cell}
            end
          end
          |> Enum.filter(fn x -> x != nil end)
        end
        |> Enum.filter(fn x -> x != [] end)

      if wrong == [] do
        %{err_touch: []}
      else
        sol =
          for touch <- wrong do
            for pair <- touch do
              %{elem(pair, 1) => 0, elem(pair, 0) => 0}
            end
            |> Enum.reduce(&Map.merge/2)
          end
          |> Enum.reduce(&Map.merge/2)

        %{err_touch: Map.keys(sol)}
      end
    end
  end
end
