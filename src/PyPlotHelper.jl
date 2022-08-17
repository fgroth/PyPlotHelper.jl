module PyPlotHelper

using PyPlot

include(joinpath("plot_formatting","colors.jl"))
include(joinpath("plot_formatting","linestyles.jl"))
include(joinpath("plot_formatting","styling.jl"))

export get_color, get_colormap,
    get_linestyle, get_marker,
    style_plot

end # module
