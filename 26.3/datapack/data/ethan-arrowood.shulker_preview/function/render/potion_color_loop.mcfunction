# recursively iterate through the potion effects, accumulating each color
# the amplifier isn't present if 0, but that sets the score properly anyway
execute store result score #amplifier shulker_preview run data get storage ethan-arrowood.shulker_preview:data item.components."minecraft:potion_contents".custom_effects[-1].amplifier
scoreboard players add #amplifier shulker_preview 1
function ethan-arrowood.shulker_preview:render/potion_color_get with storage ethan-arrowood.shulker_preview:data item.components."minecraft:potion_contents".custom_effects[-1]

# iterate to the next effect
data remove storage ethan-arrowood.shulker_preview:data item.components."minecraft:potion_contents".custom_effects[-1]
execute if data storage ethan-arrowood.shulker_preview:data item.components."minecraft:potion_contents".custom_effects[0] run function ethan-arrowood.shulker_preview:render/potion_color_loop
