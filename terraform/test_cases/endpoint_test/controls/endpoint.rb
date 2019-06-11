title 'endpoint connectivity test'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

web_endpoint = params['web_address']['value']
# execute test
describe host("#{web_endpoint}", port: 80, proto: 'tcp') do
    it { should be_reachable }
end
