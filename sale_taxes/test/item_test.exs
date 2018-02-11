defmodule ItemTest do
  use ExUnit.Case
  doctest Item

  setup_all do
    Application.put_env(:sale_taxes, :basic_tax_exempt_good, [food: ["chocolate", "milk"]])
    Application.put_env(:sale_taxes, :basic_tax_rate, 0.2)
    Application.put_env(:sale_taxes, :import_tax_rate, 0.05)
  end

  test "Init Item in exempt good list without importing" do
    assert %Item{quantity: 2,
                 product: "bottle of milk",
                 price: 10.0,
                 basic_tax_rate: 0.0,
                 import_tax_rate: 0.0,
                 taxes: 0,
                 price_with_tax: 10.0 } == Item.new(2, "bottle of milk", 10.0)
  end

  test "Init Item not in exempt good list without importing" do
    assert %Item{quantity: 2,
                 product: "laptop",
                 price: 10.0,
                 basic_tax_rate: 0.2,
                 import_tax_rate: 0.0,
                 taxes: 2.0,
                 price_with_tax: 12.0 } == Item.new(2, "laptop", 10.0)
  end

  test "Init Item in exempt good list with importing" do
    assert %Item{quantity: 2,
                 product: "imported bottle of milk",
                 price: 14.99,
                 basic_tax_rate: 0.0,
                 import_tax_rate: 0.05,
                 taxes: 0.75,
                 price_with_tax: 15.74 } == Item.new(2, "imported bottle of milk", 14.99)
  end

  test "Init Item not in exempt good list with importing" do
    assert %Item{quantity: 2,
                 product: "imported laptop",
                 price: 14.99,
                 basic_tax_rate: 0.2,
                 import_tax_rate: 0.05,
                 taxes: 3.75,
                 price_with_tax: 18.74 } == Item.new(2, "imported laptop", 14.99)
  end

  test "Init Item with all inputs are string" do
    assert %Item{quantity: 2,
                 product: "imported laptop",
                 price: 14.99,
                 basic_tax_rate: 0.2,
                 import_tax_rate: 0.05,
                 taxes: 3.75,
                 price_with_tax: 18.74 } == Item.new("2", "imported laptop", "14.99")
  end

  test "Get total taxes with quantity greater than 1 (multiple ???)" do
    assert 7.5 == Item.get_total_taxes(%Item{quantity: 2,
                                             product: "imported laptop",
                                             price: 14.99,
                                             basic_tax_rate: 0.2,
                                             import_tax_rate: 0.05,
                                             taxes: 3.75,
                                             price_with_tax: 18.74 })
  end

  test "Get total prices with quantity greater than 1 (multiple ???)" do
    assert 37.48 == Item.get_price_with_tax(%Item{quantity: 2,
                                                  product: "imported laptop",
                                                  price: 14.99,
                                                  basic_tax_rate: 0.2,
                                                  import_tax_rate: 0.05,
                                                  taxes: 3.75,
                                                  price_with_tax: 18.74 })
  end

  test "From item map to output string" do
    assert "2, imported laptop, 18.74" == Item.to_string(%Item{quantity: 2,
                                                               product: "imported laptop",
                                                               price: 14.99,
                                                               basic_tax_rate: 0.2,
                                                               import_tax_rate: 0.05,
                                                               taxes: 3.75,
                                                               price_with_tax: 18.74 })
  end

end
