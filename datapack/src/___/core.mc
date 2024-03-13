import ../../macros/log.mcm


function load {
    log <name> info server <Datapack reloaded>

    scoreboard objectives add ___.data dummy

    # Initializes the datapack at the first startup or new version
    execute unless score %installed ___.data matches 1 run function ___:core/install
    execute if score %installed ___.data matches 1 unless score $version ___.data matches <%config.version.int%> run {
        log <name> info server <Updated datapack>
        scoreboard players set $version ___.data 000100
    }
}


function install {
    log <name> info server <Datapack installed>
    scoreboard players set %installed ___.data 1

    scoreboard objectives add ___.data dummy
    scoreboard objectives add 2mal3.debug_mode dummy
    # Set the version in format: xx.xx.xx
    scoreboard players set $version ___.data <%config.version.int%>

    schedule 4s replace {
        tellraw @a {"text":"<name> <%config.version.str%> 2mal3 was installed!","color":"green"}
    }
}


function first_join {
    # Warns the player if he uses a not supported server software or minecraft version
    execute store result score .temp_0 ___.data run data get entity @s DataVersion
    execute unless score .temp_0 ___.data matches 3465 run tellraw @s [{"text": "[", "color": "gray"},{"text": "<name>", "color": "red", "bold": true},{"text": "]: ", "color": "gray"},{"text": "You are using the incorrect Minecraft version. Please check the website.","color": "red","bold": true}]
}

advancement first_join {
    "criteria": {
        "requirement": {
            "trigger": "minecraft:tick"
        }
    },
    "rewards": {
        "function": "___:core/first_join"
    }
}


advancement ___ {
    "display": {
        "title": "<name> <%config.version.str%>",
        "description": "<datapack description>",
        "icon": {
            "item": "minecraft:air"
        },
        "announce_to_chat": false,
        "show_toast": false
    },
    "parent": "global:2mal3",
    "criteria": {
        "trigger": {
            "trigger": "minecraft:tick"
        }
    }
}


function uninstall {
    log <name> info server <Datapack uninstalled>

    # Deletes the scoreboards
    scoreboard objectives remove ___.data

    # Sends an uninstallation message to all players
    tellraw @a {"text":"<name> <%config.version.str%> by 2mal3 was successfully uninstalled.","color": "green"}

    # Disables the datapack
    datapack disable "file/<name>"
    datapack disable "file/<name>.zip"
}
