using PyPlot

"""
    rainbow_text(fig, ax,
                 x::Number, y::Number,
                 text::Array{String}, colors::Array;
                 space=0.2, text_args::NamedTuple=NamedTuple())

Print text in multiple colors.
"""
function rainbow_text(fig, ax,
                      x::Number, y::Number,
                      text::Array{String}, colors::Array;
                      space=0.2, text_args::NamedTuple=NamedTuple())

    for i_text in 1:length(text)
        this_text = ax.text(x,y,text[i_text]*" ", color=colors[i_text], horizontalalignment="left", transform=ax.transAxes, ;text_args...)
        transf = ax.transData.inverted()
        x = x + space
    end
end
