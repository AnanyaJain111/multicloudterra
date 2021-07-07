resource "azurerm_virtual_machine" "web-vm" {
	  depends_on=[azurerm_network_interface.web-private-nic]
	

	  location              = azurerm_resource_group.network-rg.location
	  resource_group_name   = azurerm_resource_group.network-rg.name
	  name                  = "web-${random_string.web-vm-name.result}-vm"
	  network_interface_ids = [azurerm_network_interface.web-private-nic.id]
	  vm_size               = var.web_vm_size
	  license_type          = var.web_license_type
	

	  delete_os_disk_on_termination    = var.web_delete_os_disk_on_termination
	  delete_data_disks_on_termination = var.web_delete_data_disks_on_termination
	

	  storage_image_reference {
	    id        = lookup(var.web_vm_image, "id", null)
	    offer     = lookup(var.web_vm_image, "offer", null)
	    publisher = lookup(var.web_vm_image, "publisher", null)
	    sku       = lookup(var.web_vm_image, "sku", null)
	    version   = lookup(var.web_vm_image, "version", null)
	  }
	

	  storage_os_disk {
	    name              = "web-${random_string.web-vm-name.result}-disk"
	    caching           = "ReadWrite"
	    create_option     = "FromImage"
	    managed_disk_type = "Standard_LRS"
	  }
	

	  os_profile {
	    computer_name  = "web-${random_string.web-vm-name.result}-vm"
	    admin_username = var.web_admin_username
	    admin_password = random_password.web-vm-password.result
	    custom_data    = file("azure-user-data.sh")
	  }
	

	  os_profile_linux_config {
	    disable_password_authentication = false
	  }
	

	  tags = {
	    environment = var.environment
	  }
}

output "web_vm_name" {
	  description = "Virtual Machine name"
	  value       = azurerm_virtual_machine.web-vm.name
	}
	

	output "web_vm_ip_address" {
	  description = "Virtual Machine name IP Address"
	  value       = azurerm_public_ip.web-vm-ip.ip_address
	}
	

	output "web_vm_admin_username" {
	  description = "Username password for the Virtual Machine"
	  value       = azurerm_virtual_machine.web-vm.os_profile.*
	  #sensitive   = true
	}
	

	output "web_vm_admin_password" {
	  description = "Administrator password for the Virtual Machine"
	  value       = random_password.web-vm-password.result
	  #sensitive   = true
	}
