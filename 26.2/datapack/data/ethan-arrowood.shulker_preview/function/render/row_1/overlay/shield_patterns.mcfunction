# render banner patterns as overlays
# first move the cursor back on top of the item, then draw the overlays, then put the cursor after the item again
data modify storage ethan-arrowood.shulker_preview:data tooltip append value {translate:"ethan-arrowood.shulker_preview.overlay"}
function ethan-arrowood.shulker_preview:render/row_1/overlay/shield_patterns_loop
data modify storage ethan-arrowood.shulker_preview:data tooltip append value {translate:"ethan-arrowood.shulker_preview.overlay_done"}
