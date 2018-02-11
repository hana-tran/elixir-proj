defmodule Item do
  @moduledoc """
  Documentation for SaleTaxes Item.
  Present each of items in receipt.
  """
  @type item :: %__MODULE__{ quantity: integer,
                             product: String.t(),
                             price: float,
                             basic_tax_rate: float,
                             import_tax_rate: float,
                             taxes: float,
                             price_with_tax: float }

  @enforce_keys [:quantity, :product, :price]
  defstruct [
    quantity: nil,
    product: nil,
    price: nil,
    basic_tax_rate: nil,
    import_tax_rate: nil,
    taxes: nil,
    price_with_tax: nil,
  ]

  @spec new(number, String.t(), float) :: item
  def new(quantity, product, price) do
    item = %__MODULE__{
      quantity: Util.to_int(quantity),
      product: product,
      price: Util.to_float(price)
    }
    item1 = get_tax_rates_by_config(item)
    update_price_with_tax(item1)
  end

  @spec update_price_with_tax(beforeUpdate :: item) :: itemWithNewPrice :: item
  def update_price_with_tax(item = %__MODULE__{price: price, basic_tax_rate: basic_tax,
                                               import_tax_rate: import_tax}) do
    taxes = Float.round(price * (basic_tax + import_tax), 2)
    # FIXME: Don't know why float in Elixir setting float value long after appendingvalue.
    # Need to round value to 0.005
    price_with_tax = Float.round(price + taxes, 3)
    %__MODULE__{item | taxes: taxes, price_with_tax: price_with_tax}
  end

  @spec get_total_taxes(item) :: float
  def get_total_taxes(%__MODULE__{quantity: quantity, taxes: taxes}) do
    # FIXME: Not sure that should multiple with quantity??
    quantity * taxes
  end

  @spec get_price_with_tax(item) :: float
  def get_price_with_tax(%__MODULE__{quantity: quantity,
                                     price_with_tax: price_with_tax}) do
    # FIXME: Not sure that should multiple with quantity??
    quantity * price_with_tax
  end

  @spec to_string(item) :: String.t()
  def to_string(%__MODULE__{quantity: quantity, product: product,
                            price_with_tax: price_with_tax}) do
    "#{quantity}, #{product}, #{price_with_tax}"
  end

  @spec get_tax_rates_by_config(item) :: new_item_with_tax_rates :: item
  defp get_tax_rates_by_config(item = %__MODULE__{product: product}) do
    # Get default values if configuration cannot be found.
    basic_tax_exempt_good = Application.get_env(:sale_taxes, :basic_tax_exempt_good, [])
    basic_tax_rate = Application.get_env(:sale_taxes, :basic_tax_rate, 0.1)
    import_tax_rate = Application.get_env(:sale_taxes, :import_tax_rate, 0.05)

    basic_tax = case is_exempt_from_basic_tax(product, basic_tax_exempt_good) do
                  true -> 0.0
                  false -> basic_tax_rate
                end
    import_tax = case String.starts_with?(String.downcase(product), "imported") do
                   true -> import_tax_rate
                   false -> 0
                 end

    %__MODULE__{item | basic_tax_rate: basic_tax, import_tax_rate: import_tax}
  end

  @spec is_exempt_from_basic_tax(product :: String.t(),
    basic_exempt_list :: [{type :: atom, product_names :: [String.t()]}]) :: boolean
  defp is_exempt_from_basic_tax(product, exempt_list) do
    Enum.find(exempt_list,
      fn({_type, product_names}) ->
        Enum.find(product_names, :not_found,
          fn(name) ->
            String.contains?(product, name) end)
        !== :not_found
      end) !== nil
  end

end
