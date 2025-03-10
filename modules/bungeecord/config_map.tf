resource "k8s_core_v1_config_map" "this" {
  data = {
    "config.yml" = <<-EOF
      forge_support: false
      connection_throttle_limit: 3
      ip_forward: true
      timeout: 30000
      online_mode: true
      log_commands: false
      listeners:
      - query_port: 25565
        motd: '&1Another Bungee server'
        tab_list: GLOBAL_PING
        query_enabled: false
        proxy_protocol: false
        forced_hosts:
          pvp.md-5.net: pvp
        ping_passthrough: false
        priorities: ${jsonencode(var.priorities)}
        bind_local_address: true
        host: 0.0.0.0:25565
        max_players: 1
        tab_size: 60
        force_default_server: false
      connection_throttle: 4000
      groups:
        md_5:
        - admin
      log_pings: true
      player_limit: -1
      prevent_proxy_connections: false
      network_compression_threshold: 256
      disabled_commands:
      - disabledcommandhere
      stats: 46a515ae-eb48-4e90-88e7-7762e1507bbf
      permissions:
        default:
        - bungeecord.command.server
        - bungeecord.command.list
        admin:
        - bungeecord.command.alert
        - bungeecord.command.end
        - bungeecord.command.ip
        - bungeecord.command.reload
      servers: ${jsonencode(var.servers)}

      EOF
  }
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}