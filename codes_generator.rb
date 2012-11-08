# encoding utf-8

require "rubygems"
require "json"
 
def from_json
  return JSON.parse self
end
public :from_json

def to_json
  return JSON.generate self
end
public :to_json

def generate_configuration
  hash = Hash.new
  hash["count"]   = 42
  hash["length"]  = 15
  hash["prefix"]  = "FOO-"
  hash["postfix"] = "-BAR"
  hash["symbols"] = ("A".."Z").to_a + (0..9).to_a
  return hash.to_json
end
public :generate_configuration

def from_file
  return IO.read self
end
public :from_file

def to_file filename
  File.open(filename, "w"){|result| result.write self}
end
public :to_file

  
CONFIGURATIONFILENAME = ARGV[0]

abort "Usage: ruby #{$PROGRAM_NAME} configuration_file\nIf configuration file does not exist, it is created on the basis of the template." if CONFIGURATIONFILENAME == nil
abort "Configuration file #{CONFIGURATIONFILENAME} generated." if generate_configuration.to_file CONFIGURATIONFILENAME if !File.exist? CONFIGURATIONFILENAME
configuration = CONFIGURATIONFILENAME.from_file.from_json

abort "ERROR: invalid count in #{CONFIGURATIONFILENAME}" if (COUNT = configuration["count"]).class != Fixnum
PREFIX  = configuration["prefix"]
POSTFIX = configuration["postfix"]
LENGTH  = configuration["length"] - PREFIX.length - POSTFIX.length
SYMBOLS = configuration["symbols"]
  
abort "ERROR: Combinations of codes less than the count of codes, it is bad, very very bad." if SYMBOLS.size ** LENGTH < COUNT

out = Array.new
  
while out.size != COUNT do
  code = PREFIX + (1..LENGTH).map{|n| SYMBOLS.choice}.to_s + POSTFIX
  out.push code if out.find_all{|elem| elem == code}.size == 0
end
  
$stdout.write out.map{|n| n + "\n"}
