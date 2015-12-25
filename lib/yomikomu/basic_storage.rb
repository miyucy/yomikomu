module Yomikomu
  class BasicStorage
    def initialize
      require 'digest/sha1'
    end

    def load_iseq(fname)
      iseq_key = iseq_key_name(fname)

      if compiled_iseq_exist?(fname, iseq_key) && compiled_iseq_is_younger?(fname, iseq_key)
        ::Yomikomu::STATISTICS[:loaded] += 1
        ::Yomikomu.debug { "load #{fname} from #{iseq_key}" }
        binary = read_compiled_iseq(fname, iseq_key)
        iseq = RubyVM::InstructionSequence.load_from_binary(binary)
        # p [extra_data(iseq.path), RubyVM::InstructionSequence.load_from_binary_extra_data(binary)]
        # raise unless extra_data(iseq.path) == RubyVM::InstructionSequence.load_from_binary_extra_data(binary)
        iseq
      elsif YOMIKOMU_AUTO_COMPILE
        compile_and_store_iseq(fname, iseq_key)
      else
        ::Yomikomu::STATISTICS[:ignored] += 1
        ::Yomikomu.debug { "ignored #{fname}" }
        nil
      end
    end

    def extra_data(fname)
      "SHA-1:#{::Digest::SHA1.file(fname).digest}"
    end

    def compile_and_store_iseq(fname, iseq_key = iseq_key_name(fname))
      ::Yomikomu::STATISTICS[:compiled] += 1
      ::Yomikomu.debug { "[RUBY_COMPILED_FILE] compile #{fname} into #{iseq_key}" }
      iseq = RubyVM::InstructionSequence.compile_file(fname)

      binary = iseq.to_binary(extra_data(fname))
      write_compiled_iseq(fname, iseq_key, binary)
      iseq
    end

    # def remove_compiled_iseq fname; nil; end # should implement at sub classes

    private

    def iseq_key_name fname
      fname
    end

    # should implement at sub classes
    # def compiled_iseq_younger? fname, iseq_key; end
    # def compiled_iseq_exist? fname, iseq_key; end
    # def read_compiled_file fname, iseq_key; end
    # def write_compiled_file fname, iseq_key, binary; end
  end
end
