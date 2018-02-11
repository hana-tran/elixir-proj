defmodule Receipt do
  @moduledoc """
  Documentation for SaleTaxes Receipt.

  To purchase receipt with output price with sale taxes:
      $ Receipt.purchase("test/data/sample.csv")
  """

  @type receipt :: %__MODULE__{ items: [Item.item],
                                total_taxes: float,
                                total_prices: float }

  defstruct [
    items: nil,
    total_taxes: nil,
    total_prices: nil
  ]

  @spec purchase(csv_file :: String.t()) :: :ok
  def purchase(csv_file) do
    receipt = read(csv_file)
    printout(receipt)
  end

  @spec read(csv_file :: String.t()) :: receipt | {:error, term}
  def read(csv_file) do
    lines = File.stream!(csv_file) |> CSV.decode |> Enum.map(fn({:ok, x}) -> x end)
    proceed_lines(lines)
  end

  @spec proceed_lines(list) :: receipt
  def proceed_lines(lines) when length(lines) <= 1 do
      {:error, "CSV must contain at least 2 lines - input csv lines #{inspect lines}"}
  end
  def proceed_lines(lines) do
      # Let process crash if error occurs
      csv_lines_without_title = tl(lines)
      items = Enum.map(csv_lines_without_title,
        fn
          [quantity, product, price] -> Item.new(quantity, product, price)
          invalid -> {:error, "Invalid #{invalid}"}
        end)
      receipt = %__MODULE__{ items: items }
      calculate_total(receipt)
  end

  @spec calculate_total(receipt) :: receipt_with_total :: receipt
  defp calculate_total(receipt =  %__MODULE__{ items: items }) do
    {total_taxes, total_prices} =
      :lists.foldl(
        fn(item, {taxes, prices}) ->
          {taxes + Item.get_total_taxes(item), prices + Item.get_price_with_tax(item)}
        end, {0.0, 0.0}, items)
    %__MODULE__{receipt | total_taxes: Float.round(total_taxes, 3),
                total_prices: Float.round(total_prices, 3)}
  end

  @spec printout(receipt | {:error, term}) :: :ok
  defp printout({:error, reason}) do
    IO.puts("# OUTPUT (to stdout)")
    IO.puts("Error: #{inspect reason}")
  end
  defp printout(%__MODULE__{items: items, total_taxes: total_taxes,
                            total_prices: total_prices}) do
    IO.puts("# OUTPUT (to stdout)")
    Enum.map(items, fn(item) ->
      item_str = Item.to_string(item)
      IO.puts("#{item_str}") end)
    IO.puts("Sales Taxes: #{inspect total_taxes}")
    IO.puts("Total: #{inspect total_prices}")
  end
end
