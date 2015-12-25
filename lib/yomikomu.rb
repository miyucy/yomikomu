require "yomikomu/version"

module Yomikomu
  STATISTICS = Hash.new(0)

  unless yomu_dir = ENV['YOMIKOMU_STORAGE_DIR']
    yomu_dir = File.expand_path("~/.ruby_binaries")
    Dir.mkdir(yomu_dir) unless File.exist?(yomu_dir)
  end
  YOMIKOMU_PREFIX = "#{yomu_dir}/cb."
  YOMIKOMU_AUTO_COMPILE = ENV['YOMIKOMU_AUTO_COMPILE'] == 'true'
  YOMIKOMU_USE_MMAP = ENV['YOMIKOMU_USE_MMAP']
  require_relative 'yomikomu/mmap_string'

  YOMIKOMU_GZ = ENV['YOMIKOMU_GZ'] == 'true'
  if YOMIKOMU_GZ
    require 'zlib'
    YOMIKOMU_GZ_LEVEL = Integer(ENV.fetch('YOMIKOMU_GZ_LEVEL', Zlib::DEFAULT_COMPRESSION))
  end

  if $VERBOSE
    def self.info
      STDERR.puts "[YOMIKOMU:INFO] (pid:#{Process.pid}) #{yield}"
    end
    at_exit do
      STDERR.puts "[YOMIKOMU:INFO] (pid:#{Process.pid}) " + ::Yomikomu::STATISTICS.map { |k, v| "#{k}: #{v}" }.join(' ,')
    end
  else
    def self.info
    end
  end

  if ENV['YOMIKOMU_DEBUG'] == 'true'
    def self.debug
      STDERR.puts "[YOMIKOMU:DEBUG] (pid:#{Process.pid}) #{yield}"
    end
  else
    def self.debug
    end
  end

  def self.compile_and_store_iseq(fname)
    STORAGE.compile_and_store_iseq(fname)
  end

  def self.remove_compiled_iseq(fname)
    STORAGE.remove_compiled_iseq(fname)
  end

  def self.remove_all_compiled_iseq
    STORAGE.remove_all_compiled_iseq
  end

  def self.verify_compiled_iseq(fname)
    STORAGE.verify_compiled_iseq(fname)
  end

  # select storage
  STORAGE = case ENV['YOMIKOMU_STORAGE']
            when 'dbm'
              require_relative 'yomikomu/dbm_storage'
              DBMStorage.new
            when 'fs2'
              require_relative 'yomikomu/mmap_string'
              require_relative 'yomikomu/fs2_storage'
              FS2Storage.new
            when 'null'
              require_relative 'yomikomu/null_storage'
              NullStorage.new
            else
              require_relative 'yomikomu/mmap_string'
              require_relative 'yomikomu/fs_storage'
              FSStorage.new
            end

  Yomikomu.info { "[RUBY_YOMIKOMU] use #{STORAGE.class}" }
end

class RubyVM::InstructionSequence
  def self.load_iseq(fname)
    ::Yomikomu::STORAGE.load_iseq(fname)
  end
end
