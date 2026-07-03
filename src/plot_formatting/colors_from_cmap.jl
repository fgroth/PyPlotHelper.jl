using PyPlot

"""
    get_color_from_colormap(i::Real; i_min::Real=1, i_max::Real=2,
                            cmap::String="plasma")

Return the color corresponding to the colormap value at `(i-i_min)/(i_max-i_min)`.
"""
function get_color_from_colormap(i::Real; i_min::Real=1, i_max::Real=2,
                                 cmap::String="plasma")
    c = matplotlib.cm.get_cmap(cmap)
    return c((i-i_min)/(i_max-i_min))
end

"""
    set_color_cycle_colormap(i;
                             i_min::Real=NaN, i_max::Real=NaN,
                             cmap::String="plasma")

Set the color cycle based on [`get_color_from_colormap`])@ref), looping over `i`.
"""
function set_color_cycle_colormap(i;
                                  i_min::Real=NaN, i_max::Real=NaN,
                                  cmap::String="plasma")
    if isnan(i_min)
        i_min = minimum(i)
    end
    if isnan(i_max)
        i_max = maximum(i)
    end
    new_color_cycle = Any[]
    for this_i in i
        append!(new_color_cycle, [get_color_from_colormap.(this_i, i_min=i_min, i_max=i_max, cmap=cmap)])
    end
    if dark_mode_active
        global dark_mode_color_cycle = new_color_cycle
    else
        global light_mode_color_cycle = new_color_cycle
    end
end
