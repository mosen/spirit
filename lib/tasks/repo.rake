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

namespace :spirit do

  desc "Create empty repository in ./ds_repo"
  task :repo => %w{
      ds_repo
      ds_repo/ConfigurationProfiles
      ds_repo/Databases
      ds_repo/Databases/ByHost
      ds_repo/Databases/Workflows
      ds_repo/Files
      ds_repo/Logs
      ds_repo/Logs/Backup
      ds_repo/Masters
      ds_repo/Masters/DEV
      ds_repo/Masters/FAT
      ds_repo/Masters/HFS
      ds_repo/Masters/NTFS
      ds_repo/Masters/PC
      ds_repo/Masters/tmp
      ds_repo/Packages
      ds_repo/Scripts
  }

end


