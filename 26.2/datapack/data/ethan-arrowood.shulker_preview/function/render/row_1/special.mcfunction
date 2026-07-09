# items that require special rendering, like model overrides or colored layers
$data modify storage ethan-arrowood.shulker_preview:data item merge from storage ethan-arrowood.shulker_preview:data lookups.colors."$(id)"
execute if items entity @s contents #ethan-arrowood.shulker_preview:special_render/overrides run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/overrides
execute if items entity @s contents #ethan-arrowood.shulker_preview:special_render/grass_colored run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/grass_colored with storage ethan-arrowood.shulker_preview:data item
execute if items entity @s contents #minecraft:cauldron_can_remove_dye run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/dyeable1
execute if items entity @s contents #ethan-arrowood.shulker_preview:special_render/potion run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/potion1
execute if items entity @s contents firework_star run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/star1
execute if items entity @s contents filled_map run return run function ethan-arrowood.shulker_preview:render/row_1/special_render/map1
