using PyPlot

struct PanelPlot
    print_columns::Number
    plot_combined_columns::Bool
    plot_combined_rows::Bool
    function PanelPlot(; print_columns::Number=1, plot_combined_columns::Bool=true, plot_combined_rows::Bool=true)
        new(print_columns,plot_combined_columns,plot_combined_rows)
    end
end

struct MapsPlot
    print_columns::Number
    n_to_plot::Int64
    function MapsPlot(; print_columns::Number=2, n_to_plot::Int64=2)
        new(print_columns,n_to_plot)
    end
end

function setup_maps_plot(; n_to_plot::Int64=2, print_columns::Int64=2)
    setup_plot(MapsPlot(n_to_plot=n_to_plot, print_columns=print_columns))
end

function setup_plot(plot_type::MapsPlot)
    fig = figure(figsize=(4*plot_type.n_to_plot,4))
    style_plot(fig_width=4*plot_type.n_to_plot,print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(1,plot_type.n_to_plot, hspace=0.01, wspace=0.01, left=0.01,right=0.99,top=0.99,bottom=0.01)
    ax = gs.subplots()
    if plot_type.n_to_plot == 1
        return fig, [ax]
    else
        return fig, ax
    end
end

function setup_panel_comparison_plot(; print_columns::Int64=1)
    setup_plot(PanelPlot(print_columns=print_columns))
end

function setup_plot(plot_type::PanelPlot)
    fig = figure(figsize=(12,12))
    style_plot(fig_width=12, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(3,3, left=0.1,right=0.99, bottom=0.1, top=0.99,hspace=0.01, wspace=0.01)
    ax = gs.subplots()

    return fig, ax
end
