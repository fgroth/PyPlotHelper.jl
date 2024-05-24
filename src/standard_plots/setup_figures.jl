using PyPlot

struct PanelPlot
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
    function PanelPlot(; print_columns::Number=1, plot_combined_columns::Bool=true, plot_combined_rows::Bool=true,
                       xscale::String="log", yscale::String="linear",xlim::Vector=[1e-2,1e0],ylim::Vector=[0,1],
                       xlabel::AbstractString="",ylabel::AbstractString="",
                       row_names::Vector{String}=["MFM","SPH"], column_names::Vector{String}=["relaxed","active"],
                       names_position::String="center left")
        new(print_columns,plot_combined_columns,plot_combined_rows,
            xscale,yscale,xlim,ylim,
            xlabel,ylabel,
            row_names, column_names,
            names_position)
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
    ax = if plot_type.n_to_plot == 1
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
    fig = figure(figsize=(4*n_columns,4*n_rows))
    style_plot(fig_width=4*n_columns, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(n_rows,n_columns, left=0.1,right=0.99, bottom=0.1, top=0.99,hspace=0.01, wspace=0.01)
    ax = gs.subplots()

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
    # positions in axes units
    x_text, horizontalalignment = if plot_type.names_position == "center"
        0.5, "center"
    elseif split(plot_type.names_position)[2] == "center"
        0.5, "center"
    elseif split(plot_type.names_position)[2] == "left"
        0.02, "left"
    elseif split(plot_type.names_position)[2] == "right"
        0.98, "right"
    end
    y_text, verticalalignment = if plot_type.names_position == "center"
        0.5, "center"
    elseif split(plot_type.names_position)[1] == "center"
        0.5, "center"
    elseif split(plot_type.names_position)[1] == "lower"
        0.02, "bottom"
    elseif split(plot_type.names_position)[1] == "upper"
        0.98, "top"
    end
    if !plot_type.plot_combined_rows & !plot_type.plot_combined_columns
        ax[1,n_columns].text(x_text,y_text,plot_type.row_names[1]*" "*plot_type.column_names[2], transform=ax[n_rows-1,n_columns].transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment)
    else
        ax[1+n_rows-length(plot_type.row_names),n_columns].text(x_text,y_text,plot_type.row_names[1], transform=ax[2,n_columns].transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment)
        ax[1,length(plot_type.column_names)].text(x_text,y_text,plot_type.column_names[end], transform=ax[1,length(plot_type.column_names)].transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment)
    end
    for i_row in 2:length(plot_type.row_names)
        ax[i_row+n_rows-length(plot_type.row_names),n_columns].text(x_text,y_text,plot_type.row_names[i_row], transform=ax[i_row+n_rows-length(plot_type.row_names),n_columns].transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment)
    end
    for i_column in length(plot_type.column_names)-1:-1:1
        ax[1,i_column].text(x_text,y_text,plot_type.column_names[i_column], transform=ax[1,i_column].transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment)
    end
    
    if plot_type.plot_combined_rows & plot_type.plot_combined_columns
        ax[1,n_columns].remove()
    end
    
    return fig, ax
end
