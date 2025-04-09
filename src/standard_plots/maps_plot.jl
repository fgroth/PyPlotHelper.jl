using PyPlot

struct MapsPlot <: PlotType
    print_columns::Number
    n_to_plot::Union{Integer,Tuple{Integer,Integer}}
    external_colorscale::Union{Nothing,String}
    function MapsPlot(; print_columns::Number=2, n_to_plot::Union{Integer,Tuple{Integer,Integer}}=2,
                      external_colorscale::Union{Nothing,String}=nothing)
        new(print_columns,n_to_plot,
            external_colorscale)
    end
end

function setup_maps_plot(; maps_kw::NamedTuple=(;))
    setup_plot(MapsPlot(;maps_kw...))
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

    right_space, top_space = if plot_type.external_colorscale == nothing
        0, 0
    elseif plot_type.external_colorscale == "top"
        0, 0.2*n_rows + get_bottom(height=4*n_rows)*4*n_rows
    elseif plot_type.external_colorscale == "right"
        0.2*n_cols + get_left(width=4*n_cols)*4*n_cols, 0
    else
        error("value for external_colorscale not supported (yet).")
    end

    # now create the actual figure and axis
    fig = figure(figsize=(4*n_cols+right_space,4*n_rows+top_space))
    style_plot(fig_width=4*n_cols,print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(n_rows,n_cols, hspace=0.01, wspace=0.01, left=0.01,right=0.99-right_space/(4*n_rows+right_space),top=0.99-top_space/(4*n_rows+top_space),bottom=0.01)
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

"""
    add_colorscale(plot_type::MapsPlot, fig;
                   position::Union{Nothing,String,Integer,Tuple{Integer,Integer}}=nothing,
                   cmap::String="plasma",
                   vmin::Number=0, vmax::Number=1, label::AbstractString=L"\\log\\rho")

Plot a colorbar into an existing figure.
"""
function add_colorscale(plot_type::MapsPlot, fig;
                        position::Union{Nothing,String,Integer,Tuple{Integer,Integer}}=nothing,
                        cmap::String="plasma",
                        vmin::Number=0, vmax::Number=1, label::AbstractString=L"\log\rho")

    # some checks for consistent values
    if position == "right" && plot_type.external_colorscale != "right"
        error("position='right' not allowed if no space was left in figure (plot_type.external_colorscale != 'right')")
    elseif position == "top" && plot_type.external_colorscale != "top"
        error("position='top' not allowed if no space was left in figure (plot_type.external_colorscale != 'top')")
    end
    # todo: check that we don't exceed the maximum axis number

    # choose proper default value
    if position == nothing && typeof(plot_type.external_colorscale) <: String
        position = plot_type.external_colorscale
    elseif position == nothing && typeof(n_to_plot) <: Integer
        position = 1
    elseif position == nothing && typeof(n_to_plot) <: Tuple{Integer,Integer}
        position=(1,1)
    end

    # add the colorscale for the different cases
    if position == "top"
        n_rows = if typeof(plot_type.n_to_plot) <: Integer
            1
        else
            plot_type.n_to_plot[1]
        end
        top_space = 0.2*n_rows
        top_space_labels = get_bottom(height=4*n_rows)*4*n_rows

        cb_ax = fig.add_axes([0.01, 1.0-(top_space+top_space_labels)/(4*n_rows+top_space+top_space_labels), 0.98, top_space/(4*n_rows+top_space)-0.02])
        cb = colorbar(matplotlib.cm.ScalarMappable(cmap=cmap, norm=matplotlib.colors.Normalize(vmin=vmin, vmax=vmax)), cb_ax, orientation="horizontal")
        cb_ax.xaxis.set_ticks_position("top")
        cb.ax.set_title(label)
    elseif position == "right"
        n_cols = if typeof(plot_type.n_to_plot) <: Integer
            plot_type.n_to_plot
        else
            plot_type.n_to_plot[2]
        end
        right_space = 0.2*n_cols
        right_space_labels = get_left(width=4*n_cols)*4*n_cols

        cb_ax = fig.add_axes([1.0-(right_space+right_space_labels)/(4*n_cols+right_space+right_space_labels), 0.01, right_space/(4*n_cols+right_space)-0.02, 0.98])
        cb = colorbar(matplotlib.cm.ScalarMappable(cmap=cmap, norm=matplotlib.colors.Normalize(vmin=vmin, vmax=vmax)), cb_ax, orientation="vertical")
        cb_ax.yaxis.set_ticks_position("right")
        cb.set_label(label)        
    else
        error("not implemented yet")
    end
    
end

"""
    create_separate_colorscale(; orientation::String="horizontal",
                               print_columns::Number=2,
                               cmap::String="plasma",
                               vmin::Number=0, vmax::Number=1,
                               units::AbstractString=L"\\log\\rho",
                               oname::String="colorscale.pdf")

Create and save a colorbar in a separate figure.
"""
function create_separate_colorscale(; orientation::String="horizontal",
                                    print_columns::Number=2,
                                    cmap::String="plasma",
                                    vmin::Number=0, vmax::Number=1,
                                    units::AbstractString=L"\log\rho",
                                    oname::String="colorscale.pdf")

    if orientation=="horizontal"
        style_plot(print_columns=print_columns, fig_width=16/print_columns)

        cb_height = 0.2
        text_height = get_bottom(height=1)
        text_height *= 0.5 + sqrt(0.25+cb_height)
        
        fig = figure(figsize=(16/print_columns, cb_height+text_height))
        cb_ax = fig.add_axes([0.01, 0.01, 0.98, (cb_height-0.02)/(cb_height+text_height)])
        cb = colorbar(matplotlib.cm.ScalarMappable(cmap=cmap, norm=matplotlib.colors.Normalize(vmin=vmin, vmax=vmax)), cb_ax, orientation="horizontal")
        cb_ax.xaxis.set_ticks_position("top")
        cb.ax.set_title(units)
    elseif orientation == "vertical"
        # to implement
    else
        error("orientation has to be either horizontal or vertical")
    end
    
    fig.savefig(oname)

end
