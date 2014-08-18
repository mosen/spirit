# Test Coverage

This file periodically updated with the `GET /` index of DeployStudio Server.
This is a big checklist of my testing status.

# GET methods:

## computers_spec.rb ##

- /computers/get/all
- /computers/get/entry
- /computers/set/entry
- /computers/del/entries

Not implemented:

- /computers/del/entry
- /computers/import/entries

## computers_groups_spec.rb ##

- /computers/groups/get/all
- /computers/groups/get/default
- /computers/groups/get/entry

- /computers/groups/del/default
- /computers/groups/del/entry
- /computers/groups/new/entry
- /computers/groups/ren/entry
- /computers/groups/set/default
- /computers/groups/set/entry

## computers_status_spec.rb ##

Not/Partially implemented:

- /computers/status/get/all
- /computers/status/set/entry

## configuration_spec.rb ##

- /configuration/get
- /configuration/get/repository

Not implemented:

- /configuration/set

## configurationprofiles_spec.rb ##

Partially Implemented:

- /configurationprofiles/get/all

## downloads_spec.rb (Wont be implemented) ##

- /downloads/DeployStudioServer.zip

## files_spec.rb ##

- /files/get/all

## logs_spec.rb ##

Not implemented:

- /logs/get/entry
- /logs/append/entry
- /logs/del/entry
- /logs/rotate/entry
- /logs/set/entry

## masters_spec.rb ##

Partially implemented:

- /masters/get/all

Not implemented:

- /masters/get/entry
- /masters/compress/entry
- /masters/del/entry
- /masters/ren/entry
- /masters/scan/entry
- /masters/set/entry
- /masters/workinprogress/finalize

## multicast_spec.rb ##

NOTE: May never be fully implemented due to ASR native tool requirement.

Not implemented:

- /multicast/join
- /multicast/release
- /multicast/status
- /multicast/stop

## packages_sets_spec.rb ##

- /packages/sets/get/all
- /packages/sets/get/entry
- /packages/sets/add/entry
- /packages/sets/new/entry
- /packages/sets/ren/entry

## packages_spec.rb ##

- /packages/get/all
- /packages/get/entry

Not implemented:

- /packages/del/entry
- /packages/set/entry

## replica_spec.rb ##

Not implemented:

- /replica/sync/all
- /replica/sync/stats

## scripts_spec.rb ##

- /scripts/get/all
- /scripts/get/entry
- /scripts/del/entry
- /scripts/ren/entry
- /scripts/set/entry

## server_spec.rb ##

- /server/get/stats

Not implemented:

- /server/get/date
- /server/get/info

## server_groups_spec.rb (Not Implemented) ##

- /server/groups/get
- /server/groups/get/all

## server_keys_spec.rb (Not Implemented) ##

- /server/keys/get/all

## user_spec.rb ##

- /user/get/credentials

## workflows_spec.rb ##

- /workflows/get/all
- /workflows/get/entry

Not implemented: 

- /workflows/del/entry
- /workflows/dup/entry
- /workflows/set/entry