using PyCall
using PyPlot

"""
    fill_between_dm(ax::PyCall.PyObject, fill_between_args... ;
                    alpha::Real=1.0, color=main_foreground_color(), fill_between_kwargs...)

do `ax.fill_between`, but at a white patch below for dark mode to achive color consitency.
"""
function fill_between_dm(ax::PyCall.PyObject, fill_between_args... ;
                         alpha::Real=1.0, color=main_foreground_color(), fill_between_kwargs...)
    if dark_mode_active && alpha != 1
        ax.fill_between(fill_between_args..., color="white", zorder=0.5 ; fill_between_kwargs...)
    end
    ax.fill_between(fill_between_args..., alpha=alpha, color=color ; fill_between_kwargs...)
end
