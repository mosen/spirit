module Spirit

  class Repository

    class << self

      def make(uri, username, password)

        mount_command = {
            afp: '/sbin/mount_afp',
            smb: '/sbin/mount_smbfs',
            nfs: '/sbin/mount_nfs'
        }[uri.scheme]

        {
          'master_mount_command' => {
              'arguments' => [
                  '-o',
                  'nobrowse',
                  '%s://%s:%s@%s%s' % [uri.scheme, username, password, uri.hostname, uri.path],
                  '/tmp/DSMasterMount'
              ],
              'command' => '/sbin/mount_afp'
          },
          'mount_command' => {
              'arguments' => [
                  '-o',
                  'nobrowse',
                  '%s://%s:%s@%s%s' % [uri.scheme, username, password, uri.hostname, uri.path],
                  '/tmp/DSNetworkRepository'
              ],
              'command' => '/sbin/mount_afp'
          },
          'path_to_master_mount_point' => '/tmp/DSMasterMount',
          'path_to_master_repository' => '/tmp/DSMasterMount',
          'path_to_mount_point' => '/tmp/DSNetworkRepository',
          'path_to_repository' => '/tmp/DSNetworkRepository',
          'path_to_temporary_mount_point' => '/tmp/DSTemporaryMount',
          'path_to_temporary_repository' => '/tmp/DSTemporaryMount',
          'temporary_mount_command' => {
              'arguments' => [
                  '-o',
                  'nobrowse',
                  '%s://%s:%s@%s%s' % [uri.scheme, username, password, uri.hostname, uri.path],
                  '/tmp/DSTemporaryMount'
              ],
              'command' => '/sbin/mount_afp'
          },
          'type' => 'localtoserver',
          'url' => uri.to_s
        }
      end

    end

  end

end
