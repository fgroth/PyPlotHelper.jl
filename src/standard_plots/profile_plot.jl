using PyPlot

struct ProfilePlot <: PlotType
    print_columns::Number
    n_profiles::Int64
    xlabel::AbstractString
    ylabel::Union{AbstractString,Vector{String}}
    xscale::AbstractString
    yscale::Union{AbstractString,Vector}
    xlim::Union{Nothing,Vector}
    ylim::Union{Nothing,Vector}
    column_names::Vector{String}
    comparison_panel_yrange::Union{Nothing,Vector}
    comparison_panel_name::String
    function ProfilePlot(; print_columns::Number=2, n_profiles::Int64=1,
                         xlabel::AbstractString="", ylabel::Union{AbstractString,Vector{String}}="",
                         xscale::AbstractString="log", yscale::Union{AbstractString,Vector}="log",
                         xlim::Union{Nothing,Vector}=nothing, ylim::Union{Nothing,Vector}=nothing,
                         column_names::Vector{String}=String[],
                         comparison_panel_yrange::Union{Nothing,Vector}=nothing, comparison_panel_name::String="")
        new(print_columns, n_profiles,
            xlabel, ylabel,
            xscale, yscale,
            xlim, ylim,
            column_names,
            comparison_panel_yrange,comparison_panel_name)
    end
end

function setup_profile_plot(; print_columns::Number=2, n_profiles::Int64=1,
                            xlabel::String="", ylabel::Union{String,Vector{String}}="")
    setup_plot(ProfilePlot(print_columns=print_columns, n_profiles=n_profiles,
                           xlabel=xlabel,ylabel=ylabel))
end

function setup_plot(plot_type::ProfilePlot)
    height = if plot_type.comparison_panel_yrange != nothing
        6
    else
        4
    end
    fig = figure(figsize=(4*plot_type.n_profiles,height))
    style_plot(fig_width=4*plot_type.n_profiles, print_columns=plot_type.print_columns)

    ylabel, wspace = if typeof(plot_type.ylabel) <: AbstractString
        [plot_type.ylabel], 0.01
    else
        plot_type.ylabel, get_left(width=4*plot_type.n_profiles, large=true)/(0.99/plot_type.n_profiles-get_left(width=4*plot_type.n_profiles, large=true))
    end
    n_rows, height_ratios = if plot_type.comparison_panel_yrange != nothing
        2, [2,1]
    else
        1, [1]
    end
    bottom = if n_rows == 1
        get_bottom(height=4, large=true)
    else
        get_bottom(height=4, large=true) / 1.5
    end
    gs = fig.add_gridspec(n_rows,plot_type.n_profiles, hspace=0.01, wspace=wspace, left=get_left(width=4*plot_type.n_profiles, large=true), right=0.99, top=0.99, bottom=bottom, height_ratios=height_ratios)
    ax = gs.subplots()
    ax = if plot_type.n_profiles == 1 && n_rows == 1
        [ax]
    else
        ax
    end
    reshape(ax, n_rows, plot_type.n_profiles)
    
    # setup x axis
    for i_col in 1:plot_type.n_profiles
        # main plot
        ax[1,i_col].set_xscale(plot_type.xscale)
        if typeof(plot_type.xlim) <: Nothing
            ax[1,i_col].set_xlim(auto=true)
        else
            ax[1,i_col].set_xlim(plot_type.xlim)
        end
        # comparison panel
        if plot_type.comparison_panel_yrange != nothing
            ax[2,i_col].set_xscale(plot_type.xscale)
            if typeof(plot_type.xlim) <: Nothing
                ax[2,i_col].set_xlim(auto=true)
            else
                ax[2,i_col].set_xlim(plot_type.xlim)
            end    
        end
        # xlabel (depends on if comparison_panel exists)
        if plot_type.comparison_panel_yrange != nothing
            ax[2,i_col].set_xlabel(plot_type.xlabel)
            # also remove xtickslabels for upper panel
            ax[1,i_col].set_xticklabels([])
        else
            ax[1,i_col].set_xlabel(plot_type.xlabel)
        end
    end
    # setup yaxis: label
    for i_label in 1:minimum([length(ylabel),plot_type.n_profiles])
        ax[1,i_label].set_ylabel(ylabel[i_label])
        # comparison ylabel
        if plot_type.comparison_panel_yrange != nothing
            ax[2,i_label].set_ylabel(plot_type.comparison_panel_name)
        end
    end
    # setup yaxis: scaling
    for i_col in 1:plot_type.n_profiles
        if typeof(plot_type.yscale) <: AbstractString
            ax[1,i_col].set_yscale(plot_type.yscale)
        else 
            ax[1,i_col].set_yscale(plot_type.yscale[i_col])
        end
        # comparison panel: yscaling and identity line
        if plot_type.comparison_panel_yrange != nothing
            ax[2,i_col].set_yscale("log")
            ax[2,i_col].set_yticks([minimum(plot_type.comparison_panel_yrange),1,maximum(plot_type.comparison_panel_yrange)])
            ax[2,i_col].yaxis.set_major_formatter(matplotlib.ticker.ScalarFormatter())
            ax[2,i_col].yaxis.set_minor_formatter(matplotlib.ticker.NullFormatter())
            if plot_type.xlim != nothing
                ax[2,i_col].plot(plot_type.xlim,[1,1],color="black",linestyle="dotted")
            end
        end
    end
    
    # setup yaxis: limits
    for i_col in 1:plot_type.n_profiles
        if typeof(plot_type.ylim) <: Nothing
            ax[1,i_col].set_ylim(auto=true)
        elseif typeof(plot_type.ylim[1]) <: Number
                ax[1,i_col].set_ylim(plot_type.ylim)
        else # Vector of Vector
            ax[1,i_col].set_ylim(plot_type.ylim[i_col])
        end
        # comarison yaxis: limits
        if plot_type.comparison_panel_yrange != nothing
            ax[2,i_col].set_ylim(plot_type.comparison_panel_yrange)
        end
    end
    # axis: remove ticklabels if necessary
    if wspace == 0.01
        for i_col in 2:plot_type.n_profiles
            ax[1,i_col].set_yticklabels([])
            # also for comparison axis
            if plot_type.comparison_panel_yrange != nothing
                ax[2,i_col].set_yticklabels([])
            end
        end
    end
    
    # add the column names
    for i_label in 1:minimum([length(plot_type.column_names),plot_type.n_profiles])
        add_text_to_axis(ax[1,i_label], plot_type.column_names[i_label], loc="lower left")
    end
    
    return fig, ax
    
end

function add_legend(plot_type::ProfilePlot, ax, lines::Vector, names::Vector)
    if typeof(lines[1]) <: Vector # several legends
        for i_legend in 1:length(lines)
            ax[1,mod(i_legend-1,plot_type.n_profiles)+1].legend(lines[i_legend],names[i_legend])
        end
    else
        ax[1,1].legend(lines, names)
    end
end
