using PyPlot

"""
    get_linestyle(i::Int64=1)

Return the linestyle at index i of the commonly used lienstyle-cycle.
"""
function get_linestyle(i::Int64=1)
    linestyle_cycle = ["solid", "dashed", "dashdot", "dotted"]
    return linestyle_cycle[mod(i-1,length(linestyle_cycle))+1] # repeat for numbers outside length
end

"""
    get_marker(i::Int64=1)

Return the marker at index i of the commonly used marker-cycle.
"""
function get_marker(i::Int64=1)
    marker_cycle = ["o", # circle,
                    "+", # plus
                    "*", # star
                    "^", # triangle up
                    "x", # x
                    "v", # triangle down
                    "s"] # square
    return marker_cycle[mod(i-1,length(marker_cycle))+1] # repeat for numbers outside length
end

"""
    get_filled_marker(i::Int64=1)

Return the marker at index i for the commonly used filled marker cycle.
"""
function get_filled_marker(i::Int64=1)
    filled_marker_cycle = ["o", # circle
                           "v", # triangle down
                           "^", # triangle up
                           "<", # triangle left
                           ">", # triangle right
                           "8", # octagon
                           "s", # square
                           "p", # pentagon
                           "P", # plus (filled)
                           "*", # star
                           "h", # hexagon1
                           "H", # hexagon2
                           "X", # x (filled)
                           "D", # dianond
                           "d"] # thin diamond
    return filled_marker_cycle[mod(i-1,length(filled_marker_cycle))+1]
end
