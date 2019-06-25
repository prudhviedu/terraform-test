# encoding: utf-8
# copyright: 2018, The Authors
# load data from terraform output
content = inspec.profile.file("storage_info.json")
params = JSON.parse(content)

MOUNT1_POINT = params['mount1']['point']
MOUNT1_DEVICE = params['mount1']['device']
MOUNT1_TYPE = params['mount1']['type']
#MOUNT1_OPTIONS = params['mount1']['OPTIONS']
describe mount(MOUNT1_POINT) do
  it { should be_mounted }
  its('device') { should eq  MOUNT1_DEVICE }
  its('type') { should eq  MOUNT1_TYPE }
#  its('options') { should eq [MOUNT1_OPTIONS] }
end
