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

- Read the config in `app/config/server.yml` and `app/config/spirit.yml`.
- You can run `rackup` from this directory to run a temporary test service.

## API Reference

For the moment you will have to read the code for information on the API or detailed troubleshooting (sorry).

## Tests

Run `padrino rake spec` in the project directory to run RSpec examples.

## Contributors

Mosen <mosen@github.com>

## License

This project is MIT licensed.

## Todo

### General

+ Split very large controllers.
+ Security: Make sure filenames cannot be read outside of repo base directory
+ Access groups not implemented
+ *future* User account and repository passwords are stored by DS using `DES_encrypt_with_string`/`DES_ncbc_encrypt`.
Replicate storage method for those.
+ Use an actual authentication source that is user configurable.
+ Server configuration via DeployStudio Assistant
    - SSL options will not be honored, I cannot enumerate certificates because you could be using any httpd
    - Set listen port numbers
    - Reject computers not defined in computers list.
    - Honor assistant and admin group memberships.
    - Spirit needs ability to decode the password set by DS Assistant for the repo in order to supply it to the runtime.
    - Spirit does not re-read configuration after DS Assistant runs.

### Modules

#### Configuration Profiles

+ Currently only returns a static empty list.

#### Activity

+ Currently does nothing at all.
    + Use some db or in-memory persistence to track computer status. Maybe redis but
    consider not adding too many deps.

#### Computers

+ in get/entry?populate=YES, `Spirit::Computer.create` should cause the computer to inherit settings from any group
marked as default.
+ Mock plist fails in RSpec examples.
+ Incomplete tests.

#### Logs

+ Some exceptions thrown when log rotate fails (verify?)
+ Incomplete tests.

#### Files

+ **Complete**

#### Replica

+ No functionality exists for replication

#### Multicast

+ No functionality exists for multicasting

#### Scripts

+ **Complete**

#### Masters

+ Ignore images that do not have a filesystem in the name
+ Flatten images which have multiple parts such as windows ntfs+BCD.
+ Write keywords.plist containing image index.

#### Packages

+ Incorrect size reported in admin ui.
+ Write Info.plist whenever /get/all index is created.
+ Bundles such as pkg/mpkg are not flattened correctly.
