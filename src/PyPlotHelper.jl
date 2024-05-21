module PyPlotHelper

using PyPlot

include(joinpath("plot_formatting","colors.jl"))
include(joinpath("plot_formatting","linestyles.jl"))
include(joinpath("plot_formatting","styling.jl"))

export get_color, get_colormap,
    get_linestyle, get_marker,
    get_filled_marker,
    style_plot,
    set_dark_mode, main_color

include(joinpath("standard_plots","setup_figures.jl"))
export setup_maps_plot, setup_panel_comparison_plot,
    MapsPlot,PanelPlot,
    setup_plot

end # module
