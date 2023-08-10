variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"

  validation {
    condition     = length(var.storage_account_name) <= 24
    error_message = "The storage account name must be less than 24 characters"
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "The storage account name must be lowercase alphanumeric"
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "account_tier" {
  type        = string
  description = "The storage account tier"
  default     = "Standard"

  validation {
    condition     = can(regex("^(Standard|Premium)$", var.account_tier))
    error_message = "The storage account tier must be either Standard or Premium"
  }
}

variable "account_kind" {
  type        = string
  description = "The storage account kind"
  default     = "StorageV2"

  validation {
    condition     = can(regex("^(BlobStorage|BlockBlobStorage|FileStorage|Storage|StorageV2)$", var.account_kind))
    error_message = "The storage account kind must be either BlobStorage, BlockBlobStorage, FileStorage, Storage or StorageV2"
  }
}

variable "access_tier" {
  type        = string
  description = "The storage account access tier"
  default     = "Hot"

  validation {
    condition     = can(regex("^(Hot|Cool)$", var.access_tier))
    error_message = "The storage account access tier must be either Hot or Cool"
  }
}

variable "account_replication_type" {
  type        = string
  description = "The storage account replication type"
  default     = "LRS"

  validation {
    condition     = can(regex("^(LRS|GRS|RAGRS|ZRS|GZRS|RAGZRS)$", var.account_replication_type))
    error_message = "The storage account replication type must be either LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS"
  }
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"

  validation {
    condition     = can(regex("^(TLS1_0|TLS1_1|TLS1_2)$", var.min_tls_version))
    error_message = "The minimum supported TLS version must be either TLS1_0, TLS1_1 or TLS1_2"
  }
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for the storage account"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with the storage account"
  default     = {}
}

variable "retention_days" {
  type        = number
  description = "The number of days to retain deleted blobs for"
  default     = 30
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = []
  description = "The list of IP ranges to allow access to the storage account"
}

variable "allowed_virtual_network_subnet_ids" {
  type        = list(string)
  default     = []
  description = "The list of virtual network subnet IDs to allow access to the storage account"
}

variable "containers" {
  type = map(
    object({
      name                  = string
      container_access_type = string
    })
  )
  default     = {}
  description = "A map of containers to create in the storage account"

  validation {
    condition     = can(regex("^[a-z0-9]+$", values(var.containers)[0].name))
    error_message = "The container name must be lowercase alphanumeric"
  }

  validation {
    condition     = can(regex("^(container|blob|private)$", values(var.containers)[0].container_access_type))
    error_message = "The container access type must be either container, blob or private"
  }
}
