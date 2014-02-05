# Repository directory structure
task :repository do |t|
  directory "ds_repo"
  directory "ds_repo/ConfigurationProfiles"
  directory "ds_repo/Databases"
  directory "ds_repo/Databases/ByHost"
  directory "ds_repo/Databases/Workflows"
  directory "ds_repo/Files"
  directory "ds_repo/Logs"
  directory "ds_repo/Logs/Backup"
  directory "ds_repo/Masters"
  directory "ds_repo/Masters/DEV" # linux dd
  directory "ds_repo/Masters/FAT"
  directory "ds_repo/Masters/HFS" # asr dmg
  directory "ds_repo/Masters/NTFS" # ntfs images
  directory "ds_repo/Masters/PC"
  directory "ds_repo/Masters/tmp"
  directory "ds_repo/Packages"
  directory "ds_repo/Scripts"
end
