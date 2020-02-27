defmodule CgolzTest do
  use ExUnit.Case

  import Cgolz

  test "check_plot returns :zombie if the plot is listed in town, :brains if not" do
    infected_town = for x <- 0..4, y <- 0..4, do: {x, y}  # the "do" block is another arg. for "for" here
    Enum.each(
      infected_town,
      fn plot -> assert check_plot(infected_town, plot) == :zombie end
    )

    Enum.each(
      infected_town,
      fn {x, y} -> assert check_plot(infected_town, {x + 5, y + 5}) == :brains end
    )
  end

  test "find_neighbors returns appropriate plots" do
      {x, y} = random_plot = {:rand.uniform(100), :rand.uniform(100)}
      neighbors = find_neighbors(random_plot)
      assert Enum.min(neighbors) == {x - 1, y - 1}
      assert Enum.max(neighbors) == {x + 1, y + 1}
      assert Enum.count(neighbors) == 8
  end

  test "count_neighbors returns correct counts as a plot_census type" do
    random_plot = {:rand.uniform(100), :rand.uniform(100)}
    neighbors = find_neighbors(random_plot)
    assert count_neighbors([], random_plot) == {random_plot, 0}
    assert count_neighbors(neighbors, random_plot) == {random_plot, 8}
  end

  test "take_census returns the correct counts as a census type" do
      random_town = random_town(:rand.uniform(10), :rand.uniform(10))
      census = take_census(random_town)
      if Enum.count(random_town) > 0, do: assert(Enum.count(census) > 0)
      census_plots = Enum.map(census, fn {plot, _} -> plot end)

      Enum.each(
        random_town,
        fn plot ->
          assert plot in census_plots
          Enum.each(find_neighbors(plot), fn neighbor -> assert neighbor in census_plots end)
        end
      )

      uninfected_plots = Enum.filter(census_plots, fn plot -> plot not in random_town end)

      Enum.each(
        uninfected_plots,
        fn plot ->
          {_, count} = Enum.find(census, fn {p, _} -> p == plot end)
          assert count > 0
        end
      )

      neighborless_plots =
        Enum.filter(census, fn {_, count} -> count == 0 end)
        |> Enum.map(fn {plot, _} -> plot end)

      Enum.each(neighborless_plots, fn p -> assert p in random_town end)
    end

end
