text --non-interactive
url --url=${base_url}
repo --name="epel" --baseurl=${epel_url}
repo --name="AppStream" --baseurl=${appstream_url}
rhsm --organization="${rhsm_org}"" --activation-key="${rhsm_activation_key}"
network --bootproto=dhcp --activate --hostname=tlp_pres_template
eula --agreed
skipx
keyboard us
lang en_US.UTF-8
timezone --utc America/New_York

zerombr
clearpart --all --initlabel
part /boot --fstype=xfs --size=1024
part pv.01 --size=150000 --grow
volgroup vg_root pv.01
logvol / --fstype=xfs --name=lv_root --vgname=vg_root --size=40000 --grow
logvol /home --fstype=xfs --name=lv_opt --vgname=vg_root --size=10000 --fsoptions="nodev"
logvol /tmp --fstype=xfs --name=lv_tmp --vgname=vg_root --size=10000 --fsoptions="nodev,nosuid,noexec"
logvol /var --fstype=xfs --name=lv_var --vgname=vg_root --size=10000 --fsoptions="nodev"
logvol /var/log --fstype=xfs --name=lv_log --vgname=vg_root --size=40000 --fsoptions="nodev,nosuid,noexec"
logvol /var/tmp --fstype=xfs --name=lv_log_tmp --vgname=vg_root --size=10000 --fsoptions="nodev,nosuid,noexec"
logvol /var/log/audit --fstype=xfs --name=lv_audit --vgname=vg_root --size=10000 --fsoptions="nodev,nosuid,noexec"

firstboot --disable
services --disabled="kdump" --enabled="sshd,rsyslog,chronyd"
user --groups=wheel --name="${build_username}" --password="${build_password_encrypted}" --iscrypted
sshkey --username="${build_username}" "{ssh_key}"
rootpw --iscrypted "${root_password_encrypted}"
bootloader --append="crashkernel=auto rhgb"
authselect select minimal without-nullok with-pamaccess with-mkhomedir with-faillock --force
authselect apply

%packages
@^minimal-environment
aide
audit
clevis
clevis-dracut
clevis-luks
clevis-systemd
cloud-init
cloud-utils-growpart
curl
fapolicyd
firewalld
git
kexec-tools
#McAfeeTP
opensc
openscap
openscap-scanner
openssh-server
openssl-pkcs11
python3
python3-libselinux
open-vm-tools
#osbuild-luks2
-plymouth
policycoreutils
rng-tools
rsyslog
rsyslog-gnutls
scap-security-guide
tmux
usbguard
wget
-abrt
-abrt-addon-ccpp
-abrt-addon-kerneloops
-abrt-cli
-abrt-plugin-sosreport
-iprutils
-krb5-server
-krb5-workstation
-libreport-plugin-logger
-libreport-plugin-rhtsupport
-python3-abrt-addon
-rsh-server
-sendmail
-telnet-server
-tftp-server
-tuned
-vsftpd
-xorg-x11-server-Xorg
-xorg-x11-server-Xwayland
-xorg-x11-server-common
-xorg-x11-server-utils
-iwl7260-firmware
-iwl6050-firmware
-iwl5150-firmware
-iwl5000-firmware
-iwl2030-firmware
-iwl105-firmware
-iwl1000-firmware
-iwl100-firmware
-iwl6000g2a-firmware
-iwl6000-firmware
-iwl3160-firmware
-iwl2000-firmware
-iwl135-firmware
%end


%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy ${build_username} --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%addon org_fedora_oscap
content-type = scap-security-guide
profile = xccdf_org.ssgproject.content_profile_stig
%end

%post
echo "${build_username} ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers

cat <<EOF >>/etc/cloud/cloud.cfg
ssh_pwauth: true
EOF

sudo ln -s /usr/local/bin/cloud-init /usr/bin/cloud-init
for svc in cloud-init-local.service cloud-init.service cloud-config.service cloud-final.service; do
  sudo systemctl enable $svc
  sudo systemctl start  $svc
done

cloud-init init --local
cloud-init init
cloud-init modules --mode=config
cloud-init modules --mode=final
cloud-init clean --logs --machine-id --reboot

%end

reboot
