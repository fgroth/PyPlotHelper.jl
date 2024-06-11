struct ProfilePlot <: PlotType
    print_columns::Number
    n_profiles::Int64
    xlabel::AbstractString
    ylabel::Union{String,Vector{String}}
    function ProfilePlot(; print_columns::Number=2, n_profiles::Int64=1,
                         xlabel::String="", ylabel::Union{String,Vector{String}}="")
        new(print_columns, n_profiles,
            xlabel, ylabel)
    end
end

function setup_profile_plot(; print_columns::Number=2, n_profiles::Int64=1,
                            xlabel::String="", ylabel::Union{String,Vector{String}}="")
    setup_plot(ProfilePlot(print_columns=print_columns, n_profiles=n_profiles,
                           xlabel=xlabel,ylabel=ylabel))
end

function setup_plot(plot_type::ProfilePlot)
    ylabel, wspace = if typeof(plot_type.ylabel) <: AbstractString
        [plot_type.ylabel], 0.01
    else
        plot_type.ylabel, get_left(width=4*plot_type.n_profiles, large=true)/(0.99/plot_type.n_profiles-get_left(width=4*plot_type.n_profiles, large=true))
    end
    
    fig = figure(figsize=(4*plot_type.n_profiles,4))
    style_plot(fig_width=4*plot_type.n_profiles, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(1,plot_type.n_profiles, hspace=get_bottom(height=4, large=true), wspace=wspace, left=get_left(width=4*plot_type.n_profiles, large=true), right=0.99, top=0.99, bottom=get_bottom(height=4, large=true))
    ax = gs.subplots()
    ax = if plot_type.n_profiles == 1
        [ax]
    else
        ax
    end
    for i_ax in 1:plot_type.n_profiles
        ax[i_ax].set_xlabel(plot_type.xlabel)
    end
    for i_label in 1:minimum([length(ylabel),plot_type.n_profiles])
        ax[i_label].set_ylabel(ylabel[i_label])
    end
    return fig, ax
    
end

function add_legend(plot_type::ProfilePlot, ax, lines::Vector, names::Vector)
    if typeof(lines[1]) <: Vector # several legends
        for i_legend in 1:length(lines)
            ax[mod(i_legend-1,plot_type.n_profiles)+1].legend(lines[i_legend],names[i_legend])
        end
    else
        ax[1].legend(lines, methods)
    end
end
