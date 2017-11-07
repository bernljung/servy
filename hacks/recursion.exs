defmodule Recursion do
  def triple([head|tail]) do
    [head*3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map([head|tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], fun), do: []
end
