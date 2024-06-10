struct ProfilePlot <: PlotType
    print_columns::Number
    n_profiles::Int64
    xlabel::AbstractString
    ylabels::Union{String,Vector{String}}
    function ProfilePlot(; print_columns::Number=2, n_profiles::Int64=1,
                         xlabel::String="", ylabels::Union{String,Vector{String}}="")
        new(print_columns, n_profiles,
            xlabel, ylabels)
    end
end

function setup_profile_plot(; print_columns::Number=2, n_profiles::Int64=1,
                            xlabel::String="", ylabels::Union{String,Vector{String}}="")
    setup_plot(ProfilePlot(print_columns=print_columns, n_profiles=n_profiles,
                           xlabel=xlabel,ylabels=ylabels))
end

function setup_plot(plot_type::ProfilePlot)
    ylabels, wspace = if typeof(plot_type.ylabels) <: AbstractString
        [plot_type.ylabels], 0.01
    else
        plot_type.ylabels, get_left(4*plot_type.n_profiles)/(0.99/plot_type.n_profiles-get_left(4*plot_type.n_profiles))
    end
    
    fig = figure(figsize=(4*plot_type.n_profiles,4))
    style_plot(fig_width=4*plot_type.n_profiles, print_columns=plot_type.print_columns)
    gs = fig.add_gridspec(1,plot_type.n_profiles, hspace=get_bottom(4), wspace=wspace, left=get_left(4*plot_type.n_profiles), right=0.99, top=0.99, bottom=get_bottom(4))
    ax = gs.subplots()
    ax = if plot_type.n_profiles == 1
        [ax]
    else
        ax
    end
    for i_ax in 1:plot_type.n_profiles
        ax[i_ax].set_xlabel(plot_type.xlabel)
    end
    for i_label in 1:minimum([length(ylabels),plot_type.n_profiles])
        ax[i_label].set_ylabel(ylabels[i_label])
    end
    return fig, ax
    
end
