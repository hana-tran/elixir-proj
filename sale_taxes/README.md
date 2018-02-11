# SaleTaxes

# Application

Basic sales tax is applicable at a rate of 10% on all goods, except books, food, and
 medical products that are exempt.
Import duty is an additional sales tax applicable on all imported goods at a rate of 5%,
 with no exemptions.

When user purchases items he/she will receive a receipt that lists
 the name of all the items and their price (including tax),
 finishing with the total cost of the items, and the total amounts of sales taxes paid.
The rounding rules for sales tax are that for a tax rate of n%,
 a shelf price of p contains (np/100 rounded up to the nearest 0.05) amount of sales tax.

Sale Taxes application that prints out the receipt details for these shopping baskets;


# Building

This simplest case will fetch and build everything.

```
$ make # using Makefile
$ mix compile # OR Mix commands
```

# Testing

To run all test suites

```
$ make test # OR
$ mix test
```

## Targets

* apps: compile our applications
* clean: clean our applications
* deps: fetch and build our dependencies
* clean-deps: clean dependencies
* test: run all test suites


## Configuration

../sale_taxes/config/config.exs

Default values will be returned if configuration cannot be found.

```
config :sale_taxes,
  basic_tax_exempt_good: [
    food: ["chocolate", "milk"],
    medical_prod: ["headache pill"],
    book: ["book"]
  ],
  # 0.1 = 10%
  basic_tax_rate: 0.1,
  import_tax_rate: 0.05
```


# Usage

## Development

In development, one or more applications can be started in a console with the following:

```
$ ./start-dev.sh # start iex shell, use Ctrl + D to exit shell
iex(1)> Receipt.purchase("test/data/sample.csv")
# OUTPUT (to stdout)
1, book, 12.49
1, music cd, 16.49
1, chocolate bar, 0.85
1, imported box of chocolates, 10.5
1, imported bottle of perfume, 54.63
1, imported bottle of perfume, 32.19
1, bottle of perfume, 20.89
1, packet of headache pills, 9.75
1, imported box of chocolates, 11.81
Sales Taxes: 15.79
Total: 169.6
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sale_taxes` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:sale_taxes, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sale_taxes](https://hexdocs.pm/sale_taxes).
