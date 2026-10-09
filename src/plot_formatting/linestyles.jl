
"""
    get_linestyle(i::Int64=1)

Return the linestyle at index i of the commonly used lienstyle-cycle.
"""
function get_linestyle(i::Int64=1)
    linestyle_cycle = ["solid", "dashed", "dashdot", "dotted"]
    return linestyle_cycle[mod(i-1,length(linestyle_cycle))+1] # repeat for numbers outside length
end
