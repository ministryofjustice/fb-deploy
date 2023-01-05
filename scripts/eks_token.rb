namespace = ARGV[0]

exit 1 if namespace.nil?

secrets = `kubectl get secrets -n #{namespace}`
secrets.split(' ').each do |element|
  if element.start_with?('circleci-formbuilder')
    puts element

    user_input = STDIN.gets.chomp

    if user_input == 'y'
      `kubectl delete secret -n formbuilder-platform-test-dev #{element}`

      sleep(5)

      secrets = `kubectl get secrets -n #{namespace}`
      secrets.split(' ').each do |element|
        if element.start_with?('circleci-formbuilder')
          puts "***************************"
          puts "your new secret is"
          puts 'variable name ->'
          puts 'EKS_TOKEN_' + namespace.split('-')[2..].map(&:upcase).join('_')
          puts 'variable value  ->'
          puts `kubectl get secrets -n #{namespace} #{element} -o jsonpath="{.data.token}"`
          puts "***************************"
        end
      end
    else
      puts 'goodbye'
      exit 0
    end
  end
end

