# 2026-02-06 15:05 리팩토링: 모든 변수 통합 관리 및 전형화 적용

variable "prefix" {
  type    = string
  default = "lsbin"
}

variable "location" {
  type    = string
  default = "KoreaCentral"
}

variable "rg_name" {
  type    = string
  default = "05-team03-lsbin-RG"
}

# 1. Network Variables
variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type = map(list(string))
  default = {
    bat       = ["10.0.0.0/24"]
    web       = ["10.0.1.0/24"]
    load      = ["10.0.3.0/24"]
    db_secure = ["10.0.5.0/24"]
  }
}

# 2. Compute & DB Variables
variable "admin_username" {
  type    = string
  default = "lsbin"
}

variable "vm_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "db_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "db_version" {
  type    = string
  default = "8.0.21"
}

variable "db_storage_gb" {
  type    = number
  default = 20
}

variable "db_backup_retention" {
  type    = number
  default = 7
}

variable "db_admin" {
  type    = string
  default = "lsbin"
}

variable "ro_db_user" {
  type    = string
  default = "wpuser"
}

# 3. Monitoring Variables (LAW)
variable "law_sku" {
  type    = string
  default = "PerGB2018"
}

variable "law_retention" {
  type    = number
  default = 30
}

# 4. Service Specific
variable "custom_domain" {
  type    = string
  default = "www.lsbin.store"
}

variable "member_a" {
  type    = string
  default = "c5bbd38d-adfc-405e-9744-649ac2cacad9"
}

variable "member_b" {
  type    = string
  default = "e4f65a17-d1af-4f78-b6f3-1c746751934d"
}

variable "member_c" {
  type    = string
  default = "2c311acc-4bc7-4645-9b81-a0312ad1401a"
}
