defmodule SaleTaxesApp do
  use Application
  @moduledoc """
  SaleFaxes Application Module.
  """

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
