python_pip "carbon" do
  version node["graphite"]["version"]
  options %Q{--install-option="--prefix=#{node['graphite']['home']}" --install-option="--install-lib=#{node['graphite']['home']}/lib"}
  action :install
end

python_pip "zope.interface" do
  action :install
  only_if { node['platform_family'] == "rhel" }
end

template "/etc/init/carbon-cache.conf" do
  mode "0644"
  source "carbon-cache.conf.erb"
  variables(
    :home => node["graphite"]["home"],
    :version => node["graphite"]["version"]
  )
end

service "carbon-cache" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end

template "#{node['graphite']['home']}/conf/carbon.conf" do
  mode "0644"
  source "carbon.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  variables(
    :whisper_dir                => node["graphite"]["carbon"]["whisper_dir"],
    :line_receiver_interface    => node["graphite"]["carbon"]["line_receiver_interface"],
    :pickle_receiver_interface  => node["graphite"]["carbon"]["pickle_receiver_interface"],
    :cache_query_interface      => node["graphite"]["carbon"]["cache_query_interface"],
    :log_updates                => node["graphite"]["carbon"]["log_updates"]
  )

  notifies :restart, resources(:service => "carbon-cache")
end

template "#{node['graphite']['home']}/conf/storage-schemas.conf" do
  mode "0644"
  source "storage-schemas.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, resources(:service => "carbon-cache")
end

template "#{node['graphite']['home']}/conf/storage-aggregation.conf" do
  mode "0644"
  source "storage-aggregation.conf.erb"
  owner node["apache"]["user"]
  group node["apache"]["group"]
  notifies :restart, resources(:service => "carbon-cache")
end

execute "chown" do
  command "chown -R #{node["apache"]["user"]}:#{node["apache"]["group"]} #{node["graphite"]["storage_dir"]}"
  only_if do
    f = File.stat("#{node['graphite']['storage_dir']}")
    f.uid == 0 && f.gid == 0
  end
end

logrotate_app "carbon" do
  cookbook "logrotate"
  path "#{node['graphite']['storage_dir']}/log/carbon-cache/carbon-cache-a/*.log"
  frequency "daily"
  rotate 7
  create "644 root root"
end
