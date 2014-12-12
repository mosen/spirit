# Developer Notes #

Mostly notes to myself.

- DNSSD registration so that Admin/Assistant show the spirit server as valid deploystudio hosts on the local subnet

Bootup checklist:

- GET /user/get/credentials?uid=admin (w/ http basic auth supplied)
Response: See stub method on user controller.
- GET /server/get/info
Response: Mostly valid in class Spirit::Server
- GET /configuration/get/repository?client_ip=x.x.x.x
Response: Mostly static returned by Spirit::Repository.make
- GET /workflows/get/all?id=(SERIAL)&groups=(null)
Response: Hash of workflow.plist - workflow content
- GET /computers/get/entry?sn=(SERIAL)&mac=(MAC)&populate=yes - Create computer entry


Status updates:
POST /computers/status/set/entry?id=(SERIAL)&tag=DSRemoteStatusHostInformation


Assistant Configuration Checklist:


Replica Checklist:

- Replica authenticates to master
- Replica gets information about Repository configuration by requesting /configuration/get/repository?client_ip=my.ip
- Replica replicates repository by mounting afp (probably mount_smb or nfs if the repo is hosted via those protocols)
and simply copies the contents to the locally specified repository.
- Sync has to run on a schedule
- Make a rake task to force sync from master