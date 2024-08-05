using PyPlot

struct SinglePlot <: PlotType
    print_columns::Number
    xscale::String
    yscale::String
    xlim::Vector
    ylim::Vector
    xlabel::AbstractString
    ylabel::AbstractString
    function SinglePlot(; print_columns::Number=2,
                        xscale::String="linear", yscale::String="linear",
                        xlim::Vector=[nothing,nothing], ylim::Vector=[nothing,nothing],
                        xlabel::AbstractString="", ylabel::AbstractString="")
        new(print_columns,
            xscale,yscale,
            xlim,ylim,
            xlabel,ylabel)
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

    return fig, ax
end
