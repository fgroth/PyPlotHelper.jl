using PyPlot

struct SinglePlot <: PlotType
    print_columns::Number
    xscale::String
    yscale::String
    xlim::Vector
    ylim::Vector
    xlabel::AbstractString
    ylabel::AbstractString
    xticks::Vector
    yticks::Vector
    function SinglePlot(; print_columns::Number=2,
                        xscale::String="linear", yscale::String="linear",
                        xlim::Vector=[nothing], ylim::Vector=[nothing],
                        xlabel::AbstractString="", ylabel::AbstractString="",
                        xticks::Vector=[nothing], yticks::Vector=[nothing])
        new(print_columns,
            xscale,yscale,
            xlim,ylim,
            xlabel,ylabel,
            xticks,yticks)
    end
end

function setup_single_plot(; print_columns::Number=2)
    setup_plot(SinglePlot(print_columns=print_columns))
end

function setup_plot(plot_type::SinglePlot)
    fig = figure(figsize=(6,4))
    style_plot(fig_width=6, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(1,1, left=get_left(width=6,large=plot_type.yscale=="log"), right=0.99,
                          bottom=get_bottom(height=4,large=plot_type.xscale=="log"), top=0.99)
    
    ax = gs.subplots()

    ax.set_xscale(plot_type.xscale)
    ax.set_yscale(plot_type.yscale)

    if plot_type.xlim != [nothing]
        ax.set_xlim(plot_type.xlim)
    end
    if plot_type.ylim != [nothing]
        ax.set_ylim(plot_type.ylim)
    end

    ax.set_xlabel(plot_type.xlabel)
    ax.set_ylabel(plot_type.ylabel)

    if plot_type.xticks != [nothing]
        ax.set_xticks(plot_type.xticks)
    end
    if plot_type.yticks != [nothing]
        ax.set_yticks(plot_type.yticks)
    end

    return fig, ax
end
