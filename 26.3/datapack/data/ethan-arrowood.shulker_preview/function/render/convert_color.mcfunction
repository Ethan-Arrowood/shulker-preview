# convert an RGB color int to a hex color for macros
# simply divide out the individual channels and get the hex digits from a lookup table
scoreboard players operation #blue shulker_preview = #color shulker_preview
execute store result storage ethan-arrowood.shulker_preview:data color.blue int 1 run scoreboard players operation #blue shulker_preview %= #256 shulker_preview
scoreboard players operation #color shulker_preview /= #256 shulker_preview
scoreboard players operation #green shulker_preview = #color shulker_preview
execute store result storage ethan-arrowood.shulker_preview:data color.green int 1 run scoreboard players operation #green shulker_preview %= #256 shulker_preview
execute store result storage ethan-arrowood.shulker_preview:data color.red int 1 run scoreboard players operation #color shulker_preview /= #256 shulker_preview
function ethan-arrowood.shulker_preview:render/hex_color with storage ethan-arrowood.shulker_preview:data color
