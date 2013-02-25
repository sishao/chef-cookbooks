include_recipe 'redisio::default'

case node.platform
when 'debian', 'ubuntu'
  package 'redis-server' do
    action :install
  end
when 'centos'
  include_recipe 'yum::epel'
end
