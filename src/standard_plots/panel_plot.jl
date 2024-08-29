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
    force_number_per_column::Union{Vector,Nothing}
    small_legend::Bool
    function PanelPlot(; print_columns::Number=1, plot_combined_columns::Bool=true, plot_combined_rows::Bool=true,
                       xscale::String="log", yscale::String="linear",xlim::Vector=[1e-2,1e0],ylim::Vector=[0,1],
                       xlabel::AbstractString="",ylabel::AbstractString="",
                       row_names::Vector{String}=["MFM","SPH"], column_names::Vector{String}=["relaxed","active"],
                       names_position::String="center left",
                       no_legend::Bool=false, force_number_per_column::Union{Vector,Nothing}=nothing,
                       small_legend::Bool=false)
        new(print_columns,plot_combined_columns,plot_combined_rows,
            xscale,yscale,xlim,ylim,
            xlabel,ylabel,
            row_names, column_names,
            names_position,
            no_legend, force_number_per_column,
            small_legend)
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
    # reduce legend space to make more compact of desired
    if plot_type.small_legend
        legend_space /= 2
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
    ncol = if (plot_type.plot_combined_columns && plot_type.plot_combined_rows)
        1
    elseif n_columns >= 4
        4
    elseif n_columns >= 2
        3
    else
        1
    end
    if plot_type.force_number_per_column != nothing
        if length(plot_type.force_number_per_column) != ncol
            @warn "the default number of columns will be over-written"
            ncol = length(plot_type.force_number_per_column)
        end
        if sum(plot_type.force_number_per_column) != length(lines)
            error("the total number of elements per column does not match the total number of input lines")
        end
        maximum_number_per_column = maximum(plot_type.force_number_per_column)
        # check if we need paceholders
        if !(maximum_number_per_column == minimum(plot_type.force_number_per_column))
            # now, add some empty/invisible paceholders to labels and names, so the correct column format is enforced.
            new_lines = Vector{Any}(undef, maximum_number_per_column*length(plot_type.force_number_per_column))
            new_names = Vector{Any}(undef, maximum_number_per_column*length(plot_type.force_number_per_column))
            # create the placeholder line
            tmp_fig,tmp_ax = subplots()
            placeholder_line, = tmp_ax.plot([],[],color=background_color())
            close(tmp_fig)
            
            for i_column in 1:length(plot_type.force_number_per_column)
                # add the placeholder first
                for i_placeholder in 1:maximum_number_per_column-plot_type.force_number_per_column[i_column]
                    new_lines[maximum_number_per_column*(i_column-1)+i_placeholder] = placeholder_line
                    new_names[maximum_number_per_column*(i_column-1)+i_placeholder] = ""
                end
                for i_element in 1+maximum_number_per_column-plot_type.force_number_per_column[i_column]:maximum_number_per_column
                    new_lines[maximum_number_per_column*(i_column-1)+i_element] = popfirst!(lines)
                    new_names[maximum_number_per_column*(i_column-1)+i_element] = popfirst!(names)
                end
            end
            lines = new_lines
            names = new_names
        end
    end

    if (plot_type.plot_combined_columns && plot_type.plot_combined_rows)
        ax[1,length(plot_type.column_names)], ax[1,length(plot_type.column_names)].legend(lines, names, bbox_to_anchor=(1.02,0), loc="lower left", ncol=ncol)
    elseif n_columns >= 4
        ax[end-length(plot_type.row_names)+1,1], ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.02), loc="lower left", ncol=ncol)
    elseif n_columns >= 2
        ax[end-length(plot_type.row_names)+1,1], ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.02), loc="lower left", ncol=ncol)
    else
        ax[end-length(plot_type.row_names)+1,1], ax[end-length(plot_type.row_names)+1,1].legend(lines, names, bbox_to_anchor=(0,1.02), loc="lower left", ncol=ncol)
    end
end
