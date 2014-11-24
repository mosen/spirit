# Developer Notes #

Mostly notes to myself.

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
