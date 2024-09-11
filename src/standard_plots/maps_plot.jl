using PyPlot

struct MapsPlot <: PlotType
    print_columns::Number
    n_to_plot::Union{Integer,Tuple{Integer,Integer}}
    function MapsPlot(; print_columns::Number=2, n_to_plot::Union{Integer,Tuple{Integer,Integer}}=2)
        new(print_columns,n_to_plot)
    end
end

function setup_maps_plot(; n_to_plot::Union{Integer,Tuple{Integer,Integer}}=2, print_columns::Number=2)
    setup_plot(MapsPlot(n_to_plot=n_to_plot, print_columns=print_columns))
end

function setup_plot(plot_type::MapsPlot)
    # extract number of rows / columns from n_to_plot
    n_rows = if typeof(plot_type.n_to_plot) <: Integer
        1
    else
        plot_type.n_to_plot[1]
    end
    n_cols = if typeof(plot_type.n_to_plot) <: Integer
        plot_type.n_to_plot
    else
        plot_type.n_to_plot[2]
    end

    # now create the actual figure and axis
    fig = figure(figsize=(4*n_cols,4*n_rows))
    style_plot(fig_width=4*n_cols,print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(n_rows,n_cols, hspace=0.01, wspace=0.01, left=0.01,right=0.99,top=0.99,bottom=0.01)
    ax = gs.subplots()
    ax = if plot_type.n_to_plot == 1 || plot_type.n_to_plot == (1,1)
        [ax]
    else
        ax
    end
    for this_ax in ax
        this_ax.set_xticks([])
        this_ax.set_yticks([])
    end
    return fig,ax
end
