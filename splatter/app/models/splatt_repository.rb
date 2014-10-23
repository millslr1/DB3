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
      riak_obj.content_type = ’application/json’
      riak_obj.store
    splatt
  end


  def all
    keys = @client.bucket(@bucket).keys
    riak_list = @client.bucket(@bucket).get_many(keys)
    2
    results = []
    riak_list.values.each do |splatt_obj|
      splatt = Splatt.new
      splatt.id = splatt_obj.data[’id’]
      splatt.body = splatt_obj.data[’body’]
      splatt.created_at = splatt_obj.data[’created_at’]
      results.push(splatt)
    end
    results
  end
end

