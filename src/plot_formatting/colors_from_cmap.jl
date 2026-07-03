using PyPlot

"""
    get_color_from_colormap(i::Int64; i_min::Real=1, i_max::Real=2,
                            cmap::String="Plasma")

Return the color corresponding to the colormap value at `(i-i_min)/(i_max-i_min)`.
"""
function get_color_from_colormap(i::Int64; i_min::Real=1, i_max::Real=2,
                                 cmap::String="Plasma")
    c = matplotlib.cm.get_cmap(cmap)
    return c((i-i_min)/(i_max-i_min))
end
