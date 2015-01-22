require_relative './file_model'

module Spirit

  class Log < FileModel

    def initialize(name)
      @name = name
      @ext = '.log'
      @path = File.join(self.class.path, name+@ext)
    end

    def rotate!
      if File.exists? @path
        rotated_log = File.join(self.class.path, 'rotate', name+@ext)

        # Rotate old log if necessary
        if File.exists? rotated_log
          i = 0

          while File.exists? File.join(self.class.path, 'rotate', @name + '.' + i + @ext)
            i = i.next
          end

          next_log_name = File.join(self.class.path, 'rotate', @name + '.' + i + @ext)

          File.rename(rotated_log, next_log_name)
        end

        # Now rotate existing log to rotate/serial.log
        File.rename(@path, rotated_log)
      end
    end

  end

end