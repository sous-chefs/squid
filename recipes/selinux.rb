#
# Cookbook:: squid
# Recipe:: selinux
#
# Copyright:: 2013-2016, Chef Software, Inc
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

include_recipe 'selinux_policy::install'

selinux_policy_module 'squid' do
  content <<-eos
    module squid 1.0;

    require {
      type user_tmpfs_t;
      type squid_t;
      class file unlink;
    }

    #============= squid_t ==============
    allow squid_t user_tmpfs_t:file unlink;
  eos
  action :deploy
end
