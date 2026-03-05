
"""
    get_color_linestyle(i_color::Int64, i_linestyle::Int64;
                        n_color::Int64=2, n_linestyle::Int64=2)

Return Tuple of `color` and `linestyle`.

By default, `color` is chosen based on `i_color` (see [`get_color`](@ref)), and `linestyle` based on `i_linestyle` (see [`get_linestyle`}(@ref)).
If one `n_color` or `n_linestyle` is 1, however, we use both to indicate the other property as well.
"""
function get_color_linestyle(i_color::Int64, i_linestyle::Int64;
                             n_color::Int64=2, n_linestyle::Int64=2)
    if n_color > 1
        color = get_color(i_color)
    else
        color = get_color(i_linestyle)
    end
    if n_linestyle > 1
        linestyle = get_linestyle(i_linestyle)
    else
        linestyle = get_linestyle(i_color)
    end
    return color, linestyle
end

