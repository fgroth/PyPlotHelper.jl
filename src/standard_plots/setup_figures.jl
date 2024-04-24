using PyPlot

function setup_maps_plot(; n_to_plot::Int64=2, print_columns::Int64=2)
    fig = figure(figsize=(4*n_to_plot,4))
    style_plot(fig_width=4*n_to_plot,print_columns=print_columns)
    gs = fig.add_gridspec(1,n_to_plot, hspace=0.01, wspace=0.01, left=0.01,right=0.99,top=0.99,bottom=0.01)
    ax = gs.subplots()
    if n_to_plot == 1
        return fig, [ax]
    else
        return fig, ax
    end
end

function setup_panel_comparison_plot(; print_columns::Int64=1)
    fig = figure(figsize=(12,12))
    style_plot(fig_width=12, print_columns=print_columns)
    gs = fig.add_gridspec(3,3, left=0.1,right=0.99, bottom=0.1, top=0.99,hspace=0.01, wspace=0.01)
    ax = gs.subplots()

    return fig, ax
end
