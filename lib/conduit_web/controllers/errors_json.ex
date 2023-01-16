defmodule ConduitWeb.ErrorsJSON do
  @doc """
  Traverses and translates errors.
  """

  @doc """
  Renders errors.
  """
  def error(%{errors: errors}) do
    %{errors: errors}
  end
end
