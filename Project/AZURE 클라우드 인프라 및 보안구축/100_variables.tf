variable "rg_korea_name" {
  type    = string
  default = "05-team03-lsbin-RG-01-Korea"
}

variable "rg_canada_name" {
  type    = string
  default = "05-team03-lsbin-RG-02-Canada"
}

variable "location_korea" {
  type    = string
  default = "KoreaCentral"
}

variable "location_canada" {
  type    = string
  default = "CanadaCentral"
}

variable "vnet_a_name" {
  type    = string
  default = "team03-vnet"
}

variable "vnet_b_name" {
  type    = string
  default = "team03-vnet-b"
}

variable "enable_db_korea" {
  type    = bool
  default = true
}

variable "enable_db_canada" {
  type    = bool
  default = true
}

variable "db_admin" {
  type    = string
  default = "lsbin"
}

variable "ro_db_user" {
  type    = string
  default = "wpuser"
}

variable "custom_domain" {
  type    = string
  default = "www.lsbin.store"
}


# 1) 2026-01-27 / 14:15
# 2) (신규 추가)
# 3) variable "mysql_allow_destroy" { ... }
# 4) MySQL 삭제 방지(Lock) 기능을 제어하기 위한 변수 추가.
#    기본값 false: 삭제 방지 (Lock 생성)
#    true: 삭제 허용 (Lock 미생성/제거)
# MySQL 서버 destroy 방지용(기본 false 권장)
variable "mysql_allow_destroy" {
  type    = bool
  default = false
}
