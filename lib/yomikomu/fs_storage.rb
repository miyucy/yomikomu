require_relative 'basic_storage'

module Yomikomu
  class FSStorage < BasicStorage
    def initialize
      super
      require 'fileutils'
      @dir = YOMIKOMU_PREFIX + "files"
      FileUtils.mkdir_p(@dir) unless File.directory?(@dir)
    end

    def remove_compiled_iseq fname
      iseq_key = iseq_key_name(fname)
      if File.exist?(iseq_key)
        Yomikomu.debug { "rm #{iseq_key}" }
        File.unlink(iseq_key)
      end
    end

    private

    if YOMIKOMU_GZ
      def iseq_key_name(fname)
        "#{fname}.yarb.gz" # same directory
      end
    else
      def iseq_key_name(fname)
        "#{fname}.yarb" # same directory
      end
    end

    def compiled_iseq_exist?(fname, iseq_key)
      File.exist?(iseq_key)
    end

    def compiled_iseq_is_younger?(fname, iseq_key)
      File.mtime(iseq_key) >= File.mtime(fname)
    end

    if YOMIKOMU_GZ
      def read_compiled_iseq(fname, iseq_key)
        Zlib.inflate File.binread(iseq_key)
      end

      def write_compiled_iseq(fname, iseq_key, binary)
        File.binwrite(iseq_key, Zlib.deflate(binary, YOMIKOMU_GZ_LEVEL))
      end
    else
      def read_compiled_iseq(fname, iseq_key)
        File.binread(iseq_key)
      end

      def write_compiled_iseq(fname, iseq_key, binary)
        File.binwrite(iseq_key, binary)
      end
    end

    def remove_all_compiled_iseq
      raise "unsupported"
    end
  end
end
