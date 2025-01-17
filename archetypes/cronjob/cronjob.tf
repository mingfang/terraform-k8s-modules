//GENERATE DYNAMIC//k8s_batch_v1_cron_job////
resource "k8s_batch_v1_cron_job" "this" {


  metadata {
    annotations = lookup(local.k8s_batch_v1_cron_job_parameters, "annotations", null)
    labels      = lookup(local.k8s_batch_v1_cron_job_parameters, "labels", null)
    name        = lookup(local.k8s_batch_v1_cron_job_parameters, "name", null)
    namespace   = lookup(local.k8s_batch_v1_cron_job_parameters, "namespace", null)
  }

  spec {
    concurrency_policy        = lookup(local.k8s_batch_v1_cron_job_parameters, "concurrency_policy", null)
    failed_jobs_history_limit = lookup(local.k8s_batch_v1_cron_job_parameters, "failed_jobs_history_limit", null)

    dynamic "job_template" {
      for_each = lookup(local.k8s_batch_v1_cron_job_parameters, "job_template", null) == null ? [] : [local.k8s_batch_v1_cron_job_parameters.job_template]
      content {

        metadata {
          annotations = lookup(job_template.value, "annotations", null)
          labels      = lookup(job_template.value, "labels", null)
          name        = lookup(job_template.value, "name", null)
          namespace   = lookup(job_template.value, "namespace", null)
        }

        spec {
          active_deadline_seconds = lookup(job_template.value, "active_deadline_seconds", null)
          backoff_limit           = lookup(job_template.value, "backoff_limit", null)
          backoff_limit_per_index = lookup(job_template.value, "backoff_limit_per_index", null)
          completion_mode         = lookup(job_template.value, "completion_mode", null)
          completions             = lookup(job_template.value, "completions", null)
          managed_by              = lookup(job_template.value, "managed_by", null)
          manual_selector         = lookup(job_template.value, "manual_selector", null)
          max_failed_indexes      = lookup(job_template.value, "max_failed_indexes", null)
          parallelism             = lookup(job_template.value, "parallelism", null)

          dynamic "pod_failure_policy" {
            for_each = lookup(job_template.value, "pod_failure_policy", null) == null ? [] : [job_template.value.pod_failure_policy]
            content {
              dynamic "rules" {
                for_each = lookup(pod_failure_policy.value, "rules", [])
                content {
                  action = rules.value.action
                  dynamic "onexit_codes" {
                    for_each = lookup(rules.value, "onexit_codes", null) == null ? [] : [rules.value.onexit_codes]
                    content {
                      container_name = lookup(onexit_codes.value, "container_name", null)
                      operator       = onexit_codes.value.operator
                      values         = onexit_codes.value.values
                    }
                  }
                  dynamic "onpod_conditions" {
                    for_each = lookup(rules.value, "onpod_conditions", [])
                    content {
                      status = onpod_conditions.value.status
                      type   = onpod_conditions.value.type
                    }
                  }
                }
              }
            }
          }
          pod_replacement_policy = lookup(job_template.value, "pod_replacement_policy", null)

          dynamic "selector" {
            for_each = lookup(job_template.value, "selector", null) == null ? [] : [job_template.value.selector]
            content {
              dynamic "match_expressions" {
                for_each = lookup(selector.value, "match_expressions", [])
                content {
                  key      = match_expressions.value.key
                  operator = match_expressions.value.operator
                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                }
              }
              match_labels = lookup(selector.value, "match_labels", null)
            }
          }

          dynamic "success_policy" {
            for_each = lookup(job_template.value, "success_policy", null) == null ? [] : [job_template.value.success_policy]
            content {
              dynamic "rules" {
                for_each = lookup(success_policy.value, "rules", [])
                content {
                  succeeded_count   = lookup(rules.value, "succeeded_count", null)
                  succeeded_indexes = lookup(rules.value, "succeeded_indexes", null)
                }
              }
            }
          }
          suspend = lookup(job_template.value, "suspend", null)

          template {

            metadata {
              annotations = lookup(job_template.value, "annotations", null)
              labels      = lookup(job_template.value, "labels", null)
              name        = lookup(job_template.value, "name", null)
              namespace   = lookup(job_template.value, "namespace", null)
            }

            spec {
              active_deadline_seconds = lookup(job_template.value, "active_deadline_seconds", null)

              dynamic "affinity" {
                for_each = lookup(job_template.value, "affinity", null) == null ? [] : [job_template.value.affinity]
                content {
                  dynamic "node_affinity" {
                    for_each = lookup(affinity.value, "node_affinity", null) == null ? [] : [affinity.value.node_affinity]
                    content {
                      dynamic "preferred_during_scheduling_ignored_during_execution" {
                        for_each = lookup(node_affinity.value, "preferred_during_scheduling_ignored_during_execution", [])
                        content {
                          dynamic "preference" {
                            for_each = lookup(preferred_during_scheduling_ignored_during_execution.value, "preference", null) == null ? [] : [preferred_during_scheduling_ignored_during_execution.value.preference]
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(preference.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              dynamic "match_fields" {
                                for_each = lookup(preference.value, "match_fields", [])
                                content {
                                  key      = match_fields.value.key
                                  operator = match_fields.value.operator
                                  values   = contains(keys(match_fields.value), "values") ? tolist(match_fields.value.values) : null
                                }
                              }
                            }
                          }
                          weight = preferred_during_scheduling_ignored_during_execution.value.weight
                        }
                      }
                      dynamic "required_during_scheduling_ignored_during_execution" {
                        for_each = lookup(node_affinity.value, "required_during_scheduling_ignored_during_execution", null) == null ? [] : [node_affinity.value.required_during_scheduling_ignored_during_execution]
                        content {
                          dynamic "node_selector_terms" {
                            for_each = lookup(required_during_scheduling_ignored_during_execution.value, "node_selector_terms", [])
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(node_selector_terms.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              dynamic "match_fields" {
                                for_each = lookup(node_selector_terms.value, "match_fields", [])
                                content {
                                  key      = match_fields.value.key
                                  operator = match_fields.value.operator
                                  values   = contains(keys(match_fields.value), "values") ? tolist(match_fields.value.values) : null
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "pod_affinity" {
                    for_each = lookup(affinity.value, "pod_affinity", null) == null ? [] : [affinity.value.pod_affinity]
                    content {
                      dynamic "preferred_during_scheduling_ignored_during_execution" {
                        for_each = lookup(pod_affinity.value, "preferred_during_scheduling_ignored_during_execution", [])
                        content {
                          dynamic "pod_affinity_term" {
                            for_each = lookup(preferred_during_scheduling_ignored_during_execution.value, "pod_affinity_term", null) == null ? [] : [preferred_during_scheduling_ignored_during_execution.value.pod_affinity_term]
                            content {
                              dynamic "label_selector" {
                                for_each = lookup(pod_affinity_term.value, "label_selector", null) == null ? [] : [pod_affinity_term.value.label_selector]
                                content {
                                  dynamic "match_expressions" {
                                    for_each = lookup(label_selector.value, "match_expressions", [])
                                    content {
                                      key      = match_expressions.value.key
                                      operator = match_expressions.value.operator
                                      values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                    }
                                  }
                                  match_labels = lookup(label_selector.value, "match_labels", null)
                                }
                              }
                              match_label_keys    = contains(keys(pod_affinity_term.value), "match_label_keys") ? tolist(pod_affinity_term.value.match_label_keys) : null
                              mismatch_label_keys = contains(keys(pod_affinity_term.value), "mismatch_label_keys") ? tolist(pod_affinity_term.value.mismatch_label_keys) : null
                              dynamic "namespace_selector" {
                                for_each = lookup(pod_affinity_term.value, "namespace_selector", null) == null ? [] : [pod_affinity_term.value.namespace_selector]
                                content {
                                  dynamic "match_expressions" {
                                    for_each = lookup(namespace_selector.value, "match_expressions", [])
                                    content {
                                      key      = match_expressions.value.key
                                      operator = match_expressions.value.operator
                                      values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                    }
                                  }
                                  match_labels = lookup(namespace_selector.value, "match_labels", null)
                                }
                              }
                              namespaces   = contains(keys(pod_affinity_term.value), "namespaces") ? tolist(pod_affinity_term.value.namespaces) : null
                              topology_key = pod_affinity_term.value.topology_key
                            }
                          }
                          weight = preferred_during_scheduling_ignored_during_execution.value.weight
                        }
                      }
                      dynamic "required_during_scheduling_ignored_during_execution" {
                        for_each = lookup(pod_affinity.value, "required_during_scheduling_ignored_during_execution", [])
                        content {
                          dynamic "label_selector" {
                            for_each = lookup(required_during_scheduling_ignored_during_execution.value, "label_selector", null) == null ? [] : [required_during_scheduling_ignored_during_execution.value.label_selector]
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(label_selector.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              match_labels = lookup(label_selector.value, "match_labels", null)
                            }
                          }
                          match_label_keys    = contains(keys(required_during_scheduling_ignored_during_execution.value), "match_label_keys") ? tolist(required_during_scheduling_ignored_during_execution.value.match_label_keys) : null
                          mismatch_label_keys = contains(keys(required_during_scheduling_ignored_during_execution.value), "mismatch_label_keys") ? tolist(required_during_scheduling_ignored_during_execution.value.mismatch_label_keys) : null
                          dynamic "namespace_selector" {
                            for_each = lookup(required_during_scheduling_ignored_during_execution.value, "namespace_selector", null) == null ? [] : [required_during_scheduling_ignored_during_execution.value.namespace_selector]
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(namespace_selector.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              match_labels = lookup(namespace_selector.value, "match_labels", null)
                            }
                          }
                          namespaces   = contains(keys(required_during_scheduling_ignored_during_execution.value), "namespaces") ? tolist(required_during_scheduling_ignored_during_execution.value.namespaces) : null
                          topology_key = required_during_scheduling_ignored_during_execution.value.topology_key
                        }
                      }
                    }
                  }
                  dynamic "pod_anti_affinity" {
                    for_each = lookup(affinity.value, "pod_anti_affinity", null) == null ? [] : [affinity.value.pod_anti_affinity]
                    content {
                      dynamic "preferred_during_scheduling_ignored_during_execution" {
                        for_each = lookup(pod_anti_affinity.value, "preferred_during_scheduling_ignored_during_execution", [])
                        content {
                          dynamic "pod_affinity_term" {
                            for_each = lookup(preferred_during_scheduling_ignored_during_execution.value, "pod_affinity_term", null) == null ? [] : [preferred_during_scheduling_ignored_during_execution.value.pod_affinity_term]
                            content {
                              dynamic "label_selector" {
                                for_each = lookup(pod_affinity_term.value, "label_selector", null) == null ? [] : [pod_affinity_term.value.label_selector]
                                content {
                                  dynamic "match_expressions" {
                                    for_each = lookup(label_selector.value, "match_expressions", [])
                                    content {
                                      key      = match_expressions.value.key
                                      operator = match_expressions.value.operator
                                      values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                    }
                                  }
                                  match_labels = lookup(label_selector.value, "match_labels", null)
                                }
                              }
                              match_label_keys    = contains(keys(pod_affinity_term.value), "match_label_keys") ? tolist(pod_affinity_term.value.match_label_keys) : null
                              mismatch_label_keys = contains(keys(pod_affinity_term.value), "mismatch_label_keys") ? tolist(pod_affinity_term.value.mismatch_label_keys) : null
                              dynamic "namespace_selector" {
                                for_each = lookup(pod_affinity_term.value, "namespace_selector", null) == null ? [] : [pod_affinity_term.value.namespace_selector]
                                content {
                                  dynamic "match_expressions" {
                                    for_each = lookup(namespace_selector.value, "match_expressions", [])
                                    content {
                                      key      = match_expressions.value.key
                                      operator = match_expressions.value.operator
                                      values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                    }
                                  }
                                  match_labels = lookup(namespace_selector.value, "match_labels", null)
                                }
                              }
                              namespaces   = contains(keys(pod_affinity_term.value), "namespaces") ? tolist(pod_affinity_term.value.namespaces) : null
                              topology_key = pod_affinity_term.value.topology_key
                            }
                          }
                          weight = preferred_during_scheduling_ignored_during_execution.value.weight
                        }
                      }
                      dynamic "required_during_scheduling_ignored_during_execution" {
                        for_each = lookup(pod_anti_affinity.value, "required_during_scheduling_ignored_during_execution", [])
                        content {
                          dynamic "label_selector" {
                            for_each = lookup(required_during_scheduling_ignored_during_execution.value, "label_selector", null) == null ? [] : [required_during_scheduling_ignored_during_execution.value.label_selector]
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(label_selector.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              match_labels = lookup(label_selector.value, "match_labels", null)
                            }
                          }
                          match_label_keys    = contains(keys(required_during_scheduling_ignored_during_execution.value), "match_label_keys") ? tolist(required_during_scheduling_ignored_during_execution.value.match_label_keys) : null
                          mismatch_label_keys = contains(keys(required_during_scheduling_ignored_during_execution.value), "mismatch_label_keys") ? tolist(required_during_scheduling_ignored_during_execution.value.mismatch_label_keys) : null
                          dynamic "namespace_selector" {
                            for_each = lookup(required_during_scheduling_ignored_during_execution.value, "namespace_selector", null) == null ? [] : [required_during_scheduling_ignored_during_execution.value.namespace_selector]
                            content {
                              dynamic "match_expressions" {
                                for_each = lookup(namespace_selector.value, "match_expressions", [])
                                content {
                                  key      = match_expressions.value.key
                                  operator = match_expressions.value.operator
                                  values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                }
                              }
                              match_labels = lookup(namespace_selector.value, "match_labels", null)
                            }
                          }
                          namespaces   = contains(keys(required_during_scheduling_ignored_during_execution.value), "namespaces") ? tolist(required_during_scheduling_ignored_during_execution.value.namespaces) : null
                          topology_key = required_during_scheduling_ignored_during_execution.value.topology_key
                        }
                      }
                    }
                  }
                }
              }
              automount_service_account_token = lookup(job_template.value, "automount_service_account_token", null)

              dynamic "containers" {
                for_each = lookup(job_template.value, "containers", [])
                content {
                  args    = contains(keys(containers.value), "args") ? tolist(containers.value.args) : null
                  command = contains(keys(containers.value), "command") ? tolist(containers.value.command) : null
                  dynamic "env" {
                    for_each = lookup(containers.value, "env", [])
                    content {
                      name  = env.value.name
                      value = lookup(env.value, "value", null)
                      dynamic "value_from" {
                        for_each = lookup(env.value, "value_from", null) == null ? [] : [env.value.value_from]
                        content {
                          dynamic "config_map_keyref" {
                            for_each = lookup(value_from.value, "config_map_keyref", null) == null ? [] : [value_from.value.config_map_keyref]
                            content {
                              key      = config_map_keyref.value.key
                              name     = lookup(config_map_keyref.value, "name", null)
                              optional = lookup(config_map_keyref.value, "optional", null)
                            }
                          }
                          dynamic "field_ref" {
                            for_each = lookup(value_from.value, "field_ref", null) == null ? [] : [value_from.value.field_ref]
                            content {
                              api_version = lookup(field_ref.value, "api_version", null)
                              field_path  = field_ref.value.field_path
                            }
                          }
                          dynamic "resource_field_ref" {
                            for_each = lookup(value_from.value, "resource_field_ref", null) == null ? [] : [value_from.value.resource_field_ref]
                            content {
                              container_name = lookup(resource_field_ref.value, "container_name", null)
                              divisor        = lookup(resource_field_ref.value, "divisor", null)
                              resource       = resource_field_ref.value.resource
                            }
                          }
                          dynamic "secret_key_ref" {
                            for_each = lookup(value_from.value, "secret_key_ref", null) == null ? [] : [value_from.value.secret_key_ref]
                            content {
                              key      = secret_key_ref.value.key
                              name     = lookup(secret_key_ref.value, "name", null)
                              optional = lookup(secret_key_ref.value, "optional", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "env_from" {
                    for_each = lookup(containers.value, "env_from", [])
                    content {
                      dynamic "config_map_ref" {
                        for_each = lookup(env_from.value, "config_map_ref", null) == null ? [] : [env_from.value.config_map_ref]
                        content {
                          name     = lookup(config_map_ref.value, "name", null)
                          optional = lookup(config_map_ref.value, "optional", null)
                        }
                      }
                      prefix = lookup(env_from.value, "prefix", null)
                      dynamic "secret_ref" {
                        for_each = lookup(env_from.value, "secret_ref", null) == null ? [] : [env_from.value.secret_ref]
                        content {
                          name     = lookup(secret_ref.value, "name", null)
                          optional = lookup(secret_ref.value, "optional", null)
                        }
                      }
                    }
                  }
                  image             = lookup(containers.value, "image", null)
                  image_pull_policy = lookup(containers.value, "image_pull_policy", null)
                  dynamic "lifecycle" {
                    for_each = lookup(containers.value, "lifecycle", null) == null ? [] : [containers.value.lifecycle]
                    content {
                      dynamic "post_start" {
                        for_each = lookup(lifecycle.value, "post_start", null) == null ? [] : [lifecycle.value.post_start]
                        content {
                          dynamic "exec" {
                            for_each = lookup(post_start.value, "exec", null) == null ? [] : [post_start.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(post_start.value, "http_get", null) == null ? [] : [post_start.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(post_start.value, "sleep", null) == null ? [] : [post_start.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(post_start.value, "tcp_socket", null) == null ? [] : [post_start.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                      dynamic "pre_stop" {
                        for_each = lookup(lifecycle.value, "pre_stop", null) == null ? [] : [lifecycle.value.pre_stop]
                        content {
                          dynamic "exec" {
                            for_each = lookup(pre_stop.value, "exec", null) == null ? [] : [pre_stop.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(pre_stop.value, "http_get", null) == null ? [] : [pre_stop.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(pre_stop.value, "sleep", null) == null ? [] : [pre_stop.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(pre_stop.value, "tcp_socket", null) == null ? [] : [pre_stop.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "liveness_probe" {
                    for_each = lookup(containers.value, "liveness_probe", null) == null ? [] : [containers.value.liveness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(liveness_probe.value, "exec", null) == null ? [] : [liveness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(liveness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(liveness_probe.value, "grpc", null) == null ? [] : [liveness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(liveness_probe.value, "http_get", null) == null ? [] : [liveness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(liveness_probe.value, "tcp_socket", null) == null ? [] : [liveness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(liveness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(liveness_probe.value, "timeout_seconds", null)
                    }
                  }
                  name = containers.value.name
                  dynamic "ports" {
                    for_each = lookup(containers.value, "ports", [])
                    content {
                      container_port = ports.value.container_port
                      host_ip        = lookup(ports.value, "host_ip", null)
                      host_port      = lookup(ports.value, "host_port", null)
                      name           = lookup(ports.value, "name", null)
                      protocol       = lookup(ports.value, "protocol", null)
                    }
                  }
                  dynamic "readiness_probe" {
                    for_each = lookup(containers.value, "readiness_probe", null) == null ? [] : [containers.value.readiness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(readiness_probe.value, "exec", null) == null ? [] : [readiness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(readiness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(readiness_probe.value, "grpc", null) == null ? [] : [readiness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(readiness_probe.value, "http_get", null) == null ? [] : [readiness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(readiness_probe.value, "tcp_socket", null) == null ? [] : [readiness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(readiness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(readiness_probe.value, "timeout_seconds", null)
                    }
                  }
                  dynamic "resize_policy" {
                    for_each = lookup(containers.value, "resize_policy", [])
                    content {
                      resource_name  = resize_policy.value.resource_name
                      restart_policy = resize_policy.value.restart_policy
                    }
                  }
                  dynamic "resources" {
                    for_each = lookup(containers.value, "resources", null) == null ? [] : [containers.value.resources]
                    content {
                      dynamic "claims" {
                        for_each = lookup(resources.value, "claims", [])
                        content {
                          name = claims.value.name
                        }
                      }
                      limits   = lookup(resources.value, "limits", null)
                      requests = lookup(resources.value, "requests", null)
                    }
                  }
                  restart_policy = lookup(containers.value, "restart_policy", null)
                  dynamic "security_context" {
                    for_each = lookup(containers.value, "security_context", null) == null ? [] : [containers.value.security_context]
                    content {
                      allow_privilege_escalation = lookup(security_context.value, "allow_privilege_escalation", null)
                      dynamic "app_armor_profile" {
                        for_each = lookup(security_context.value, "app_armor_profile", null) == null ? [] : [security_context.value.app_armor_profile]
                        content {
                          localhost_profile = lookup(app_armor_profile.value, "localhost_profile", null)
                          type              = app_armor_profile.value.type
                        }
                      }
                      dynamic "capabilities" {
                        for_each = lookup(security_context.value, "capabilities", null) == null ? [] : [security_context.value.capabilities]
                        content {
                          add  = contains(keys(capabilities.value), "add") ? tolist(capabilities.value.add) : null
                          drop = contains(keys(capabilities.value), "drop") ? tolist(capabilities.value.drop) : null
                        }
                      }
                      privileged                = lookup(security_context.value, "privileged", null)
                      proc_mount                = lookup(security_context.value, "proc_mount", null)
                      read_only_root_filesystem = lookup(security_context.value, "read_only_root_filesystem", null)
                      run_asgroup               = lookup(security_context.value, "run_asgroup", null)
                      run_asnon_root            = lookup(security_context.value, "run_asnon_root", null)
                      run_asuser                = lookup(security_context.value, "run_asuser", null)
                      dynamic "seccomp_profile" {
                        for_each = lookup(security_context.value, "seccomp_profile", null) == null ? [] : [security_context.value.seccomp_profile]
                        content {
                          localhost_profile = lookup(seccomp_profile.value, "localhost_profile", null)
                          type              = seccomp_profile.value.type
                        }
                      }
                      dynamic "selinux_options" {
                        for_each = lookup(security_context.value, "selinux_options", null) == null ? [] : [security_context.value.selinux_options]
                        content {
                          level = lookup(selinux_options.value, "level", null)
                          role  = lookup(selinux_options.value, "role", null)
                          type  = lookup(selinux_options.value, "type", null)
                          user  = lookup(selinux_options.value, "user", null)
                        }
                      }
                      dynamic "windows_options" {
                        for_each = lookup(security_context.value, "windows_options", null) == null ? [] : [security_context.value.windows_options]
                        content {
                          gmsa_credential_spec      = lookup(windows_options.value, "gmsa_credential_spec", null)
                          gmsa_credential_spec_name = lookup(windows_options.value, "gmsa_credential_spec_name", null)
                          host_process              = lookup(windows_options.value, "host_process", null)
                          run_asuser_name           = lookup(windows_options.value, "run_asuser_name", null)
                        }
                      }
                    }
                  }
                  dynamic "startup_probe" {
                    for_each = lookup(containers.value, "startup_probe", null) == null ? [] : [containers.value.startup_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(startup_probe.value, "exec", null) == null ? [] : [startup_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(startup_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(startup_probe.value, "grpc", null) == null ? [] : [startup_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(startup_probe.value, "http_get", null) == null ? [] : [startup_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(startup_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(startup_probe.value, "period_seconds", null)
                      success_threshold     = lookup(startup_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(startup_probe.value, "tcp_socket", null) == null ? [] : [startup_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(startup_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(startup_probe.value, "timeout_seconds", null)
                    }
                  }
                  stdin                      = lookup(containers.value, "stdin", null)
                  stdin_once                 = lookup(containers.value, "stdin_once", null)
                  termination_message_path   = lookup(containers.value, "termination_message_path", null)
                  termination_message_policy = lookup(containers.value, "termination_message_policy", null)
                  tty                        = lookup(containers.value, "tty", null)
                  dynamic "volume_devices" {
                    for_each = lookup(containers.value, "volume_devices", [])
                    content {
                      device_path = volume_devices.value.device_path
                      name        = volume_devices.value.name
                    }
                  }
                  dynamic "volume_mounts" {
                    for_each = lookup(containers.value, "volume_mounts", [])
                    content {
                      mount_path          = volume_mounts.value.mount_path
                      mount_propagation   = lookup(volume_mounts.value, "mount_propagation", null)
                      name                = volume_mounts.value.name
                      read_only           = lookup(volume_mounts.value, "read_only", null)
                      recursive_read_only = lookup(volume_mounts.value, "recursive_read_only", null)
                      sub_path            = lookup(volume_mounts.value, "sub_path", null)
                      sub_path_expr       = lookup(volume_mounts.value, "sub_path_expr", null)
                    }
                  }
                  working_dir = lookup(containers.value, "working_dir", null)
                }
              }

              dynamic "dns_config" {
                for_each = lookup(job_template.value, "dns_config", null) == null ? [] : [job_template.value.dns_config]
                content {
                  nameservers = contains(keys(dns_config.value), "nameservers") ? tolist(dns_config.value.nameservers) : null
                  dynamic "options" {
                    for_each = lookup(dns_config.value, "options", [])
                    content {
                      name  = lookup(options.value, "name", null)
                      value = lookup(options.value, "value", null)
                    }
                  }
                  searches = contains(keys(dns_config.value), "searches") ? tolist(dns_config.value.searches) : null
                }
              }
              dns_policy           = lookup(job_template.value, "dns_policy", null)
              enable_service_links = lookup(job_template.value, "enable_service_links", null)

              dynamic "ephemeral_containers" {
                for_each = lookup(job_template.value, "ephemeral_containers", [])
                content {
                  args    = contains(keys(ephemeral_containers.value), "args") ? tolist(ephemeral_containers.value.args) : null
                  command = contains(keys(ephemeral_containers.value), "command") ? tolist(ephemeral_containers.value.command) : null
                  dynamic "env" {
                    for_each = lookup(ephemeral_containers.value, "env", [])
                    content {
                      name  = env.value.name
                      value = lookup(env.value, "value", null)
                      dynamic "value_from" {
                        for_each = lookup(env.value, "value_from", null) == null ? [] : [env.value.value_from]
                        content {
                          dynamic "config_map_keyref" {
                            for_each = lookup(value_from.value, "config_map_keyref", null) == null ? [] : [value_from.value.config_map_keyref]
                            content {
                              key      = config_map_keyref.value.key
                              name     = lookup(config_map_keyref.value, "name", null)
                              optional = lookup(config_map_keyref.value, "optional", null)
                            }
                          }
                          dynamic "field_ref" {
                            for_each = lookup(value_from.value, "field_ref", null) == null ? [] : [value_from.value.field_ref]
                            content {
                              api_version = lookup(field_ref.value, "api_version", null)
                              field_path  = field_ref.value.field_path
                            }
                          }
                          dynamic "resource_field_ref" {
                            for_each = lookup(value_from.value, "resource_field_ref", null) == null ? [] : [value_from.value.resource_field_ref]
                            content {
                              container_name = lookup(resource_field_ref.value, "container_name", null)
                              divisor        = lookup(resource_field_ref.value, "divisor", null)
                              resource       = resource_field_ref.value.resource
                            }
                          }
                          dynamic "secret_key_ref" {
                            for_each = lookup(value_from.value, "secret_key_ref", null) == null ? [] : [value_from.value.secret_key_ref]
                            content {
                              key      = secret_key_ref.value.key
                              name     = lookup(secret_key_ref.value, "name", null)
                              optional = lookup(secret_key_ref.value, "optional", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "env_from" {
                    for_each = lookup(ephemeral_containers.value, "env_from", [])
                    content {
                      dynamic "config_map_ref" {
                        for_each = lookup(env_from.value, "config_map_ref", null) == null ? [] : [env_from.value.config_map_ref]
                        content {
                          name     = lookup(config_map_ref.value, "name", null)
                          optional = lookup(config_map_ref.value, "optional", null)
                        }
                      }
                      prefix = lookup(env_from.value, "prefix", null)
                      dynamic "secret_ref" {
                        for_each = lookup(env_from.value, "secret_ref", null) == null ? [] : [env_from.value.secret_ref]
                        content {
                          name     = lookup(secret_ref.value, "name", null)
                          optional = lookup(secret_ref.value, "optional", null)
                        }
                      }
                    }
                  }
                  image             = lookup(ephemeral_containers.value, "image", null)
                  image_pull_policy = lookup(ephemeral_containers.value, "image_pull_policy", null)
                  dynamic "lifecycle" {
                    for_each = lookup(ephemeral_containers.value, "lifecycle", null) == null ? [] : [ephemeral_containers.value.lifecycle]
                    content {
                      dynamic "post_start" {
                        for_each = lookup(lifecycle.value, "post_start", null) == null ? [] : [lifecycle.value.post_start]
                        content {
                          dynamic "exec" {
                            for_each = lookup(post_start.value, "exec", null) == null ? [] : [post_start.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(post_start.value, "http_get", null) == null ? [] : [post_start.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(post_start.value, "sleep", null) == null ? [] : [post_start.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(post_start.value, "tcp_socket", null) == null ? [] : [post_start.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                      dynamic "pre_stop" {
                        for_each = lookup(lifecycle.value, "pre_stop", null) == null ? [] : [lifecycle.value.pre_stop]
                        content {
                          dynamic "exec" {
                            for_each = lookup(pre_stop.value, "exec", null) == null ? [] : [pre_stop.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(pre_stop.value, "http_get", null) == null ? [] : [pre_stop.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(pre_stop.value, "sleep", null) == null ? [] : [pre_stop.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(pre_stop.value, "tcp_socket", null) == null ? [] : [pre_stop.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "liveness_probe" {
                    for_each = lookup(ephemeral_containers.value, "liveness_probe", null) == null ? [] : [ephemeral_containers.value.liveness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(liveness_probe.value, "exec", null) == null ? [] : [liveness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(liveness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(liveness_probe.value, "grpc", null) == null ? [] : [liveness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(liveness_probe.value, "http_get", null) == null ? [] : [liveness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(liveness_probe.value, "tcp_socket", null) == null ? [] : [liveness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(liveness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(liveness_probe.value, "timeout_seconds", null)
                    }
                  }
                  name = ephemeral_containers.value.name
                  dynamic "ports" {
                    for_each = lookup(ephemeral_containers.value, "ports", [])
                    content {
                      container_port = ports.value.container_port
                      host_ip        = lookup(ports.value, "host_ip", null)
                      host_port      = lookup(ports.value, "host_port", null)
                      name           = lookup(ports.value, "name", null)
                      protocol       = lookup(ports.value, "protocol", null)
                    }
                  }
                  dynamic "readiness_probe" {
                    for_each = lookup(ephemeral_containers.value, "readiness_probe", null) == null ? [] : [ephemeral_containers.value.readiness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(readiness_probe.value, "exec", null) == null ? [] : [readiness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(readiness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(readiness_probe.value, "grpc", null) == null ? [] : [readiness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(readiness_probe.value, "http_get", null) == null ? [] : [readiness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(readiness_probe.value, "tcp_socket", null) == null ? [] : [readiness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(readiness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(readiness_probe.value, "timeout_seconds", null)
                    }
                  }
                  dynamic "resize_policy" {
                    for_each = lookup(ephemeral_containers.value, "resize_policy", [])
                    content {
                      resource_name  = resize_policy.value.resource_name
                      restart_policy = resize_policy.value.restart_policy
                    }
                  }
                  dynamic "resources" {
                    for_each = lookup(ephemeral_containers.value, "resources", null) == null ? [] : [ephemeral_containers.value.resources]
                    content {
                      dynamic "claims" {
                        for_each = lookup(resources.value, "claims", [])
                        content {
                          name = claims.value.name
                        }
                      }
                      limits   = lookup(resources.value, "limits", null)
                      requests = lookup(resources.value, "requests", null)
                    }
                  }
                  restart_policy = lookup(ephemeral_containers.value, "restart_policy", null)
                  dynamic "security_context" {
                    for_each = lookup(ephemeral_containers.value, "security_context", null) == null ? [] : [ephemeral_containers.value.security_context]
                    content {
                      allow_privilege_escalation = lookup(security_context.value, "allow_privilege_escalation", null)
                      dynamic "app_armor_profile" {
                        for_each = lookup(security_context.value, "app_armor_profile", null) == null ? [] : [security_context.value.app_armor_profile]
                        content {
                          localhost_profile = lookup(app_armor_profile.value, "localhost_profile", null)
                          type              = app_armor_profile.value.type
                        }
                      }
                      dynamic "capabilities" {
                        for_each = lookup(security_context.value, "capabilities", null) == null ? [] : [security_context.value.capabilities]
                        content {
                          add  = contains(keys(capabilities.value), "add") ? tolist(capabilities.value.add) : null
                          drop = contains(keys(capabilities.value), "drop") ? tolist(capabilities.value.drop) : null
                        }
                      }
                      privileged                = lookup(security_context.value, "privileged", null)
                      proc_mount                = lookup(security_context.value, "proc_mount", null)
                      read_only_root_filesystem = lookup(security_context.value, "read_only_root_filesystem", null)
                      run_asgroup               = lookup(security_context.value, "run_asgroup", null)
                      run_asnon_root            = lookup(security_context.value, "run_asnon_root", null)
                      run_asuser                = lookup(security_context.value, "run_asuser", null)
                      dynamic "seccomp_profile" {
                        for_each = lookup(security_context.value, "seccomp_profile", null) == null ? [] : [security_context.value.seccomp_profile]
                        content {
                          localhost_profile = lookup(seccomp_profile.value, "localhost_profile", null)
                          type              = seccomp_profile.value.type
                        }
                      }
                      dynamic "selinux_options" {
                        for_each = lookup(security_context.value, "selinux_options", null) == null ? [] : [security_context.value.selinux_options]
                        content {
                          level = lookup(selinux_options.value, "level", null)
                          role  = lookup(selinux_options.value, "role", null)
                          type  = lookup(selinux_options.value, "type", null)
                          user  = lookup(selinux_options.value, "user", null)
                        }
                      }
                      dynamic "windows_options" {
                        for_each = lookup(security_context.value, "windows_options", null) == null ? [] : [security_context.value.windows_options]
                        content {
                          gmsa_credential_spec      = lookup(windows_options.value, "gmsa_credential_spec", null)
                          gmsa_credential_spec_name = lookup(windows_options.value, "gmsa_credential_spec_name", null)
                          host_process              = lookup(windows_options.value, "host_process", null)
                          run_asuser_name           = lookup(windows_options.value, "run_asuser_name", null)
                        }
                      }
                    }
                  }
                  dynamic "startup_probe" {
                    for_each = lookup(ephemeral_containers.value, "startup_probe", null) == null ? [] : [ephemeral_containers.value.startup_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(startup_probe.value, "exec", null) == null ? [] : [startup_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(startup_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(startup_probe.value, "grpc", null) == null ? [] : [startup_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(startup_probe.value, "http_get", null) == null ? [] : [startup_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(startup_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(startup_probe.value, "period_seconds", null)
                      success_threshold     = lookup(startup_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(startup_probe.value, "tcp_socket", null) == null ? [] : [startup_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(startup_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(startup_probe.value, "timeout_seconds", null)
                    }
                  }
                  stdin                      = lookup(ephemeral_containers.value, "stdin", null)
                  stdin_once                 = lookup(ephemeral_containers.value, "stdin_once", null)
                  target_container_name      = lookup(ephemeral_containers.value, "target_container_name", null)
                  termination_message_path   = lookup(ephemeral_containers.value, "termination_message_path", null)
                  termination_message_policy = lookup(ephemeral_containers.value, "termination_message_policy", null)
                  tty                        = lookup(ephemeral_containers.value, "tty", null)
                  dynamic "volume_devices" {
                    for_each = lookup(ephemeral_containers.value, "volume_devices", [])
                    content {
                      device_path = volume_devices.value.device_path
                      name        = volume_devices.value.name
                    }
                  }
                  dynamic "volume_mounts" {
                    for_each = lookup(ephemeral_containers.value, "volume_mounts", [])
                    content {
                      mount_path          = volume_mounts.value.mount_path
                      mount_propagation   = lookup(volume_mounts.value, "mount_propagation", null)
                      name                = volume_mounts.value.name
                      read_only           = lookup(volume_mounts.value, "read_only", null)
                      recursive_read_only = lookup(volume_mounts.value, "recursive_read_only", null)
                      sub_path            = lookup(volume_mounts.value, "sub_path", null)
                      sub_path_expr       = lookup(volume_mounts.value, "sub_path_expr", null)
                    }
                  }
                  working_dir = lookup(ephemeral_containers.value, "working_dir", null)
                }
              }

              dynamic "host_aliases" {
                for_each = lookup(job_template.value, "host_aliases", [])
                content {
                  hostnames = contains(keys(host_aliases.value), "hostnames") ? tolist(host_aliases.value.hostnames) : null
                  ip        = lookup(host_aliases.value, "ip", null)
                }
              }
              host_ipc     = lookup(job_template.value, "host_ipc", null)
              host_network = lookup(job_template.value, "host_network", null)
              host_pid     = lookup(job_template.value, "host_pid", null)
              host_users   = lookup(job_template.value, "host_users", null)
              hostname     = lookup(job_template.value, "hostname", null)

              dynamic "image_pull_secrets" {
                for_each = lookup(job_template.value, "image_pull_secrets", [])
                content {
                  name = lookup(image_pull_secrets.value, "name", null)
                }
              }

              dynamic "init_containers" {
                for_each = lookup(job_template.value, "init_containers", [])
                content {
                  args    = contains(keys(init_containers.value), "args") ? tolist(init_containers.value.args) : null
                  command = contains(keys(init_containers.value), "command") ? tolist(init_containers.value.command) : null
                  dynamic "env" {
                    for_each = lookup(init_containers.value, "env", [])
                    content {
                      name  = env.value.name
                      value = lookup(env.value, "value", null)
                      dynamic "value_from" {
                        for_each = lookup(env.value, "value_from", null) == null ? [] : [env.value.value_from]
                        content {
                          dynamic "config_map_keyref" {
                            for_each = lookup(value_from.value, "config_map_keyref", null) == null ? [] : [value_from.value.config_map_keyref]
                            content {
                              key      = config_map_keyref.value.key
                              name     = lookup(config_map_keyref.value, "name", null)
                              optional = lookup(config_map_keyref.value, "optional", null)
                            }
                          }
                          dynamic "field_ref" {
                            for_each = lookup(value_from.value, "field_ref", null) == null ? [] : [value_from.value.field_ref]
                            content {
                              api_version = lookup(field_ref.value, "api_version", null)
                              field_path  = field_ref.value.field_path
                            }
                          }
                          dynamic "resource_field_ref" {
                            for_each = lookup(value_from.value, "resource_field_ref", null) == null ? [] : [value_from.value.resource_field_ref]
                            content {
                              container_name = lookup(resource_field_ref.value, "container_name", null)
                              divisor        = lookup(resource_field_ref.value, "divisor", null)
                              resource       = resource_field_ref.value.resource
                            }
                          }
                          dynamic "secret_key_ref" {
                            for_each = lookup(value_from.value, "secret_key_ref", null) == null ? [] : [value_from.value.secret_key_ref]
                            content {
                              key      = secret_key_ref.value.key
                              name     = lookup(secret_key_ref.value, "name", null)
                              optional = lookup(secret_key_ref.value, "optional", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "env_from" {
                    for_each = lookup(init_containers.value, "env_from", [])
                    content {
                      dynamic "config_map_ref" {
                        for_each = lookup(env_from.value, "config_map_ref", null) == null ? [] : [env_from.value.config_map_ref]
                        content {
                          name     = lookup(config_map_ref.value, "name", null)
                          optional = lookup(config_map_ref.value, "optional", null)
                        }
                      }
                      prefix = lookup(env_from.value, "prefix", null)
                      dynamic "secret_ref" {
                        for_each = lookup(env_from.value, "secret_ref", null) == null ? [] : [env_from.value.secret_ref]
                        content {
                          name     = lookup(secret_ref.value, "name", null)
                          optional = lookup(secret_ref.value, "optional", null)
                        }
                      }
                    }
                  }
                  image             = lookup(init_containers.value, "image", null)
                  image_pull_policy = lookup(init_containers.value, "image_pull_policy", null)
                  dynamic "lifecycle" {
                    for_each = lookup(init_containers.value, "lifecycle", null) == null ? [] : [init_containers.value.lifecycle]
                    content {
                      dynamic "post_start" {
                        for_each = lookup(lifecycle.value, "post_start", null) == null ? [] : [lifecycle.value.post_start]
                        content {
                          dynamic "exec" {
                            for_each = lookup(post_start.value, "exec", null) == null ? [] : [post_start.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(post_start.value, "http_get", null) == null ? [] : [post_start.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(post_start.value, "sleep", null) == null ? [] : [post_start.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(post_start.value, "tcp_socket", null) == null ? [] : [post_start.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                      dynamic "pre_stop" {
                        for_each = lookup(lifecycle.value, "pre_stop", null) == null ? [] : [lifecycle.value.pre_stop]
                        content {
                          dynamic "exec" {
                            for_each = lookup(pre_stop.value, "exec", null) == null ? [] : [pre_stop.value.exec]
                            content {
                              command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                            }
                          }
                          dynamic "http_get" {
                            for_each = lookup(pre_stop.value, "http_get", null) == null ? [] : [pre_stop.value.http_get]
                            content {
                              host = lookup(http_get.value, "host", null)
                              dynamic "http_headers" {
                                for_each = lookup(http_get.value, "http_headers", [])
                                content {
                                  name  = http_headers.value.name
                                  value = http_headers.value.value
                                }
                              }
                              path   = lookup(http_get.value, "path", null)
                              port   = http_get.value.port
                              scheme = lookup(http_get.value, "scheme", null)
                            }
                          }
                          dynamic "sleep" {
                            for_each = lookup(pre_stop.value, "sleep", null) == null ? [] : [pre_stop.value.sleep]
                            content {
                              seconds = sleep.value.seconds
                            }
                          }
                          dynamic "tcp_socket" {
                            for_each = lookup(pre_stop.value, "tcp_socket", null) == null ? [] : [pre_stop.value.tcp_socket]
                            content {
                              host = lookup(tcp_socket.value, "host", null)
                              port = tcp_socket.value.port
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "liveness_probe" {
                    for_each = lookup(init_containers.value, "liveness_probe", null) == null ? [] : [init_containers.value.liveness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(liveness_probe.value, "exec", null) == null ? [] : [liveness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(liveness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(liveness_probe.value, "grpc", null) == null ? [] : [liveness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(liveness_probe.value, "http_get", null) == null ? [] : [liveness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(liveness_probe.value, "tcp_socket", null) == null ? [] : [liveness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(liveness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(liveness_probe.value, "timeout_seconds", null)
                    }
                  }
                  name = init_containers.value.name
                  dynamic "ports" {
                    for_each = lookup(init_containers.value, "ports", [])
                    content {
                      container_port = ports.value.container_port
                      host_ip        = lookup(ports.value, "host_ip", null)
                      host_port      = lookup(ports.value, "host_port", null)
                      name           = lookup(ports.value, "name", null)
                      protocol       = lookup(ports.value, "protocol", null)
                    }
                  }
                  dynamic "readiness_probe" {
                    for_each = lookup(init_containers.value, "readiness_probe", null) == null ? [] : [init_containers.value.readiness_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(readiness_probe.value, "exec", null) == null ? [] : [readiness_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(readiness_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(readiness_probe.value, "grpc", null) == null ? [] : [readiness_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(readiness_probe.value, "http_get", null) == null ? [] : [readiness_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
                      success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(readiness_probe.value, "tcp_socket", null) == null ? [] : [readiness_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(readiness_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(readiness_probe.value, "timeout_seconds", null)
                    }
                  }
                  dynamic "resize_policy" {
                    for_each = lookup(init_containers.value, "resize_policy", [])
                    content {
                      resource_name  = resize_policy.value.resource_name
                      restart_policy = resize_policy.value.restart_policy
                    }
                  }
                  dynamic "resources" {
                    for_each = lookup(init_containers.value, "resources", null) == null ? [] : [init_containers.value.resources]
                    content {
                      dynamic "claims" {
                        for_each = lookup(resources.value, "claims", [])
                        content {
                          name = claims.value.name
                        }
                      }
                      limits   = lookup(resources.value, "limits", null)
                      requests = lookup(resources.value, "requests", null)
                    }
                  }
                  restart_policy = lookup(init_containers.value, "restart_policy", null)
                  dynamic "security_context" {
                    for_each = lookup(init_containers.value, "security_context", null) == null ? [] : [init_containers.value.security_context]
                    content {
                      allow_privilege_escalation = lookup(security_context.value, "allow_privilege_escalation", null)
                      dynamic "app_armor_profile" {
                        for_each = lookup(security_context.value, "app_armor_profile", null) == null ? [] : [security_context.value.app_armor_profile]
                        content {
                          localhost_profile = lookup(app_armor_profile.value, "localhost_profile", null)
                          type              = app_armor_profile.value.type
                        }
                      }
                      dynamic "capabilities" {
                        for_each = lookup(security_context.value, "capabilities", null) == null ? [] : [security_context.value.capabilities]
                        content {
                          add  = contains(keys(capabilities.value), "add") ? tolist(capabilities.value.add) : null
                          drop = contains(keys(capabilities.value), "drop") ? tolist(capabilities.value.drop) : null
                        }
                      }
                      privileged                = lookup(security_context.value, "privileged", null)
                      proc_mount                = lookup(security_context.value, "proc_mount", null)
                      read_only_root_filesystem = lookup(security_context.value, "read_only_root_filesystem", null)
                      run_asgroup               = lookup(security_context.value, "run_asgroup", null)
                      run_asnon_root            = lookup(security_context.value, "run_asnon_root", null)
                      run_asuser                = lookup(security_context.value, "run_asuser", null)
                      dynamic "seccomp_profile" {
                        for_each = lookup(security_context.value, "seccomp_profile", null) == null ? [] : [security_context.value.seccomp_profile]
                        content {
                          localhost_profile = lookup(seccomp_profile.value, "localhost_profile", null)
                          type              = seccomp_profile.value.type
                        }
                      }
                      dynamic "selinux_options" {
                        for_each = lookup(security_context.value, "selinux_options", null) == null ? [] : [security_context.value.selinux_options]
                        content {
                          level = lookup(selinux_options.value, "level", null)
                          role  = lookup(selinux_options.value, "role", null)
                          type  = lookup(selinux_options.value, "type", null)
                          user  = lookup(selinux_options.value, "user", null)
                        }
                      }
                      dynamic "windows_options" {
                        for_each = lookup(security_context.value, "windows_options", null) == null ? [] : [security_context.value.windows_options]
                        content {
                          gmsa_credential_spec      = lookup(windows_options.value, "gmsa_credential_spec", null)
                          gmsa_credential_spec_name = lookup(windows_options.value, "gmsa_credential_spec_name", null)
                          host_process              = lookup(windows_options.value, "host_process", null)
                          run_asuser_name           = lookup(windows_options.value, "run_asuser_name", null)
                        }
                      }
                    }
                  }
                  dynamic "startup_probe" {
                    for_each = lookup(init_containers.value, "startup_probe", null) == null ? [] : [init_containers.value.startup_probe]
                    content {
                      dynamic "exec" {
                        for_each = lookup(startup_probe.value, "exec", null) == null ? [] : [startup_probe.value.exec]
                        content {
                          command = contains(keys(exec.value), "command") ? tolist(exec.value.command) : null
                        }
                      }
                      failure_threshold = lookup(startup_probe.value, "failure_threshold", null)
                      dynamic "grpc" {
                        for_each = lookup(startup_probe.value, "grpc", null) == null ? [] : [startup_probe.value.grpc]
                        content {
                          port    = grpc.value.port
                          service = lookup(grpc.value, "service", null)
                        }
                      }
                      dynamic "http_get" {
                        for_each = lookup(startup_probe.value, "http_get", null) == null ? [] : [startup_probe.value.http_get]
                        content {
                          host = lookup(http_get.value, "host", null)
                          dynamic "http_headers" {
                            for_each = lookup(http_get.value, "http_headers", [])
                            content {
                              name  = http_headers.value.name
                              value = http_headers.value.value
                            }
                          }
                          path   = lookup(http_get.value, "path", null)
                          port   = http_get.value.port
                          scheme = lookup(http_get.value, "scheme", null)
                        }
                      }
                      initial_delay_seconds = lookup(startup_probe.value, "initial_delay_seconds", null)
                      period_seconds        = lookup(startup_probe.value, "period_seconds", null)
                      success_threshold     = lookup(startup_probe.value, "success_threshold", null)
                      dynamic "tcp_socket" {
                        for_each = lookup(startup_probe.value, "tcp_socket", null) == null ? [] : [startup_probe.value.tcp_socket]
                        content {
                          host = lookup(tcp_socket.value, "host", null)
                          port = tcp_socket.value.port
                        }
                      }
                      termination_grace_period_seconds = lookup(startup_probe.value, "termination_grace_period_seconds", null)
                      timeout_seconds                  = lookup(startup_probe.value, "timeout_seconds", null)
                    }
                  }
                  stdin                      = lookup(init_containers.value, "stdin", null)
                  stdin_once                 = lookup(init_containers.value, "stdin_once", null)
                  termination_message_path   = lookup(init_containers.value, "termination_message_path", null)
                  termination_message_policy = lookup(init_containers.value, "termination_message_policy", null)
                  tty                        = lookup(init_containers.value, "tty", null)
                  dynamic "volume_devices" {
                    for_each = lookup(init_containers.value, "volume_devices", [])
                    content {
                      device_path = volume_devices.value.device_path
                      name        = volume_devices.value.name
                    }
                  }
                  dynamic "volume_mounts" {
                    for_each = lookup(init_containers.value, "volume_mounts", [])
                    content {
                      mount_path          = volume_mounts.value.mount_path
                      mount_propagation   = lookup(volume_mounts.value, "mount_propagation", null)
                      name                = volume_mounts.value.name
                      read_only           = lookup(volume_mounts.value, "read_only", null)
                      recursive_read_only = lookup(volume_mounts.value, "recursive_read_only", null)
                      sub_path            = lookup(volume_mounts.value, "sub_path", null)
                      sub_path_expr       = lookup(volume_mounts.value, "sub_path_expr", null)
                    }
                  }
                  working_dir = lookup(init_containers.value, "working_dir", null)
                }
              }
              node_name     = lookup(job_template.value, "node_name", null)
              node_selector = lookup(job_template.value, "node_selector", null)

              dynamic "os" {
                for_each = lookup(job_template.value, "os", null) == null ? [] : [job_template.value.os]
                content {
                  name = os.value.name
                }
              }
              overhead            = lookup(job_template.value, "overhead", null)
              preemption_policy   = lookup(job_template.value, "preemption_policy", null)
              priority            = lookup(job_template.value, "priority", null)
              priority_class_name = lookup(job_template.value, "priority_class_name", null)

              dynamic "readiness_gates" {
                for_each = lookup(job_template.value, "readiness_gates", [])
                content {
                  condition_type = readiness_gates.value.condition_type
                }
              }

              dynamic "resource_claims" {
                for_each = lookup(job_template.value, "resource_claims", [])
                content {
                  name = resource_claims.value.name
                  dynamic "source" {
                    for_each = lookup(resource_claims.value, "source", null) == null ? [] : [resource_claims.value.source]
                    content {
                      resource_claim_name          = lookup(source.value, "resource_claim_name", null)
                      resource_claim_template_name = lookup(source.value, "resource_claim_template_name", null)
                    }
                  }
                }
              }
              restart_policy     = lookup(job_template.value, "restart_policy", null)
              runtime_class_name = lookup(job_template.value, "runtime_class_name", null)
              scheduler_name     = lookup(job_template.value, "scheduler_name", null)

              dynamic "scheduling_gates" {
                for_each = lookup(job_template.value, "scheduling_gates", [])
                content {
                  name = scheduling_gates.value.name
                }
              }

              dynamic "security_context" {
                for_each = lookup(job_template.value, "security_context", null) == null ? [] : [job_template.value.security_context]
                content {
                  dynamic "app_armor_profile" {
                    for_each = lookup(security_context.value, "app_armor_profile", null) == null ? [] : [security_context.value.app_armor_profile]
                    content {
                      localhost_profile = lookup(app_armor_profile.value, "localhost_profile", null)
                      type              = app_armor_profile.value.type
                    }
                  }
                  fsgroup               = lookup(security_context.value, "fsgroup", null)
                  fsgroup_change_policy = lookup(security_context.value, "fsgroup_change_policy", null)
                  run_asgroup           = lookup(security_context.value, "run_asgroup", null)
                  run_asnon_root        = lookup(security_context.value, "run_asnon_root", null)
                  run_asuser            = lookup(security_context.value, "run_asuser", null)
                  dynamic "seccomp_profile" {
                    for_each = lookup(security_context.value, "seccomp_profile", null) == null ? [] : [security_context.value.seccomp_profile]
                    content {
                      localhost_profile = lookup(seccomp_profile.value, "localhost_profile", null)
                      type              = seccomp_profile.value.type
                    }
                  }
                  dynamic "selinux_options" {
                    for_each = lookup(security_context.value, "selinux_options", null) == null ? [] : [security_context.value.selinux_options]
                    content {
                      level = lookup(selinux_options.value, "level", null)
                      role  = lookup(selinux_options.value, "role", null)
                      type  = lookup(selinux_options.value, "type", null)
                      user  = lookup(selinux_options.value, "user", null)
                    }
                  }
                  supplemental_groups = contains(keys(security_context.value), "supplemental_groups") ? tolist(security_context.value.supplemental_groups) : null
                  dynamic "sysctls" {
                    for_each = lookup(security_context.value, "sysctls", [])
                    content {
                      name  = sysctls.value.name
                      value = sysctls.value.value
                    }
                  }
                  dynamic "windows_options" {
                    for_each = lookup(security_context.value, "windows_options", null) == null ? [] : [security_context.value.windows_options]
                    content {
                      gmsa_credential_spec      = lookup(windows_options.value, "gmsa_credential_spec", null)
                      gmsa_credential_spec_name = lookup(windows_options.value, "gmsa_credential_spec_name", null)
                      host_process              = lookup(windows_options.value, "host_process", null)
                      run_asuser_name           = lookup(windows_options.value, "run_asuser_name", null)
                    }
                  }
                }
              }
              service_account                  = lookup(job_template.value, "service_account", null)
              service_account_name             = lookup(job_template.value, "service_account_name", null)
              set_hostname_asfqdn              = lookup(job_template.value, "set_hostname_asfqdn", null)
              share_process_namespace          = lookup(job_template.value, "share_process_namespace", null)
              subdomain                        = lookup(job_template.value, "subdomain", null)
              termination_grace_period_seconds = lookup(job_template.value, "termination_grace_period_seconds", null)

              dynamic "tolerations" {
                for_each = lookup(job_template.value, "tolerations", [])
                content {
                  effect             = lookup(tolerations.value, "effect", null)
                  key                = lookup(tolerations.value, "key", null)
                  operator           = lookup(tolerations.value, "operator", null)
                  toleration_seconds = lookup(tolerations.value, "toleration_seconds", null)
                  value              = lookup(tolerations.value, "value", null)
                }
              }

              dynamic "topology_spread_constraints" {
                for_each = lookup(job_template.value, "topology_spread_constraints", [])
                content {
                  dynamic "label_selector" {
                    for_each = lookup(topology_spread_constraints.value, "label_selector", null) == null ? [] : [topology_spread_constraints.value.label_selector]
                    content {
                      dynamic "match_expressions" {
                        for_each = lookup(label_selector.value, "match_expressions", [])
                        content {
                          key      = match_expressions.value.key
                          operator = match_expressions.value.operator
                          values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                        }
                      }
                      match_labels = lookup(label_selector.value, "match_labels", null)
                    }
                  }
                  match_label_keys     = contains(keys(topology_spread_constraints.value), "match_label_keys") ? tolist(topology_spread_constraints.value.match_label_keys) : null
                  max_skew             = topology_spread_constraints.value.max_skew
                  min_domains          = lookup(topology_spread_constraints.value, "min_domains", null)
                  node_affinity_policy = lookup(topology_spread_constraints.value, "node_affinity_policy", null)
                  node_taints_policy   = lookup(topology_spread_constraints.value, "node_taints_policy", null)
                  topology_key         = topology_spread_constraints.value.topology_key
                  when_unsatisfiable   = topology_spread_constraints.value.when_unsatisfiable
                }
              }

              dynamic "volumes" {
                for_each = lookup(job_template.value, "volumes", [])
                content {
                  dynamic "aws_elastic_block_store" {
                    for_each = lookup(volumes.value, "aws_elastic_block_store", null) == null ? [] : [volumes.value.aws_elastic_block_store]
                    content {
                      fstype    = lookup(aws_elastic_block_store.value, "fstype", null)
                      partition = lookup(aws_elastic_block_store.value, "partition", null)
                      read_only = lookup(aws_elastic_block_store.value, "read_only", null)
                      volume_id = aws_elastic_block_store.value.volume_id
                    }
                  }
                  dynamic "azure_disk" {
                    for_each = lookup(volumes.value, "azure_disk", null) == null ? [] : [volumes.value.azure_disk]
                    content {
                      caching_mode = lookup(azure_disk.value, "caching_mode", null)
                      disk_name    = azure_disk.value.disk_name
                      disk_uri     = azure_disk.value.disk_uri
                      fstype       = lookup(azure_disk.value, "fstype", null)
                      kind         = lookup(azure_disk.value, "kind", null)
                      read_only    = lookup(azure_disk.value, "read_only", null)
                    }
                  }
                  dynamic "azure_file" {
                    for_each = lookup(volumes.value, "azure_file", null) == null ? [] : [volumes.value.azure_file]
                    content {
                      read_only   = lookup(azure_file.value, "read_only", null)
                      secret_name = azure_file.value.secret_name
                      share_name  = azure_file.value.share_name
                    }
                  }
                  dynamic "cephfs" {
                    for_each = lookup(volumes.value, "cephfs", null) == null ? [] : [volumes.value.cephfs]
                    content {
                      monitors    = cephfs.value.monitors
                      path        = lookup(cephfs.value, "path", null)
                      read_only   = lookup(cephfs.value, "read_only", null)
                      secret_file = lookup(cephfs.value, "secret_file", null)
                      dynamic "secret_ref" {
                        for_each = lookup(cephfs.value, "secret_ref", null) == null ? [] : [cephfs.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      user = lookup(cephfs.value, "user", null)
                    }
                  }
                  dynamic "cinder" {
                    for_each = lookup(volumes.value, "cinder", null) == null ? [] : [volumes.value.cinder]
                    content {
                      fstype    = lookup(cinder.value, "fstype", null)
                      read_only = lookup(cinder.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(cinder.value, "secret_ref", null) == null ? [] : [cinder.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      volume_id = cinder.value.volume_id
                    }
                  }
                  dynamic "config_map" {
                    for_each = lookup(volumes.value, "config_map", null) == null ? [] : [volumes.value.config_map]
                    content {
                      default_mode = lookup(config_map.value, "default_mode", null)
                      dynamic "items" {
                        for_each = lookup(config_map.value, "items", [])
                        content {
                          key  = items.value.key
                          mode = lookup(items.value, "mode", null)
                          path = items.value.path
                        }
                      }
                      name     = lookup(config_map.value, "name", null)
                      optional = lookup(config_map.value, "optional", null)
                    }
                  }
                  dynamic "csi" {
                    for_each = lookup(volumes.value, "csi", null) == null ? [] : [volumes.value.csi]
                    content {
                      driver = csi.value.driver
                      fstype = lookup(csi.value, "fstype", null)
                      dynamic "node_publish_secret_ref" {
                        for_each = lookup(csi.value, "node_publish_secret_ref", null) == null ? [] : [csi.value.node_publish_secret_ref]
                        content {
                          name = lookup(node_publish_secret_ref.value, "name", null)
                        }
                      }
                      read_only         = lookup(csi.value, "read_only", null)
                      volume_attributes = lookup(csi.value, "volume_attributes", null)
                    }
                  }
                  dynamic "downward_api" {
                    for_each = lookup(volumes.value, "downward_api", null) == null ? [] : [volumes.value.downward_api]
                    content {
                      default_mode = lookup(downward_api.value, "default_mode", null)
                      dynamic "items" {
                        for_each = lookup(downward_api.value, "items", [])
                        content {
                          dynamic "field_ref" {
                            for_each = lookup(items.value, "field_ref", null) == null ? [] : [items.value.field_ref]
                            content {
                              api_version = lookup(field_ref.value, "api_version", null)
                              field_path  = field_ref.value.field_path
                            }
                          }
                          mode = lookup(items.value, "mode", null)
                          path = items.value.path
                          dynamic "resource_field_ref" {
                            for_each = lookup(items.value, "resource_field_ref", null) == null ? [] : [items.value.resource_field_ref]
                            content {
                              container_name = lookup(resource_field_ref.value, "container_name", null)
                              divisor        = lookup(resource_field_ref.value, "divisor", null)
                              resource       = resource_field_ref.value.resource
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "empty_dir" {
                    for_each = lookup(volumes.value, "empty_dir", null) == null ? [] : [volumes.value.empty_dir]
                    content {
                      medium     = lookup(empty_dir.value, "medium", null)
                      size_limit = lookup(empty_dir.value, "size_limit", null)
                    }
                  }
                  dynamic "ephemeral" {
                    for_each = lookup(volumes.value, "ephemeral", null) == null ? [] : [volumes.value.ephemeral]
                    content {
                      dynamic "volume_claim_template" {
                        for_each = lookup(ephemeral.value, "volume_claim_template", null) == null ? [] : [ephemeral.value.volume_claim_template]
                        content {

                          metadata {
                            annotations = lookup(volume_claim_template.value, "annotations", null)
                            labels      = lookup(volume_claim_template.value, "labels", null)
                            name        = lookup(volume_claim_template.value, "name", null)
                            namespace   = lookup(volume_claim_template.value, "namespace", null)
                          }

                          spec {
                            access_modes = contains(keys(volume_claim_template.value), "access_modes") ? tolist(volume_claim_template.value.access_modes) : null

                            dynamic "data_source" {
                              for_each = lookup(volume_claim_template.value, "data_source", null) == null ? [] : [volume_claim_template.value.data_source]
                              content {
                                api_group = lookup(data_source.value, "api_group", null)
                                kind      = data_source.value.kind
                                name      = data_source.value.name
                              }
                            }

                            dynamic "data_source_ref" {
                              for_each = lookup(volume_claim_template.value, "data_source_ref", null) == null ? [] : [volume_claim_template.value.data_source_ref]
                              content {
                                api_group = lookup(data_source_ref.value, "api_group", null)
                                kind      = data_source_ref.value.kind
                                name      = data_source_ref.value.name
                                namespace = lookup(data_source_ref.value, "namespace", null)
                              }
                            }

                            dynamic "resources" {
                              for_each = lookup(volume_claim_template.value, "resources", null) == null ? [] : [volume_claim_template.value.resources]
                              content {
                                limits   = lookup(resources.value, "limits", null)
                                requests = lookup(resources.value, "requests", null)
                              }
                            }

                            dynamic "selector" {
                              for_each = lookup(volume_claim_template.value, "selector", null) == null ? [] : [volume_claim_template.value.selector]
                              content {
                                dynamic "match_expressions" {
                                  for_each = lookup(selector.value, "match_expressions", [])
                                  content {
                                    key      = match_expressions.value.key
                                    operator = match_expressions.value.operator
                                    values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                  }
                                }
                                match_labels = lookup(selector.value, "match_labels", null)
                              }
                            }
                            storage_class_name           = lookup(volume_claim_template.value, "storage_class_name", null)
                            volume_attributes_class_name = lookup(volume_claim_template.value, "volume_attributes_class_name", null)
                            volume_mode                  = lookup(volume_claim_template.value, "volume_mode", null)
                            volume_name                  = lookup(volume_claim_template.value, "volume_name", null)
                          }
                        }
                      }
                    }
                  }
                  dynamic "fc" {
                    for_each = lookup(volumes.value, "fc", null) == null ? [] : [volumes.value.fc]
                    content {
                      fstype      = lookup(fc.value, "fstype", null)
                      lun         = lookup(fc.value, "lun", null)
                      read_only   = lookup(fc.value, "read_only", null)
                      target_wwns = contains(keys(fc.value), "target_wwns") ? tolist(fc.value.target_wwns) : null
                      wwids       = contains(keys(fc.value), "wwids") ? tolist(fc.value.wwids) : null
                    }
                  }
                  dynamic "flex_volume" {
                    for_each = lookup(volumes.value, "flex_volume", null) == null ? [] : [volumes.value.flex_volume]
                    content {
                      driver    = flex_volume.value.driver
                      fstype    = lookup(flex_volume.value, "fstype", null)
                      options   = lookup(flex_volume.value, "options", null)
                      read_only = lookup(flex_volume.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(flex_volume.value, "secret_ref", null) == null ? [] : [flex_volume.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                    }
                  }
                  dynamic "flocker" {
                    for_each = lookup(volumes.value, "flocker", null) == null ? [] : [volumes.value.flocker]
                    content {
                      dataset_name = lookup(flocker.value, "dataset_name", null)
                      dataset_uuid = lookup(flocker.value, "dataset_uuid", null)
                    }
                  }
                  dynamic "gce_persistent_disk" {
                    for_each = lookup(volumes.value, "gce_persistent_disk", null) == null ? [] : [volumes.value.gce_persistent_disk]
                    content {
                      fstype    = lookup(gce_persistent_disk.value, "fstype", null)
                      partition = lookup(gce_persistent_disk.value, "partition", null)
                      pdname    = gce_persistent_disk.value.pdname
                      read_only = lookup(gce_persistent_disk.value, "read_only", null)
                    }
                  }
                  dynamic "git_repo" {
                    for_each = lookup(volumes.value, "git_repo", null) == null ? [] : [volumes.value.git_repo]
                    content {
                      directory  = lookup(git_repo.value, "directory", null)
                      repository = git_repo.value.repository
                      revision   = lookup(git_repo.value, "revision", null)
                    }
                  }
                  dynamic "glusterfs" {
                    for_each = lookup(volumes.value, "glusterfs", null) == null ? [] : [volumes.value.glusterfs]
                    content {
                      endpoints = glusterfs.value.endpoints
                      path      = glusterfs.value.path
                      read_only = lookup(glusterfs.value, "read_only", null)
                    }
                  }
                  dynamic "host_path" {
                    for_each = lookup(volumes.value, "host_path", null) == null ? [] : [volumes.value.host_path]
                    content {
                      path = host_path.value.path
                      type = lookup(host_path.value, "type", null)
                    }
                  }
                  dynamic "iscsi" {
                    for_each = lookup(volumes.value, "iscsi", null) == null ? [] : [volumes.value.iscsi]
                    content {
                      chap_auth_discovery = lookup(iscsi.value, "chap_auth_discovery", null)
                      chap_auth_session   = lookup(iscsi.value, "chap_auth_session", null)
                      fstype              = lookup(iscsi.value, "fstype", null)
                      initiator_name      = lookup(iscsi.value, "initiator_name", null)
                      iqn                 = iscsi.value.iqn
                      iscsi_interface     = lookup(iscsi.value, "iscsi_interface", null)
                      lun                 = iscsi.value.lun
                      portals             = contains(keys(iscsi.value), "portals") ? tolist(iscsi.value.portals) : null
                      read_only           = lookup(iscsi.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(iscsi.value, "secret_ref", null) == null ? [] : [iscsi.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      target_portal = iscsi.value.target_portal
                    }
                  }
                  name = volumes.value.name
                  dynamic "nfs" {
                    for_each = lookup(volumes.value, "nfs", null) == null ? [] : [volumes.value.nfs]
                    content {
                      path      = nfs.value.path
                      read_only = lookup(nfs.value, "read_only", null)
                      server    = nfs.value.server
                    }
                  }
                  dynamic "persistent_volume_claim" {
                    for_each = lookup(volumes.value, "persistent_volume_claim", null) == null ? [] : [volumes.value.persistent_volume_claim]
                    content {
                      claim_name = persistent_volume_claim.value.claim_name
                      read_only  = lookup(persistent_volume_claim.value, "read_only", null)
                    }
                  }
                  dynamic "photon_persistent_disk" {
                    for_each = lookup(volumes.value, "photon_persistent_disk", null) == null ? [] : [volumes.value.photon_persistent_disk]
                    content {
                      fstype = lookup(photon_persistent_disk.value, "fstype", null)
                      pdid   = photon_persistent_disk.value.pdid
                    }
                  }
                  dynamic "portworx_volume" {
                    for_each = lookup(volumes.value, "portworx_volume", null) == null ? [] : [volumes.value.portworx_volume]
                    content {
                      fstype    = lookup(portworx_volume.value, "fstype", null)
                      read_only = lookup(portworx_volume.value, "read_only", null)
                      volume_id = portworx_volume.value.volume_id
                    }
                  }
                  dynamic "projected" {
                    for_each = lookup(volumes.value, "projected", null) == null ? [] : [volumes.value.projected]
                    content {
                      default_mode = lookup(projected.value, "default_mode", null)
                      dynamic "sources" {
                        for_each = lookup(projected.value, "sources", [])
                        content {
                          dynamic "cluster_trust_bundle" {
                            for_each = lookup(sources.value, "cluster_trust_bundle", null) == null ? [] : [sources.value.cluster_trust_bundle]
                            content {
                              dynamic "label_selector" {
                                for_each = lookup(cluster_trust_bundle.value, "label_selector", null) == null ? [] : [cluster_trust_bundle.value.label_selector]
                                content {
                                  dynamic "match_expressions" {
                                    for_each = lookup(label_selector.value, "match_expressions", [])
                                    content {
                                      key      = match_expressions.value.key
                                      operator = match_expressions.value.operator
                                      values   = contains(keys(match_expressions.value), "values") ? tolist(match_expressions.value.values) : null
                                    }
                                  }
                                  match_labels = lookup(label_selector.value, "match_labels", null)
                                }
                              }
                              name        = lookup(cluster_trust_bundle.value, "name", null)
                              optional    = lookup(cluster_trust_bundle.value, "optional", null)
                              path        = cluster_trust_bundle.value.path
                              signer_name = lookup(cluster_trust_bundle.value, "signer_name", null)
                            }
                          }
                          dynamic "config_map" {
                            for_each = lookup(sources.value, "config_map", null) == null ? [] : [sources.value.config_map]
                            content {
                              dynamic "items" {
                                for_each = lookup(config_map.value, "items", [])
                                content {
                                  key  = items.value.key
                                  mode = lookup(items.value, "mode", null)
                                  path = items.value.path
                                }
                              }
                              name     = lookup(config_map.value, "name", null)
                              optional = lookup(config_map.value, "optional", null)
                            }
                          }
                          dynamic "downward_api" {
                            for_each = lookup(sources.value, "downward_api", null) == null ? [] : [sources.value.downward_api]
                            content {
                              dynamic "items" {
                                for_each = lookup(downward_api.value, "items", [])
                                content {
                                  dynamic "field_ref" {
                                    for_each = lookup(items.value, "field_ref", null) == null ? [] : [items.value.field_ref]
                                    content {
                                      api_version = lookup(field_ref.value, "api_version", null)
                                      field_path  = field_ref.value.field_path
                                    }
                                  }
                                  mode = lookup(items.value, "mode", null)
                                  path = items.value.path
                                  dynamic "resource_field_ref" {
                                    for_each = lookup(items.value, "resource_field_ref", null) == null ? [] : [items.value.resource_field_ref]
                                    content {
                                      container_name = lookup(resource_field_ref.value, "container_name", null)
                                      divisor        = lookup(resource_field_ref.value, "divisor", null)
                                      resource       = resource_field_ref.value.resource
                                    }
                                  }
                                }
                              }
                            }
                          }
                          dynamic "secret" {
                            for_each = lookup(sources.value, "secret", null) == null ? [] : [sources.value.secret]
                            content {
                              dynamic "items" {
                                for_each = lookup(secret.value, "items", [])
                                content {
                                  key  = items.value.key
                                  mode = lookup(items.value, "mode", null)
                                  path = items.value.path
                                }
                              }
                              name     = lookup(secret.value, "name", null)
                              optional = lookup(secret.value, "optional", null)
                            }
                          }
                          dynamic "service_account_token" {
                            for_each = lookup(sources.value, "service_account_token", null) == null ? [] : [sources.value.service_account_token]
                            content {
                              audience           = lookup(service_account_token.value, "audience", null)
                              expiration_seconds = lookup(service_account_token.value, "expiration_seconds", null)
                              path               = service_account_token.value.path
                            }
                          }
                        }
                      }
                    }
                  }
                  dynamic "quobyte" {
                    for_each = lookup(volumes.value, "quobyte", null) == null ? [] : [volumes.value.quobyte]
                    content {
                      group     = lookup(quobyte.value, "group", null)
                      read_only = lookup(quobyte.value, "read_only", null)
                      registry  = quobyte.value.registry
                      tenant    = lookup(quobyte.value, "tenant", null)
                      user      = lookup(quobyte.value, "user", null)
                      volume    = quobyte.value.volume
                    }
                  }
                  dynamic "rbd" {
                    for_each = lookup(volumes.value, "rbd", null) == null ? [] : [volumes.value.rbd]
                    content {
                      fstype    = lookup(rbd.value, "fstype", null)
                      image     = rbd.value.image
                      keyring   = lookup(rbd.value, "keyring", null)
                      monitors  = rbd.value.monitors
                      pool      = lookup(rbd.value, "pool", null)
                      read_only = lookup(rbd.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(rbd.value, "secret_ref", null) == null ? [] : [rbd.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      user = lookup(rbd.value, "user", null)
                    }
                  }
                  dynamic "scale_io" {
                    for_each = lookup(volumes.value, "scale_io", null) == null ? [] : [volumes.value.scale_io]
                    content {
                      fstype            = lookup(scale_io.value, "fstype", null)
                      gateway           = scale_io.value.gateway
                      protection_domain = lookup(scale_io.value, "protection_domain", null)
                      read_only         = lookup(scale_io.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(scale_io.value, "secret_ref", null) == null ? [] : [scale_io.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      ssl_enabled  = lookup(scale_io.value, "ssl_enabled", null)
                      storage_mode = lookup(scale_io.value, "storage_mode", null)
                      storage_pool = lookup(scale_io.value, "storage_pool", null)
                      system       = scale_io.value.system
                      volume_name  = lookup(scale_io.value, "volume_name", null)
                    }
                  }
                  dynamic "secret" {
                    for_each = lookup(volumes.value, "secret", null) == null ? [] : [volumes.value.secret]
                    content {
                      default_mode = lookup(secret.value, "default_mode", null)
                      dynamic "items" {
                        for_each = lookup(secret.value, "items", [])
                        content {
                          key  = items.value.key
                          mode = lookup(items.value, "mode", null)
                          path = items.value.path
                        }
                      }
                      optional    = lookup(secret.value, "optional", null)
                      secret_name = lookup(secret.value, "secret_name", null)
                    }
                  }
                  dynamic "storageos" {
                    for_each = lookup(volumes.value, "storageos", null) == null ? [] : [volumes.value.storageos]
                    content {
                      fstype    = lookup(storageos.value, "fstype", null)
                      read_only = lookup(storageos.value, "read_only", null)
                      dynamic "secret_ref" {
                        for_each = lookup(storageos.value, "secret_ref", null) == null ? [] : [storageos.value.secret_ref]
                        content {
                          name = lookup(secret_ref.value, "name", null)
                        }
                      }
                      volume_name      = lookup(storageos.value, "volume_name", null)
                      volume_namespace = lookup(storageos.value, "volume_namespace", null)
                    }
                  }
                  dynamic "vsphere_volume" {
                    for_each = lookup(volumes.value, "vsphere_volume", null) == null ? [] : [volumes.value.vsphere_volume]
                    content {
                      fstype              = lookup(vsphere_volume.value, "fstype", null)
                      storage_policy_id   = lookup(vsphere_volume.value, "storage_policy_id", null)
                      storage_policy_name = lookup(vsphere_volume.value, "storage_policy_name", null)
                      volume_path         = vsphere_volume.value.volume_path
                    }
                  }
                }
              }
            }
          }
          ttl_seconds_after_finished = lookup(job_template.value, "ttl_seconds_after_finished", null)
        }
      }
    }
    schedule                      = local.k8s_batch_v1_cron_job_parameters.schedule
    starting_deadline_seconds     = lookup(local.k8s_batch_v1_cron_job_parameters, "starting_deadline_seconds", null)
    successful_jobs_history_limit = lookup(local.k8s_batch_v1_cron_job_parameters, "successful_jobs_history_limit", null)
    suspend                       = lookup(local.k8s_batch_v1_cron_job_parameters, "suspend", null)
    time_zone                     = lookup(local.k8s_batch_v1_cron_job_parameters, "time_zone", null)
  }

  lifecycle {

  }
}

