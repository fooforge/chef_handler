#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef_handlers
# Recipe:: json_file
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# force resource actions in compile phase so exception handler 
# fires for compile phase exceptions

chef_handler "Chef::Handler::JsonFile" do
  source "chef/handler/json_file"
  arguments :path => '/var/chef/reports'
  action :nothing
end.run_action(:enable)

cron "Archive old chef-run reports" do
  minute "0"
  hour "1"
  day "1"

  command "find /var/chef/reports/ -name chef-run-report-`date -d '1 month ago' +\"%Y%m\"`*.json -type f | xargs tar -cjpf /var/chef/reports/reports-`date -d '1 month ago' +\"%Y%m\"`.tbz2 2>&1 /dev/null"

  only_if{File.directory?("/var/chef/reports")}
end