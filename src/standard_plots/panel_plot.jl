using PyPlot

struct PanelPlot <: PlotType
    print_columns::Number
    plot_combined_columns::Bool
    plot_combined_rows::Bool
    xscale::String
    yscale::String
    xlim::Vector
    ylim::Vector
    xlabel::AbstractString
    ylabel::AbstractString
    row_names::Vector{String}
    column_names::Vector{String}
    names_position::String
    no_legend::Bool
    function PanelPlot(; print_columns::Number=1, plot_combined_columns::Bool=true, plot_combined_rows::Bool=true,
                       xscale::String="log", yscale::String="linear",xlim::Vector=[1e-2,1e0],ylim::Vector=[0,1],
                       xlabel::AbstractString="",ylabel::AbstractString="",
                       row_names::Vector{String}=["MFM","SPH"], column_names::Vector{String}=["relaxed","active"],
                       names_position::String="center left",
                       no_legend::Bool=false)
        new(print_columns,plot_combined_columns,plot_combined_rows,
            xscale,yscale,xlim,ylim,
            xlabel,ylabel,
            row_names, column_names,
            names_position,
            no_legend)
    end
end

function setup_panel_comparison_plot(; print_columns::Int64=1)
    setup_plot(PanelPlot(print_columns=print_columns))
end

function setup_plot(plot_type::PanelPlot)
    n_rows = if plot_type.plot_combined_columns
        length(plot_type.row_names) + 1
    else
        length(plot_type.row_names)
    end
    n_columns = if plot_type.plot_combined_rows
        length(plot_type.column_names) + 1
    else
        length(plot_type.column_names)
    end
    legend_space = if (plot_type.plot_combined_columns && plot_type.plot_combined_rows) || plot_type.no_legend
        0
    elseif n_columns >= 4
        1
    elseif n_columns >= 2
        2
    else
        4
    end
    fig = figure(figsize=(4*n_columns,4*n_rows+legend_space))
    style_plot(fig_width=4*n_columns, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(n_rows,n_columns,
                          left=get_left(width=4*n_columns,large=plot_type.yscale=="log"),right=0.99,
                          bottom=get_bottom(height=4*n_rows+legend_space,large=plot_type.xscale=="log"), top=minimum([0.99,1-legend_space/(4*n_rows)]),
                          hspace=0.01, wspace=0.01)
    ax = gs.subplots()
    if n_rows*n_columns == 1
        ax = [ax]
    end
    ax = reshape(ax, (n_rows,n_columns))

    for this_ax in ax
        this_ax.set_xscale(plot_type.xscale)
        this_ax.set_yscale(plot_type.yscale)
        this_ax.set_xlim(plot_type.xlim)
        this_ax.set_ylim(plot_type.ylim)
    end

    for i_row in 1:n_rows
        for i_column in 1:n_columns
            if i_column == 1
                ax[i_row,i_column].set_ylabel(plot_type.ylabel)
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
    
    if !plot_type.plot_combined_rows & !plot_type.plot_combined_columns
        add_text_to_axis(ax[1,n_columns], plot_type.row_names[1]*" "*plot_type.column_names[length(plot_type.column_names)], loc=plot_type.names_position)
    else
        add_text_to_axis(ax[1+n_rows-length(plot_type.row_names),n_columns], plot_type.row_names[1], loc=plot_type.names_position)
        add_text_to_axis(ax[1,length(plot_type.column_names)], plot_type.column_names[end], loc=plot_type.names_position)
    end
    for i_row in 2:length(plot_type.row_names)
        add_text_to_axis(ax[i_row+n_rows-length(plot_type.row_names),n_columns], plot_type.row_names[i_row], loc=plot_type.names_position)
    end
    for i_column in length(plot_type.column_names)-1:-1:1
        add_text_to_axis(ax[1,i_column], plot_type.column_names[i_column], loc=plot_type.names_position)
    end
    
    if plot_type.plot_combined_rows & plot_type.plot_combined_columns
        ax[1,n_columns].remove()
    end
    
    return fig, ax
end

function add_legend(plot_type::PanelPlot, ax, lines::Vector, names::Vector)
    n_columns = if plot_type.plot_combined_rows
        length(plot_type.column_names) + 1
    else
        length(plot_type.column_names)
    end
    if (plot_type.plot_combined_columns && plot_type.plot_combined_rows)
        ax[1,length(plot_type.column_names)].legend(lines, names, bbox_to_anchor=(1.04,0), loc="lower left", ncol=1)
    elseif n_columns >= 4
        ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.04), loc="lower left", ncol=4)
    elseif n_columns >= 2
        ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.04), loc="lower left", ncol=2)
    else
        ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.04), loc="lower left", ncol=1)
    end    
end
