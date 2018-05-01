Name:           os
Version:        0.0.0
Release:        0.1%{?dist}
Summary:        Fowarding script for immutable system management

License:        GPLv2+
URL:            https://github.com/projectatomic/os-command
Source0:        os-%{version}.tar.gz

Buildarch:      noarch
Requires:       rpm-ostree
Requires:       origin-clients

%description
Fowarding script for immutable system management. This script
intercepts yum, atomic, and dnf.

%prep
%autosetup


%build
# Nothing to build

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/%{_bindir}
install os $RPM_BUILD_ROOT/%{_bindir}/os
ln -s %{_bindir}/os $RPM_BUILD_ROOT/%{_bindir}/yum
ln -s %{_bindir}/os $RPM_BUILD_ROOT/%{_bindir}/atomic
ln -s %{_bindir}/os $RPM_BUILD_ROOT/%{_bindir}/dnf


%files
%license LICENSE
#%doc README.md
%{_bindir}/os
%{_bindir}/yum
%{_bindir}/dnf
%{_bindir}/atomic


%changelog
* Mon Apr 30 2018 Steve Milner <smilner@redhat.com> - 0.0.0-0.1
- Initial spec
- 
