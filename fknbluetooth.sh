sudo sh -c 'echo "0000:01:00.1" > /sys/bus/pci/drivers/hci_bcm4377/unbind && sleep 2 && echo "0000:01:00.1" > /sys/bus/pci/drivers/hci_bcm4377/bind'
sudo systemctl restart bluetooth
