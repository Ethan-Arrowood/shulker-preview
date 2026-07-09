# runs every second to find players who have changed their ender chest items
execute if score #ender_enabled shulker_preview matches 1 run schedule function ethan-arrowood.shulker_preview:ender_chest/tick 1s
execute as @a run function ethan-arrowood.shulker_preview:ender_chest/player_tick
