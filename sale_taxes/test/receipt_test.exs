defmodule ReceiptTest do
  use ExUnit.Case
  doctest Receipt

  setup_all do
    Application.put_env(:sale_taxes, :basic_tax_exempt_good,
      [food: ["chocolate", "milk"],
       medical_prod: ["headache pill"],
       book: ["book"]])
    Application.put_env(:sale_taxes, :basic_tax_rate, 0.1)
    Application.put_env(:sale_taxes, :import_tax_rate, 0.05)
  end

  test "Purchase with valid line - test/data/sample1.csv" do
    assert %Receipt{items:
                    [%Item{basic_tax_rate: 0.0, import_tax_rate: 0, price: 12.49,
                           price_with_tax: 12.49,product: "book", quantity: 1,
                           taxes: 0.0},
                     %Item{basic_tax_rate: 0.1, import_tax_rate: 0, price: 14.99,
                           price_with_tax: 16.49, product: "music cd", quantity: 1,
                           taxes: 1.5},
                     %Item{basic_tax_rate: 0.0, import_tax_rate: 0, price: 0.85,
                           price_with_tax: 0.85, product: "chocolate bar", quantity: 1,
                           taxes: 0.0}],
                    total_prices: 29.83,
                    total_taxes: 1.5} = Receipt.read("test/data/sample1.csv")
  end

  test "Purchase with csv file - Doub;e quotes and special chars (&) in product name" do
    assert %Receipt{items:
                    [%Item{basic_tax_rate: 0.0, import_tax_rate: 0, price: 12.49,
                           price_with_tax: 12.49, product: "\"book\"", quantity: 1,
                           taxes: 0.0},
                     %Item{basic_tax_rate: 0.1, import_tax_rate: 0, price: 14.99,
                           price_with_tax: 16.49, product: "\"music cd\"", quantity: 1,
                           taxes: 1.5},
                     %Item{basic_tax_rate: 0.0, import_tax_rate: 0, price: 0.85,
                           price_with_tax: 0.85, product: "\"&chocolate bar\"",
                           quantity: 1, taxes: 0.0}],
                    total_prices: 29.83,
                    total_taxes: 1.5} =  Receipt.read("test/data/special_chars.csv")
  end

  test "Purchase with csv file with title only" do
    assert {:error, "CSV must contain at least 2 lines - input csv lines [[\"Quality\", \"Product\", \"Price\"]]"}
    = Receipt.read("test/data/title_only.csv")
  end

  test "Purchase with malformed csv - Exception raise" do
    assert_raise FunctionClauseError, fn ->
      Receipt.read("test/data/missing_fields.csv")
    end
  end

  test "Purchase with non existing file - Exception raise" do
    assert_raise File.Error, fn ->
      Receipt.read("test/data/find_me.csv")
    end
  end

end
