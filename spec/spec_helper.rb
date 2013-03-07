require 'simplecov'
SimpleCov.start

require 'scraptacular'

RSpec.configure do |config|

  # Redirect the programs output elsewhere
  # See : https://gist.github.com/adamstegman/926858  
  config.before :all do
    @orig_stderr = $stderr
    @orig_stdout = $stdout

    # redirect stderr and stdout to /dev/null
    $stderr = File.new('/dev/null', 'w')
    $stdout = File.new('/dev/null', 'w')  
  end

  config.after :all do
    $stderr = @orig_stderr
    $stdout = @orig_stdout
    @orig_stderr = nil
    @orig_stdout = nil
  end
end
