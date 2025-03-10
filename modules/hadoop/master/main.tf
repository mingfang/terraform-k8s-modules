/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

/*
common variables
*/

/*
service specific variables
*/

/*
locals
*/

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }
}

/*
output
*/
