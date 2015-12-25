module Yomikomu
  class NullStorage
    def load_iseq fname; end
    def compile_and_store_iseq fname; end
    def remove_compiled_iseq fname; end
  end
end
