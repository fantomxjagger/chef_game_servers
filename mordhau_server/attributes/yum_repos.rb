default['mordhau']['yum_repos'] = {
  'rpmfusion-free-updates': {
    name: 'RPM Fusion for EL 7 - Free - Updates',
    enabled: true,
    gpgcheck: true,
    gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-7',
    mirrorlist: 'http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-7&arch=$basearch'
  },
  'rpmfusion-free-updates-debuginfo': {
    name:  'RPM Fusion for EL 7 - Free - Updates Debug',
    enabled:  false,
    gpgcheck:  true,
    gpgkey:  'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-7',
    mirrorlist:  'http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-debug-7&arch=$basearch'
  },
  'rpmfusion-free-updates-source': {
    name:  'RPM Fusion for EL 7 - Free - Updates Source',
    enabled:  false,
    gpgcheck:  true,
    gpgkey:  'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-7',
    mirrorlist:  'http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-source-7&arch=$basearch'
  },
  'rpmfusion-nonfree-updates': {
    name:  'RPM Fusion for EL 7 - Nonfree - Updates',
    enabled:  true,
    gpgcheck:  true,
    gpgkey:  'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-7',
    mirrorlist:  'http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-7&arch=$basearch'
  },
  'rpmfusion-nonfree-updates-debuginfo': {
    name:  'RPM Fusion for EL 7 - Nonfree - Updates Debug',
    enabled:  false,
    gpgcheck:  true,
    gpgkey:  'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-7',
    mirrorlist:  'http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-debug-7&arch=$basearch'
  },
  'rpmfusion-nonfree-updates-source': {
    name:  'RPM Fusion for EL 7 - Nonfree - Updates Source',
    enabled:  false,
    gpgcheck:  true,
    gpgkey:  'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-7',
    mirrorlist:  'http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-source-7&arch=$basearch'
  }
}
