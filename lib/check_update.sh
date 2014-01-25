check_update() {
show_msg "Checking update"
get_file_quiet "https://github.com/satya164/fez/tags.atom" "fez.atom"
dltag=$(grep "<title>v.*</title>" "fez.atom" | grep -o "v[0-9].[0-9].[0-9]" | head -n 1)
dlver=${dltag#v}
if [[ $dlver > $version ]]; then
    get_file_quiet "https://github.com/satya164/fez/raw/v${dlver}/CHANGELOG" "changelog-${dlver}.txt"
    prevdate=$(grep '^Changelog.*' "changelog-${dlver}.txt" | sed -n 2p)
    changelog=$(sed -e /"$prevdate"/q "changelog-${dlver}.txt" | head -n -2)
    updatestat="available"
elif [[ $dlver = $version ]]; then
    updatestat="uptodate"
fi
}

install_update() {
show_msg "Installing update"
get="https://github.com/satya164/fez/archive/v${dlver}.tar.gz"
file="fez.tar.gz"
get_file
tar -xzf "$file"
make uninstall -C fez-${dlver}
make install -C fez-${dlver}
}

show_update() {
check_update
if [[ "$updatestat" = "available" ]]; then
    show_msg "Update available!"
    if [[ ! "$interactive" = "no" ]]; then
        show_dialog --title="Update available" --text="$changelog" --button="Install update:0" --button="Ignore:1"
        if [[ $? -eq 0 ]]; then
            install_update
            show_dialog --title="Update installed" --text="Please restart $program to continue." --button="Close $program:0"
            clean_temp
            exit
        fi
    fi
fi
}
