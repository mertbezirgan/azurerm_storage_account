resource "azurerm_storage_account" "storage_acc" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_kind                    = var.account_kind
  access_tier                     = var.access_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = true
  min_tls_version                 = var.min_tls_version
  public_network_access_enabled   = var.public_network_access_enabled
  tags                            = var.tags

  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
    container_delete_retention_policy {
      days = var.retention_days
    }
    delete_retention_policy {
      days = var.retention_days
    }
  }

  share_properties {
    retention_policy {
      days = var.retention_days
    }
  }
}

resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id         = azurerm_storage_account.storage_acc.id
  default_action             = "Allow"
  ip_rules                   = var.allowed_ip_ranges
  virtual_network_subnet_ids = var.allowed_virtual_network_subnet_ids
}

resource "azurerm_storage_container" "container" {
  for_each              = var.containers
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage_acc.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_encryption_scope" "storage_encryption" {
  name               = "microsoftmanaged"
  storage_account_id = azurerm_storage_account.storage_acc.id
  source             = "Microsoft.Storage"
}
