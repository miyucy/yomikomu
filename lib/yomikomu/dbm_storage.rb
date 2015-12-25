require_relative 'basic_storage'

module Yomikomu
  class DBMStorage < BasicStorage
    def initialize
      require 'dbm'
      @db = DBM.open(YOMIKOMU_PREFIX + 'db')
    end

    def remove_compiled_iseq(fname)
      @db.delete fname
    end

    private

    def date_key_name(fname)
      "date.#{fname}"
    end

    def iseq_key_name(fname)
      "body.#{fname}"
    end

    def compiled_iseq_exist?(fname, iseq_key)
      @db.has_key? iseq_key
    end

    def compiled_iseq_is_younger?(fname, iseq_key)
      date_key = date_key_name(fname)
      if @db.has_key? date_key
        @db[date_key].to_i >= File.mtime(fname).to_i
      end
    end

    def read_compiled_iseq(fname, iseq_key)
      @db[iseq_key]
    end

    def write_compiled_iseq(fname, iseq_key, binary)
      date_key = date_key_name(fname)
      @db[iseq_key] = binary
      @db[date_key] = Time.now.to_i
    end
  end
end
