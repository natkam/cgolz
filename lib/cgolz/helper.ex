defmodule Cgolz.Helper do
  @spec random_town(integer, integer, Float.t()) :: Cgolz.town()  # Float module, .t() - the base type of a module; spec declaration is optional
  def random_town(width, depth, probability \\ 0.25)  # default value of probability
        when is_integer(width) and is_integer(depth) and is_float(probability) do  # so called "guard" statement; so the function works only with these types
      for x <- 1..width, y <- 1..depth do  # a list comprehension
        :rand.uniform() <= probability && {x, y}
      end
      |> Enum.filter(fn el -> el end)  # filters out the nils (wow?!)
  end
end