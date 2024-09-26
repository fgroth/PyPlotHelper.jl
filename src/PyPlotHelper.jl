module PyPlotHelper

include(joinpath("plot_formatting","colors.jl"))
include(joinpath("plot_formatting","linestyles.jl"))
include(joinpath("plot_formatting","styling.jl"))
export get_left, get_bottom

export get_color, get_color_iteration, get_colormap,
    get_linestyle, get_marker,
    get_filled_marker, get_fillstyle,
    style_plot,
    set_dark_mode, main_color

include(joinpath("standard_plots","general.jl"))
export PlotType,
    add_text_to_axis
include(joinpath("standard_plots","maps_plot.jl"))
export MapsPlot, setup_maps_plot,
    add_colorscale, create_separate_colorscale
include(joinpath("standard_plots","panel_plot.jl"))
export PanelPlot, setup_panel_comparison_plot
include(joinpath("standard_plots","grid_plot.jl"))
export GridPlot, setup_grid_plot
include(joinpath("standard_plots","profile_plot.jl"))
export ProfilePlot, setup_profile_plot
include(joinpath("standard_plots","single_plot.jl"))
export SinglePlot, setup_single_plot
export setup_plot, add_legend

include(joinpath("helper_functions","rainbow_text.jl"))
export rainbow_text

end # module
