abstract type PlotType end

"""
    add_text_to_axis(ax, text::AbstractString; loc::String="upper right",
                     test_kw::NamedTuple)

Add text to an axis with `loc="center"/"lower/center/upper left/center/right"`
"""
function add_text_to_axis(ax, text::AbstractString; loc::String="upper right",
                          text_kw::NamedTuple=(;))
    # positions in axes units
    x_text, horizontalalignment = if loc == "center"
        0.5, "center"
    elseif split(loc)[2] == "center"
        0.5, "center"
    elseif split(loc)[2] == "left"
        0.02, "left"
    elseif split(loc)[2] == "right"
        0.98, "right"
    end
    y_text, verticalalignment = if loc == "center"
        0.5, "center"
    elseif split(loc)[1] == "center"
        0.5, "center"
    elseif split(loc)[1] == "lower"
        0.02, "bottom"
    elseif split(loc)[1] == "upper"
        0.98, "top"
    end
    ax.text(x_text,y_text, text, transform=ax.transAxes, horizontalalignment=horizontalalignment, verticalalignment=verticalalignment,
            ;text_kw...)
end
