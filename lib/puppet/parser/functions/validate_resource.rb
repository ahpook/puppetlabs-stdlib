#
# validate_resource
#

module Puppet::Parser::Functions
  newfunction(:validate_resource, :type => :statement, :doc => <<-EOS
    EOS
  ) do |arguments|
 
    require 'kwalify'

    if (arguments.size != 0) then
      raise(Puppet::ParseError, "validate_resource(): Wrong number of arguments "+
        "given #{arguments.size} for 0")
    end


    classhash = to_hash(recursive=false)
    sourcepath = source.file
    schemapath = sourcepath.gsub(/\.(rb|pp)$/, ".schema")
    schema = Kwalify::Yaml.load_file(schemapath)
    validator = Kwalify::Validator.new(schema)
    errors = validator.validate(classhash)

    if errors && !errors.empty?
      error_output = "Resource validation failed:\n"
      for e in errors
        error_output += "[#{e.path}] #{e.message}\n"
      end
      raise(Puppet::ParseError, error_output)
    end

  end
end

# vim: set ts=2 sw=2 et :
