defmodule Util do
  @moduledoc """
  Documentation for SaleTaxes Until.
  """

  def to_float(value) when is_integer(value) do
    value * 1.0
  end
  def to_float(value) when is_float(value) do
    value
  end
  def to_float(value) when is_bitstring(value) do
    String.to_float(value)
  end

  def to_int(value) when is_integer(value) do
    value
  end
  def to_int(value) when is_bitstring(value) do
    String.to_integer(value)
  end

end
