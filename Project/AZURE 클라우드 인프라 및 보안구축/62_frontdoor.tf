resource "azurerm_cdn_frontdoor_profile" "lsbin_fd" {
  name                = "lsbin-fd"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = local.common_tags

  timeouts {
    delete = "120m"
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "lsbin_fd_ep" {
  name                     = "lsbin-fd-ep"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lsbin_fd.id

  timeouts {
    delete = "120m"
  }

}

resource "azurerm_cdn_frontdoor_origin_group" "lsbin_fd_og" {
  name                     = "lsbin-fd-og"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lsbin_fd.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 0
  }

  health_probe {
    interval_in_seconds = 30
    path                = "/health.html"
    protocol            = "Http"
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "lsbin_fd_origin_01" {
  name                          = "lsbin-fd-origin-01"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.lsbin_fd_og.id

  enabled            = true
  host_name          = azurerm_public_ip.lsbin_loadip.ip_address
  origin_host_header = azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.host_name
  http_port          = 80
  https_port         = 443
  priority           = 1
  weight             = 100

  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_origin" "lsbin_fd_origin_02" {
  name                          = "lsbin-fd-origin-02"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.lsbin_fd_og.id

  enabled            = true
  host_name          = azurerm_public_ip.lsbin_loadip_b.ip_address
  origin_host_header = azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.host_name
  http_port          = 80
  https_port         = 443
  priority           = 2
  weight             = 100

  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "lsbin_fd_route" {
  name                          = "lsbin-fd-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.lsbin_fd_og.id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.lsbin_fd_origin_01.id,
    azurerm_cdn_frontdoor_origin.lsbin_fd_origin_02.id
  ]

  cdn_frontdoor_custom_domain_ids = [
    azurerm_cdn_frontdoor_custom_domain.lsbin_fd_custom.id
  ]

  enabled                = true
  forwarding_protocol    = "HttpOnly"
  https_redirect_enabled = false

  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http"]
  link_to_default_domain = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "lsbin_fd_custom" {
  name                     = "lsbin-fd-custom"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.lsbin_fd.id
  host_name                = var.custom_domain

  tls {
    certificate_type = "ManagedCertificate"
  }
}
