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
    function ProfilePlot(; print_columns::Number=2, n_profiles::Int64=1,
                         xlabel::AbstractString="", ylabel::Union{AbstractString,Vector{String}}="",
                         xscale::AbstractString="log", yscale::Union{AbstractString,Vector}="log",
                         xlim::Union{Nothing,Vector}=nothing, ylim::Union{Nothing,Vector}=nothing,
                         column_names::Vector{String}=String[])
        new(print_columns, n_profiles,
            xlabel, ylabel,
            xscale, yscale,
            xlim, ylim,
            column_names)
    end
end

function setup_profile_plot(; print_columns::Number=2, n_profiles::Int64=1,
                            xlabel::String="", ylabel::Union{String,Vector{String}}="")
    setup_plot(ProfilePlot(print_columns=print_columns, n_profiles=n_profiles,
                           xlabel=xlabel,ylabel=ylabel))
end

function setup_plot(plot_type::ProfilePlot)
    fig = figure(figsize=(4*plot_type.n_profiles,4))
    style_plot(fig_width=4*plot_type.n_profiles, print_columns=plot_type.print_columns)

    ylabel, wspace = if typeof(plot_type.ylabel) <: AbstractString
        [plot_type.ylabel], 0.01
    else
        plot_type.ylabel, get_left(width=4*plot_type.n_profiles, large=true)/(0.99/plot_type.n_profiles-get_left(width=4*plot_type.n_profiles, large=true))
    end
    
    gs = fig.add_gridspec(1,plot_type.n_profiles, hspace=get_bottom(height=4, large=true), wspace=wspace, left=get_left(width=4*plot_type.n_profiles, large=true), right=0.99, top=0.99, bottom=get_bottom(height=4, large=true))
    ax = gs.subplots()
    ax = if plot_type.n_profiles == 1
        [ax]
    else
        ax
    end
    # setup x axis
    for i_ax in 1:plot_type.n_profiles
        ax[i_ax].set_xlabel(plot_type.xlabel)
        ax[i_ax].set_xscale(plot_type.xscale)
        if typeof(plot_type.xlim) <: Nothing
            ax[i_ax].set_xlim(auto=true)
        else
            ax[i_ax].set_xlim(plot_type.xlim)
        end
    end
    # setup yaxis: label
    for i_label in 1:minimum([length(ylabel),plot_type.n_profiles])
        ax[i_label].set_ylabel(ylabel[i_label])
    end
    # setup yaxis: scaling
    for i_ax in 1:plot_type.n_profiles
        if typeof(plot_type.yscale) <: AbstractString
            ax[i_ax].set_yscale(plot_type.yscale)
        else 
            ax[i_ax].set_yscale(plot_type.yscale[i_ax])
        end
    end
    # setup yaxis: limits
    for i_ax in 1:plot_type.n_profiles
        if typeof(plot_type.ylim) <: Nothing
            ax[i_ax].set_ylim(auto=true)
        elseif typeof(plot_type.ylim[1]) <: Number
                ax[i_ax].set_ylim(plot_type.ylim)
        else # Vector of Vector
            ax[i_ax].set_ylim(plot_type.ylim[i_ax])
        end
    end
    # axis: remove ticklabels if necessary
    if wspace == 0.01
        for i_ax in 2:plot_type.n_profiles
            ax[i_ax].set_yticklabels([])
        end
    end
    
    # add the column names
    for i_label in 1:minimum([length(plot_type.column_names),plot_type.n_profiles])
        add_text_to_axis(ax[i_label], plot_type.column_names[i_label], loc="lower left")
    end
    
    return fig, ax
    
end

function add_legend(plot_type::ProfilePlot, ax, lines::Vector, names::Vector)
    if typeof(lines[1]) <: Vector # several legends
        for i_legend in 1:length(lines)
            ax[mod(i_legend-1,plot_type.n_profiles)+1].legend(lines[i_legend],names[i_legend])
        end
    else
        ax[1].legend(lines, names)
    end
end
