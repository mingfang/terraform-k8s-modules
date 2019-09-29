/**
 * PriorityClass defines mapping from a priority class name to the priority integer value.
 * The value can be any valid integer.
 *
 * Module usage:
 *
 *     module "priority-class" {
 *       source         = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/priority-class"
 *       name           = "normal"
 *       value          = 50
 *       description    = "Normal Priority"
 *       global_default = true
 *     }
 */

variable name {}

//The value of this priority class. This is the actual priority that pods
// receive when they have the name of this class in their pod spec.
variable "value" {}

//description is an arbitrary string that usually provides guidelines on when this priority class should be used.
variable "description" {
  default = ""
}

//globalDefault specifies whether this PriorityClass should be considered as
// the default priority for pods that do not have any priority class. Only one
// PriorityClass can be marked as `globalDefault`. However, if more than one
// PriorityClasses exists with their `globalDefault` field set to true, the
// smallest value of such global default PriorityClasses will be used as the
// default priority.
variable global_default {
  default = false
}

resource "k8s_scheduling_k8s_io_v1beta1_priority_class" "priority-class" {
  metadata {
    name = "${var.name}"
  }

  value          = "${var.value}"
  description    = "${var.description}"
  global_default = "${var.global_default}"
}
