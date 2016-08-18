defmodule MelpaSnapshot.Archive do
  @derive [Poison.Encoder]
  defstruct [:name, :age]
end
