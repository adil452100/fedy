# Name: Install ATI video driver
# Command: install_ati
# Value: False

install_ati() {
show_func "Installing ATI video driver"
if [[ "$(install_ati_test)" = "Installed" ]]; then
	show_status "ATI video driver seems to be already installed"
else
	add_repo "rpmfusion-free.repo" "rpmfusion-nonfree.repo"
	show_msg "Updating required packages..."
	yum -y update kernel kernel-PAE selinux-policy
	yum check-update kernel kernel-PAE selinux-policy > /dev/null 2>&1
	if [[ $? -eq 100 ]] || [[ "$(uname -r | cut -d- -f 1,2 | cut -d. -f 1,2,3)" = "$(rpm -q kernel | sort | tail -1 | cut -d- -f 2,3 | cut -d. -f 1,2,3)" ]]; then
		install_pkg akmod-catalyst xorg-x11-drv-catalyst xorg-x11-drv-catalyst-libs.i686
	else
		show_warn "Please reboot to the latest kernel before installing drivers..."
	fi
fi
[[ "$(install_ati_test)" = "Installed" ]]; exit_state
}

install_ati_test() {
if [[ -f /usr/share/ati/fglrx-uninstall.sh ]]; then
	printf "Installed"
else
	printf "Not installed"
fi
}

install_ati_hide() {
if [[ ! `lspci -nn | grep VGA | grep ATI` ]]; then
	printf "true"
fi
}
