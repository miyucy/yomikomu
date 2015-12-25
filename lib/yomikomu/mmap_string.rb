module Yomikomu
  if Yomikomu::YOMIKOMU_USE_MMAP
    require 'mmapped_string'
    Yomikomu.info { "[RUBY_YOMIKOMU] use mmap" }

    module MMapFile
      def read_compiled_iseq(fname, iseq_key)
        MmappedString.open(iseq_key)
      end
    end

    require_relative 'fs_storage'
    class FSStorage
      prepend MMapFile
    end

    require_relative 'fs2_storage'
    class FS2Storage
      prepend MMapFile
    end
  end
end
