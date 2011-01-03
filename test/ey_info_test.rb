require File.expand_path("../test_helper", __FILE__)

class EyInfoTest < Test::Unit::TestCase
  def setup
    @info = EyInfo::Hosts.new
  end
  
  def test_all_hosts_hash
    # pp @info.all_hosts
    assert_equal @info.all_hosts.class, Hash
    assert @info.all_hosts.keys.include?(:beta)
  end
  
  def test_hosts_hash
    pp @info.hosts(:alpha)
    assert @info.hosts(:alpha).class, Array
  end

end