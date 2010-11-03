module Nimod
  class Store
    def initialize(client=Redis.connect, group='nasa-images-of-the-day')
      @store = client
      @group = group
    end

    attr_reader :store
    attr_accessor :group, :auto_serialize

    def put(key, data)
      @store.set key, data
      @store.sadd group, key
    end

    def get(key)
      @store.get(key)
    end

    def [](key)
      self.get(key)
    end

    def exists?(key)
      return false unless self.get(key)
      true
    end

    def size
      @redis.scard group
    end

    def random
      self.get(@store.srandmember(group))
    end

    def last
      self.get(@store.sort(group, :limit => [0, 1], :order => 'desc alpha'))
    end

    def first
      self.get(@store.sort(group, :limit => [0, 1], :order => 'asc alpha'))
    end
  end
end

