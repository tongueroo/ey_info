require File.expand_path("../test_helper", __FILE__)

class SchemaTransformerTest < Test::Unit::TestCase
  def setup
    @info = Ey::Info.new
  end
  
  def test_sanity
    @info.hosts.class == Hash
  end

  def test_envs
    @info.envs == Hash
  end
end