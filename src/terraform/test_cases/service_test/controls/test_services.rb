title 'services run test'

# execute test
describe bash('ps -ef | grep sshd') do
  its('stdout') { should match '/usr/sbin/sshd -D' }
end
