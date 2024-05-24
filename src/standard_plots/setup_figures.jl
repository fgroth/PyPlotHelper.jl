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
    function PanelPlot(; print_columns::Number=1, plot_combined_columns::Bool=true, plot_combined_rows::Bool=true,
                       xscale::String="log", yscale::String="linear",xlim::Vector=[1e-2,1e0],ylim::Vector=[0,1],
                       xlabel::AbstractString="",ylabel::AbstractString="",
                       row_names::Vector{String}=["MFM","SPH"], column_names::Vector{String}=["relaxed","active"])
        new(print_columns,plot_combined_columns,plot_combined_rows,
            xscale,yscale,xlim,ylim,
            xlabel,ylabel,
            row_names, column_names)
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
    fig = figure(figsize=(12,12))
    style_plot(fig_width=12, print_columns=plot_type.print_columns)
    n_rows = if plot_type.plot_combined_columns
        3
    else
        2
    end
    n_columns = if plot_type.plot_combined_rows
        3
    else
        2
    end
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

    # text
    x_text=1.1*minimum(plot_type.xlim)
    y_text = if plot_type.yscale == "log"
        exp(0.5*log(maximum(plot_type.ylim)*minimum(plot_type.ylim)))
    else # linear
        0.5*(maximum(plot_type.ylim)+minimum(plot_type.ylim))
    end
    offset = if !plot_type.plot_combined_rows & !plot_type.plot_combined_columns
        ax[n_rows-1,n_columns].text(x_text,y_text,plot_type.row_names[1]*" "*plot_type.column_names[2])
    else
        ax[n_rows-1,n_columns].text(x_text,y_text,plot_type.row_names[1])
        ax[1,2].text(x_text,y_text,plot_type.column_names[2])
    end
    ax[n_rows,n_columns].text(x_text,y_text,plot_type.row_names[2])
    ax[1,1].text(x_text,y_text,plot_type.column_names[1])
    
    
    if plot_type.plot_combined_rows & plot_type.plot_combined_columns
        ax[1,3].remove()
    end
    
    return fig, ax
end
