# check for sufficient Minecraft version
execute store result score #version shulker_preview run data get entity @a[limit=1] DataVersion
execute if score #version shulker_preview matches 1..4902 run tellraw @a [{text:"\nOutdated Minecraft version!\nYou need to be on version ",color:"red"},{text:"26.2",color:"yellow"},{text:" or later for shulker previews to work!\n"},{text:"Get the 26.1 pack here\n",color:"blue",underlined:true,click_event:{action:"open_url",url:"https://github.com/Ethan-Arrowood/shulker-preview"}},{text:"If you need 1.14-1.21, refer to the original project\n",color:"blue",underlined:true,click_event:{action:"open_url",url:"https://github.com/tryashtar/shulker-preview"}}]
execute if score #version shulker_preview matches 1..4902 run scoreboard players set #install shulker_preview -1
execute if score #version shulker_preview matches 4903.. if score #install shulker_preview matches -1 run scoreboard players set #install shulker_preview 0

# check for resource pack equipped/success message
scoreboard players add #install shulker_preview 0
execute if score #install shulker_preview matches 0 run function ethan-arrowood.shulker_preview:meta/install

# check for modded server
scoreboard players add #modded shulker_preview 0
execute if score #modded shulker_preview matches 0 store success score #modded shulker_preview run data get entity @a[limit=1] "Spigot.ticksLived"
execute if score #modded shulker_preview matches 0 store success score #modded shulker_preview run data get entity @a[limit=1] "Bukkit.updateLevel"
execute if score #modded shulker_preview matches 0 store success score #modded shulker_preview run data get entity @a[limit=1] "Paper.SpawnReason"

execute if score #modded shulker_preview matches 1 run tellraw @a [{text:"\n⚠ ",color:"#ebdd23"},{text:"Modded server detected!",color:"#d11b1b"},{text:" ⚠\n",color:"#ebdd23"},{text:"Bukkit and its derivatives can break vanilla behavior that shulker previews relies on.",color:"#f06e6e"},{text:"\n⚠ ",color:"#ebdd23"},{text:"There is no guarantee it will work!",color:"#d11b1b"},{text:" ⚠\n",color:"#ebdd23"}]
execute if score #modded shulker_preview matches 1 run scoreboard players set #modded shulker_preview 2
