# recursively render banner patterns using a macro
function ethan-arrowood.shulker_preview:render/banner_color with storage ethan-arrowood.shulker_preview:data item.components."minecraft:banner_patterns"[0]
function ethan-arrowood.shulker_preview:render/row_2/overlay/shield_patterns_one with storage ethan-arrowood.shulker_preview:data item.components."minecraft:banner_patterns"[0]
data remove storage ethan-arrowood.shulker_preview:data item.components."minecraft:banner_patterns"[0]
execute if data storage ethan-arrowood.shulker_preview:data item.components."minecraft:banner_patterns"[0] run function ethan-arrowood.shulker_preview:render/row_2/overlay/shield_patterns_loop
