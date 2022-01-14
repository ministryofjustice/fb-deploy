# Usage
# ruby ./bin/scale_replicas.rb <namespace> <replicas>

IGNORE = [
  'NAME',
  'READY',
  'UP-TO-DATE',
  'AVAILABLE',
  'AGE'
]

namespace = ARGV[0]
replicas = ARGV[1]

if namespace.nil?
  puts 'Namespace is required'
  exit
end

if replicas.nil?
  puts 'Number of replicas is requried'
  exit
end

deployments = `kubectl get deployments -n #{namespace}`

deployments.split("\n").each do |line|
  deployment = line.split.first
  next if IGNORE.include?(deployment) || deployment.include?('acceptance-tests')

  puts "Scaling #{deployment} to #{replicas}"
  `kubectl scale deployment #{deployment} --replicas=#{replicas} -n #{namespace}`
end
