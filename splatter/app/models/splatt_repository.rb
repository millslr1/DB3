class SplattRepository

  def initialize(client, user)
    @client = client
    @bucket = user.email
  end

  def save(splatt)
    splatts = @client.bucket(@bucket)
    key = splatt.id

    unless splatts.exists?(key)
      riak_obj = splatts.new(key)
      riak_obj.data = splatt
      riak_obj.content_type = 'application/json'
      riak_obj.store
    splatt
    end
  end

  def delete(key)
    splatts = @client.bucket(@bucket)
    if splatts.exists?(key)
       splatts.delete(key)
    end
  end
  def all
    keys = @client.bucket(@bucket).keys
    riak_list = @client.bucket(@bucket).get_many(keys)
    results = []
    riak_list.values.each do |splatt_obj|
      splatt = Splatt.new
      splatt.id = splatt_obj.data['id']
      splatt.body = splatt_obj.data['body']
      splatt.created_at = splatt_obj.data['created_at']
      splatt.updated_at = splatt_obj.data['updated_at']
      splatt.user = splatt_obj.data['user']
      results.push(splatt)
    end
    results
  end
end

