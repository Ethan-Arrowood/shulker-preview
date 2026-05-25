# exit immediately if a box was already processed this tick
# this check needs to go here because the functions get queued before executing
execute unless score #ready shulker_preview matches 1 run return fail

# Reprocess any dropped shulker box with items inside, even if it already
# carries the "processed" flag. Breaking a shulker box in creative goes through
# ShulkerBoxBlock.playerWillDestroy, which applies the block entity's full
# collectComponents() to the drop (not the loot table's restricted copy list),
# so the stale custom_data flag and old lore survive a place->break edit and the
# preview would otherwise never refresh. A dropped item is a ground entity, not
# a hovered inventory slot, so regenerating its lore here is flicker-free; the
# row modifiers replace_all the lore, so reprocessing can't duplicate lines.
execute if items entity @s contents #tryashtar.shulker_preview:shulker_boxes[container~{items:{size:{min:1}}}] run function tryashtar.shulker_preview:shulker_box/process_dropped

# don't check this item again, whether or not it was processed
tag @s add shulker_preview.checked
