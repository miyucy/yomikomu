require_relative 'fs_storage'

module Yomikomu
  class FS2Storage < FSStorage
    if YOMIKOMU_GZ
      def iseq_key_name(fname)
        File.join(@dir, fname.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord } + '.yarb.gz') # special directory
      end
    else
      def iseq_key_name(fname)
        File.join(@dir, fname.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord } + '.yarb') # special directory
      end
    end

    def remove_all_compiled_iseq
      Dir.glob(File.join(@dir, '**/*{.yarb,.yarb.gz}')) { |path|
        Yomikomu.debug { "rm #{path}" }
        FileUtils.rm(path)
      }
    end
  end
end
