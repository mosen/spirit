## Spirit

A multi-platform DeployStudio server replacement. **HEAVILY IN DEVELOPMENT AKA BROKEN**
My old repository has been tagged 1.6.3a, this was the version in development against DeployStudio 1.6.3

## Motivation

While the DeployStudio "suite" is an excellent set of tools for imaging, particularly in osx environments,
the server component isn't portable. Many in the admin community are going towards services which can be virtualised
in favour of osx infrastructure that is bound to non-virtualised apple hardware platforms.

## Installation

- Install `ruby` if you haven't already. Preferably v2.x, but minimum is 1.9.3 per Padrino requirement.
- Install `bundler` using RubyGems:

        $ gem install bundler

- Clone this repository into the directory where you want to serve spirit from. (such as `/var/www`).
- Run `bundle install` from this directory to deal with Gem dependencies.
- Run the rake task to create a repository (or copy yours from DS).

        $ rake spirit:repo

- Copy `app/config/server.dist.yml` to `app/config/server.yml` and adjust config. The repository url and
credentials will have to be changed at minimum.
- Copy `app/config/spirit.dist.yml` to `app/config/spirit.yml` and adjust config. You may want to change DS Admin
authentication here.
- Run the database schema migrations to create tables used for the activity list:

        $ rake ar:migrate

- Run `rackup` to start a built-in web server, or configure with your web service of choice (Apache/Passenger,
Nginx/Unicorn etc...)

## API Reference

For the moment you will have to read the code for information on the API or detailed troubleshooting (sorry).
The server is based on the [padrino](http://www.padrinorb.com/) framework .

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
    - SSL options will not be honored, I cannot enumerate certificates because you could be using any httpd.
      - How can we realistically configure Spirit to start up under WEBrick/thin/passenger/unicorn with SSL
    - Set listen port numbers
    - Reject computers not defined in computers list.
    - Honor assistant and admin group memberships.
    - Spirit needs ability to decode the password set by DS Assistant for the repo in order to supply it to the runtime.
    - Spirit does not re-read configuration after DS Assistant runs.
+ Zeroconf/Bonjour announcement of service `_deploystudio._tcp`.

### Modules

#### Configuration Profiles

+ Currently only returns a static empty list.

#### Activity

+ Host status is inserted only, but there is no functionality to query the status or ensure the uniqueness of
the serial number.

#### Computers

+ in get/entry?populate=YES, `Spirit::Computer.create` should cause the computer to inherit settings from any group
marked as default.
+ need to test the case where a computer is populated without group membership, which keys are defaulted?
+ Newly populated computer records do not respect the group setting for starting integer and number precision.
+ Incomplete tests.
+ Most actions assume that the serial number is the primary key, when it should be determined based upon the
repository setting.
+ Cannot import computer records

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
