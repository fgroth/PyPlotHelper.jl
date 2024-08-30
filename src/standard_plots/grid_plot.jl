using PyPlot

struct GridPlot <: PlotType
    print_columns::Number
    xscale::String
    yscale::String
    xlim::Vector
    ylim::Vector
    xlabel::AbstractString
    ylabel::AbstractString
    names::Matrix{String}
    names_position::String
    function GridPlot(; print_columns::Number=1,
             xscale::String="linear", yscale::String="linear",
             xlim::Vector=[0,1], ylim::Vector=[0,1],
             xlabel::AbstractString="", ylabel::AbstractString="",
             names::Matrix{String}=[""], names_position::String="upper left")
        new(print_columns,
            xscale, yscale,
            xlim, ylim,
            xlabel, ylabel,
            names, names_position)
    end
end


function setup_grid_plot(; print_columns::Int64=1)
    setup_plot(GridPlot(print_columns=print_columns))
end

function setup_plot(plot_type::GridPlot)
    n_rows, n_columns = size(plot_type.names)

    fig = figure(figsize=(4*n_columns,4*n_rows))
    style_plot(fig_width=4*n_columns, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(n_rows,n_columns,
                          left=get_left(width=4*n_columns,large=plot_type.yscale=="log"),right=0.99,
                          bottom=get_bottom(height=4*n_rows,large=plot_type.xscale=="log"), top=0.99,
                          hspace=0.01, wspace=0.01)
    ax = gs.subplots()
    if n_rows*n_columns == 1
        ax = [ax]
    end
    ax = reshape(ax, (n_rows,n_columns))

    # scaling
    for this_ax in ax
        this_ax.set_xscale(plot_type.xscale)
        this_ax.set_yscale(plot_type.yscale)
        this_ax.set_xlim(plot_type.xlim)
        this_ax.set_ylim(plot_type.ylim)
    end

    
    # axis labels
    for i_row in 1:n_rows
        for i_column in 1:n_columns
            if i_column == 1
                ax[i_row,1].set_ylabel(plot_type.ylabel)
            else
                ax[i_row,i_column].set_yticklabels([])
            end
            if i_row == n_rows
                ax[i_row,i_column].set_xlabel(plot_type.xlabel)
            else
                ax[i_row,i_column].set_xticklabels([])
            end

        end
    end

    # panel labels
    for i_row in 1:n_rows
        for i_column in 1:n_columns
            add_text_to_axis(ax[i_row,i_column], plot_type.names[i_row,i_column], loc=plot_type.names_position)
        end
    end

    return fig, ax
    
end
