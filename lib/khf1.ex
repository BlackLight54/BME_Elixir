defmodule Khf1 do
  @moduledoc """
  Kemping
  @author "Farkas Martin <fmartin0120@gmial.com>"
  @date   "2022-09-25"
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

  @spec to_internal(file :: String.t()) :: pd :: puzzle_desc
  # A file fájlban szövegesen ábrázolt feladvány leírója pd

  def to_internal(file) do
    {:ok, input} = File.read(file)

    {
      getLinesFromInput(input) |> getTentsCountRows(),
      getLinesFromInput(input) |> getTentsCountCols(),
      getLinesFromInput(input) |> getMatrix() |> getTrees()
    }
  end

  defp saniziteCRLF(input) do
    # sanitize windows line endings
    String.replace(input, "\r", "", global: true)
  end

  defp getLinesFromInput(input) do
    san_input = saniziteCRLF(input)
    # split document into array of lines, trimming whitespaces from beggining and end
    for line <- String.split(san_input, "\n", trim: true) do
      # split lines into array of words, trimming whitespaces from beggining and end
      String.split(line, " ", trim: true)
    end
    # filter empty lines
    |> Enum.filter(fn x -> x != [] end)
  end

  defp getTentsCountCols(lines) do
    hd(lines) |> Enum.map(&String.to_integer(&1))
  end

  defp getTentsCountRows(lines) do
    for line when line != lines |> hd <- lines  do
      hd(line)
    end
    |> Enum.map(&String.to_integer(&1))
  end

  defp getMatrix(lines) do
    Enum.filter(lines, fn x -> x != hd(lines) end)
    |> (fn filtered_lines ->
      for line <- filtered_lines do
        Enum.filter(line, fn x -> x != hd(line) end)
      end
    end).()
    |> Enum.filter(fn x -> x != nil end)
  end

  defp getTrees(tentMatrix) do
    for row <- (tentMatrix |> Enum.with_index()) do
      #IO.inspect(row);
      for col <- ((row |> elem(0)) |> Enum.with_index()) do
        #IO.inspect(col);
        if ((col |> elem(0))  == "*" )do
          {(row |> elem(1)) + 1, (col |> elem(1)) + 1}
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(fn x -> x != nil end)
  end



end
