# main tick function
# look for any newly dropped items or players that are pending a scan
# only one box is processed per tick, so we keep the tag on players until they're processed
scoreboard players set #ready shulker_preview 1

# Creative-mode inventory edits (creative menu, pick-block, stack duplication)
# travel through the creative-slot packet, which pre-syncs the menu's remote
# slot before broadcastChanges(). broadcastChanges then sees no difference and
# never notifies the listener, so the inventory_changed advancement that drives
# box detection does not fire. Periodically flag creative players for a normal
# rescan to catch boxes changed that way. The scan is a no-op when every box is
# already processed, so idle creative players cost only one cheap count check.
scoreboard players add #creative_rescan shulker_preview 1
execute if score #creative_rescan shulker_preview matches 10.. run scoreboard players set #creative_rescan shulker_preview 0
execute if score #shulker_enabled shulker_preview matches 1 if score #creative_rescan shulker_preview matches 0 as @a[gamemode=creative] run tag @s add shulker_preview.shulker_box

execute if score #shulker_enabled shulker_preview matches 1 as @e[type=item,tag=!shulker_preview.checked] at @s run function tryashtar.shulker_preview:shulker_box/check_dropped
execute if score #shulker_enabled shulker_preview matches 1 as @a[tag=shulker_preview.shulker_box] at @s run function tryashtar.shulker_preview:shulker_box/check_player
execute if score #ender_enabled shulker_preview matches 1 as @a[tag=shulker_preview.ender_chest] at @s run function tryashtar.shulker_preview:ender_chest/check_player
