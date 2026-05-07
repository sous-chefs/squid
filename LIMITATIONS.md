# Limitations

## Package Availability

Squid is installed from operating-system package repositories. This cookbook does not configure an
upstream Squid repository or build Squid from source.

### APT (Debian/Ubuntu)

* Debian 12 (Bookworm): `squid` 5.x packages are available from Debian repositories on the standard Debian architectures.
* Debian 13 (Trixie): `squid` 6.x packages are available from Debian repositories on the standard Debian architectures.
* Ubuntu 22.04 (Jammy): `squid` 5.x packages are available from Ubuntu repositories on the standard Ubuntu architectures.
* Ubuntu 24.04 (Noble): `squid` packages are available from Ubuntu repositories on the standard Ubuntu architectures.

### DNF/YUM (RHEL family)

* RHEL-compatible distributions use their distribution package repositories. Squid upstream notes that newer third-party RHEL packages may exist, but they are unofficial.
* AlmaLinux, Rocky Linux, Oracle Linux, and RHEL 8/9/10 are viable only where the distribution provides a `squid` package in enabled repositories.
* Amazon Linux 2023 is viable only where the distribution provides a `squid` package in enabled repositories.

### Zypper (SUSE)

* openSUSE Leap 15.6 reached EOL on 2026-04-30. Leap 16.0 is the current Leap line as of 2026-05-07, but the `dokken/opensuse-leap-16` image does not exist, so this migration does not claim openSUSE Leap support until the package and Dokken image paths are verified.

### FreeBSD

* FreeBSD packages and ports provide `squid`; package layout uses `/usr/local/etc/squid` and `/var/squid/cache`.

## Architecture Limitations

* Package architectures are inherited from each operating system repository.
* The cookbook has no source-build path for filling architecture gaps.

## Source/Compiled Installation

Squid can be compiled from official source tarballs or the upstream GitHub repository, but this
cookbook does not implement compiled installation. Building from source requires platform-specific
compiler, make, dependency, and configure option handling.

## Known Issues

* Dokken testing covers Linux systemd containers only. FreeBSD remains a metadata-supported platform but is not covered by the required Dokken gate.
* openSUSE Leap 16 is not tested or declared as supported because no matching Dokken image is published.
* LDAP authentication helper paths vary by distribution and Squid version. Override `ldap_program` when the package layout differs from the default.
* Cache initialization runs `squid -Nz` only when `enable_cache_dir true`.

## Research Sources

* Squid upstream Debian and Ubuntu knowledge base pages document distro packages and Debian/Ubuntu layout.
* Squid upstream Red Hat and Fedora knowledge base pages document RPM package and compile options.
* Squid upstream FreeBSD knowledge base and FreshPorts document FreeBSD package names and filesystem layout.
* endoflife.date was used on 2026-05-07 to remove EOL platform test targets.
