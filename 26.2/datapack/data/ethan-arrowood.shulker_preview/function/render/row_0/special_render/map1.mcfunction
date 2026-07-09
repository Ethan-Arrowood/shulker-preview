# maps can be any color, so a macro is needed
data modify storage ethan-arrowood.shulker_preview:data item merge value {red:"46",green:"40","blue":"2e"}
execute store success score #has_color shulker_preview store result score #color shulker_preview run data get storage ethan-arrowood.shulker_preview:data item.components."minecraft:map_color"
execute if score #has_color shulker_preview matches 1 run function ethan-arrowood.shulker_preview:render/convert_color
function ethan-arrowood.shulker_preview:render/row_0/special_render/map2 with storage ethan-arrowood.shulker_preview:data item
