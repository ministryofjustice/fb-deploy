namespace = ARGV[0]
app_name = ARGV[1]

exit 1 if namespace.nil?
exit 1 if app_name.nil?

secrets = `kubectl get secrets -n #{namespace}`

secrets.split(' ').each do |element|
  if element.include?(app_name) && element.start_with?('formbuilder')
    puts element

    user_input = STDIN.gets.chomp

    if user_input == 'y'
      `kubectl delete secret -n formbuilder-platform-test-dev #{element}`

      sleep(5)

      secrets = `kubectl get secrets -n #{namespace}`

      secrets.split(' ').each do |element|
        if element.include?(app_name) && element.start_with?('formbuilder')
          puts "***************************"
          puts "your new secret is"
          puts 'variable name ->'
          puts 'EKS_BEARER_TOKEN_' + namespace.split('-')[2..].map(&:upcase).join('_')
          puts 'variable value  ->'
          puts element
          puts "***************************"
        end
      end
    else
      puts 'goodbye'
      exit 0
    end
  end
end

