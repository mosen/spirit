## Spirit

A multi-platform DeployStudio server replacement. **HEAVILY IN DEVELOPMENT AKA BROKEN**

## Motivation

While the DeployStudio "suite" is an excellent set of tools for imaging, particularly in osx environments,
the server component isn't portable. Many in the admin community are going towards services which can be virtualised
in favour of osx infrastructure that is bound to non-virtualised apple hardware platforms.

## Installation

- Clone the repo into any directory you like. If you have an existing __DocumentRoot__ directory, this may be suitable.
- Install `ruby` if you haven't already.
- Install `bundler`
- Run `bundle install` from this directory to deal with Gem dependencies.
- Run the rake task to create a repository (or copy yours from DS)

        $ rake spirit:repo

- You can run `rackup` from this directory to run a temporary test service.

## API Reference

For the moment you will have to read the code for information on the API or detailed troubleshooting (sorry).

## Tests

No tests currently exist. RSpec may be employed later.

## Contributors

Mosen <mosen@github.com>

## License

This project is MIT licensed.

## Todo

+ Security: Make sure filenames cannot be read outside of repo base directory
+ Access groups not implemented
+ *future* User account and repository passwords are stored by DS using `DES_encrypt_with_string`/`DES_ncbc_encrypt`.
Replicate storage method for those.
+ Use an actual authentication source that is user configurable.
+ Configuration profiles (does nothing)
+ Activity list (does nothing)
    + Use some db or in-memory persistence to track computer status. Maybe redis but
    consider not adding too many deps.
+ Computer list
    + get/entry?populate=YES should use the group parameters as defaults, and should call `Spirit::Computer.create`
    + Create group.settings.plist describing default group settings, use a template __DONE__
+ Logs (does nothing)
+ Files (does nothing)
+ Replica (does nothing)
+ Multicast (does nothing)
+ Scripts __100% Complete__
+ Masters
    - Ignore images that do not have a filesystem in the name
    - Flatten images which have multiple parts such as windows ntfs+BCD.
    - Write keywords.plist containing image index.
+ Packages
    - Size reported is incorrect.
    - Write Info.plist whenever /get/all index is created.
    - Bundles such as pkg/mpkg are not flattened.
    - Write Info.plist containing package index
+ Configuration stored locally in format similar or identical to DS
    - Multicast config
    - Notifications config
    - Repository config
    - Role
    - Security config
    - Version
+ Server configuration via DeployStudio Assistant
    - SSL options will not be honored, I cannot enumerate certificates because you could be using any httpd
    - Store server config outside of spirit.yml
    - Set listen port numbers
    - Reject computers not defined in computers list.
    - Honor assistant and admin group memberships.
    - Spirit needs ability to decode the password set by DS Assistant for the repo in order to supply it to the runtime.
    - Spirit does not re-read configuration after DS Assistant runs.