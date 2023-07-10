fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build_app_for_simulator

```sh
[bundle exec] fastlane ios build_app_for_simulator
```

Build simulator app

### ios build_for_ios

```sh
[bundle exec] fastlane ios build_for_ios
```

Build real device app

### ios zip_simulator_bin

```sh
[bundle exec] fastlane ios zip_simulator_bin
```

Archiving the binary app

### ios appcenter_upload_sim_app

```sh
[bundle exec] fastlane ios appcenter_upload_sim_app
```

Upload the simulator app to app center

### ios appcenter_upload_app

```sh
[bundle exec] fastlane ios appcenter_upload_app
```

Upload the real app to app center

### ios make_ios_cert

```sh
[bundle exec] fastlane ios make_ios_cert
```

Create ios certificate

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).


