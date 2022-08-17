# PyPlotHelper.jl

Some function to help formatting plots.

## Example

Simple styling of the plot can be done using

```julia
using PyPlot
using PyPlotHelper

fig = figure(figsize=(4,4))
style_plot(fig_width=4, print_columns=2)
ax = fig.add_subplot()

```
