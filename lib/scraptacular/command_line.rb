# http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParserr.html
require 'optparse'
require 'json'

module Scraptacular
  class CommandLine
    def initialize
      parse_options

      at_exit do
        next unless $!.nil? || $!.kind_of?(SystemExit)

        status = run(options).to_i
        exit status if status != 0
      end
    end

    def load_file(file_name)
    end

    def options
      @options ||= {}
    end

    def parse_options
      @options = {}

      OptionParser.new do |parser|
        parser.banner = "Usage: scraptacular -d DEFINITION_FILE -s SESSION_FILE"

        parser.on('-d', '--definition-file DEFINITION_FILE', 'Specify a file container scraper definitions') do |file|
          @options[:definition_file] = file
        end
        parser.on('-s','--session-file SESSION_FILE','Specify groups, suites, and URLs to be scraped') do |file|
          @options[:session_file] = file
        end
        parser.on('-o','--output-file [OUTPUT_FILE]', 'Scrape result output file. Only useful for text output') do |file|
          @options[:output_file] = file
        end

        parser.on('-g GROUP', '--group', 'Specify a single group to scrape') do |group|
          @options[:only_group] = group
        end

        parser.on('-f', '--format [FORMAT]', 'only "json" is supported') do |format|
          @options[:format] = "json"
        end
        
        parser.on_tail('-h','--help','The help file') do
          puts parser
          exit
        end
      end.parse!
    end

    def run(options, out = $stdout)
      return 1 unless (validate_file(options[:definition_file], "definition file", out)  &&
                      validate_file(options[:session_file], "session file", out) )

      res = Scraptacular.world.run(options)

      #TODO: Replace with "Formatters" e.g. JSONFormatter, XMLFormatter, whatever
      if options[:format] == "json"  
        res.each do |group, suites|
          suites.each do |suite, results|
            suites[suite] = results.map!(&:to_h)
          end
        end

        res = res.to_json
      end

      # TODO : Replace with "Outputters". 
      if options[:output_file]
        File.open(options[:output_file], 'w') { |file| file.write(res) }
      else
        out.puts res
      end

      return 0
    end

    def validate_file(file_name, caption, out)
      if file_name.nil?
        out.puts "You must specify a #{caption}. See --help for more information"
        return false
      else
        if File.exists?(file_name)
          load file_name
          return true
        else
          out.puts "The #{caption} specified does not exist: #{file_name}"
          return false
        end

      end
    end
  end
end

