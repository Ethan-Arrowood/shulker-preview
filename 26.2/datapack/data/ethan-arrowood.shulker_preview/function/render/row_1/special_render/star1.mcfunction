# firework stars can be any color, so a macro is needed
data modify storage ethan-arrowood.shulker_preview:data item merge value {red:"8a",green:"8a","blue":"8a"}
function ethan-arrowood.shulker_preview:render/star_color
function ethan-arrowood.shulker_preview:render/row_1/special_render/star2 with storage ethan-arrowood.shulker_preview:data item
