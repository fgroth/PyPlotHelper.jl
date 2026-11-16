
"""
    get_color_marker(i_color::Int64, i_marker::Int64;
                     n_color::Int64=2, n_marker::Int64=2,
                     get_color::Function=get_color, get_marker::Function=get_marker)

Return Tuple of `color` and `marker`.

By default, `color` is chosen based on `i_color` (see [`get_color`](@ref)), and `marker` based on `i_marker` (see [`get_marker`](@ref)).
If one `n_color` or `n_marker` is 1, however, we use both to indicate the other property as well.
"""
function get_color_marker(i_color::Int64, i_marker::Int64;
                          n_color::Int64=2, n_marker::Int64=2,
                          get_color::Function=get_color, get_marker::Function=get_marker)
    if n_color > 1
        color = get_color(i_color)
    else
        color = get_color(i_marker)
    end
    if n_marker > 1
        marker = get_marker(i_marker)
    else
        marker = get_marker(i_color)
    end
    return color, marker
end
