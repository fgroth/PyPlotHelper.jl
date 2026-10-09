
global default_marker_cycle = ["o", # circle,
                               "+", # plus
                               "*", # star
                               "^", # triangle up
                               "x", # x
                               "v", # triangle down
                               "s"] # square
global marker_cycle = default_marker_cycle

"""
    set_marker_cycle(new_marker_cycle::Vector)

Adjust the marker cycle variable. Also see [`reset_marker_cycle`](@ref).
"""
function set_marker_cycle(new_marker_cycle::Vector)
    global marker_cycle = new_marker_cycle
end
"""
    reset_marker_cycle()

Reset the marker cycle variable to the default value.
"""
function reset_marker_cycle()
    global marker_cycle = default_marker_cycle
end
"""
    get_marker(i::Int64=1)

Return the marker at index i of the commonly used marker-cycle.
"""
function get_marker(i::Int64=1)
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

"""
    get_fillstyle(i::Int64=1)

Return the marker fillstyle at index i for the commonly used fillstyle cycle.
"""
function get_fillstyle(i::Int64=1)
    fillstyle_cycle = ["none",
                       "full",
                       "top",
                       "bottom",
                       "right",
                       "left"]
    return fillstyle_cycle[mod(i-1,length(fillstyle_cycle))+1]
end
