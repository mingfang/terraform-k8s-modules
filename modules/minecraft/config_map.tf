resource "k8s_core_v1_config_map" "this" {
  data = {
    "bukkit.yml" = <<-EOF
      settings:
        allow-end: true
        warn-on-overload: true
        permissions-file: permissions.yml
        update-folder: update
        plugin-profiling: false
        connection-throttle: ${var.bungeecord ? -1 : 4000}
        query-plugins: true
        deprecated-verbose: default
        shutdown-message: Server closed
        minimum-api: none
      spawn-limits:
        monsters: 70
        animals: 10
        water-animals: 15
        ambient: 15
      chunk-gc:
        period-in-ticks: 600
      ticks-per:
        animal-spawns: 400
        monster-spawns: 1
        autosave: 6000
      aliases: now-in-commands.yml
      EOF
    "server.properties" = <<-EOF
      broadcast-rcon-to-ops=true
      view-distance=10
      max-build-height=256
      server-ip=
      level-seed=
      rcon.port=25575
      gamemode=survival
      server-port=25565
      allow-nether=true
      enable-command-block=false
      enable-rcon=false
      enable-query=false
      op-permission-level=4
      prevent-proxy-connections=false
      generator-settings=
      resource-pack=
      level-name=world
      rcon.password=
      player-idle-timeout=0
      motd=A Minecraft Server
      query.port=25565
      debug=false
      force-gamemode=false
      hardcore=false
      white-list=false
      broadcast-console-to-ops=true
      pvp=true
      spawn-npcs=true
      generate-structures=true
      spawn-animals=true
      snooper-enabled=true
      difficulty=easy
      function-permission-level=2
      network-compression-threshold=256
      level-type=default
      spawn-monsters=true
      max-tick-time=60000
      enforce-whitelist=false
      use-native-transport=true
      max-players=20
      resource-pack-sha1=
      spawn-protection=16
      online-mode=${!var.bungeecord}
      allow-flight=false
      max-world-size=29999984
      EOF
    "spigot.yml" = <<-EOF
      config-version: 12
      settings:
        debug: false
        save-user-cache-on-stop-only: false
        late-bind: false
        bungeecord: ${var.bungeecord}
        sample-count: 12
        player-shuffle: 0
        user-cache-size: 1000
        moved-wrongly-threshold: 0.0625
        moved-too-quickly-multiplier: 10.0
        timeout-time: 60
        restart-on-crash: true
        restart-script: ./start.sh
        netty-threads: 4
        attribute:
          maxHealth:
            max: 2048.0
          movementSpeed:
            max: 2048.0
          attackDamage:
            max: 2048.0
      messages:
        whitelist: You are not whitelisted on this server!
        unknown-command: Unknown command. Type "/help" for help.
        server-full: The server is full!
        outdated-client: Outdated client! Please use {0}
        outdated-server: Outdated server! I'm still on {0}
        restart: Server is restarting
      commands:
        log: true
        tab-complete: 0
        send-namespaced: true
        spam-exclusions:
        - /skill
        silent-commandblock-console: false
        replace-commands:
        - setblock
        - summon
        - testforblock
        - tellraw
      advancements:
        disable-saving: false
        disabled:
        - minecraft:story/disabled
      stats:
        disable-saving: false
        forced-stats: {}
      world-settings:
        default:
          verbose: true
          mob-spawn-range: 6
          hopper-amount: 1
          dragon-death-sound-radius: 0
          seed-village: 10387312
          seed-desert: 14357617
          seed-igloo: 14357618
          seed-jungle: 14357619
          seed-swamp: 14357620
          seed-monument: 10387313
          seed-shipwreck: 165745295
          seed-ocean: 14357621
          seed-outpost: 165745296
          seed-slime: 987234911
          max-tnt-per-tick: 100
          enable-zombie-pigmen-portal-spawns: true
          item-despawn-rate: 6000
          arrow-despawn-rate: 1200
          wither-spawn-sound-radius: 0
          hanging-tick-frequency: 100
          zombie-aggressive-towards-villager: true
          nerf-spawner-mobs: false
          merge-radius:
            exp: 3.0
            item: 2.5
          growth:
            cactus-modifier: 100
            cane-modifier: 100
            melon-modifier: 100
            mushroom-modifier: 100
            pumpkin-modifier: 100
            sapling-modifier: 100
            beetroot-modifier: 100
            carrot-modifier: 100
            potato-modifier: 100
            wheat-modifier: 100
            netherwart-modifier: 100
            vine-modifier: 100
            cocoa-modifier: 100
            bamboo-modifier: 100
            sweetberry-modifier: 100
            kelp-modifier: 100
          entity-activation-range:
            animals: 32
            monsters: 32
            raiders: 48
            misc: 16
            tick-inactive-villagers: true
          entity-tracking-range:
            players: 48
            animals: 48
            monsters: 48
            misc: 32
            other: 64
          ticks-per:
            hopper-transfer: 8
            hopper-check: 1
          hunger:
            jump-walk-exhaustion: 0.05
            jump-sprint-exhaustion: 0.2
            combat-exhaustion: 0.1
            regen-exhaustion: 6.0
            swim-multiplier: 0.01
            sprint-multiplier: 0.1
            other-multiplier: 0.0
          max-tick-time:
            tile: 50
            entity: 50
          squid-spawn-range:
            min: 45.0
      EOF
  }
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}