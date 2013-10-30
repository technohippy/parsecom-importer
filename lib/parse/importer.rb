require 'tmpdir'
require 'fileutils'
require 'securerandom'
require 'tempfile'
require 'open-uri'
require 'zipruby'
require 'parsecom'
require 'parse/importer/version'
require 'parse/importer/store'

module Parse
  module Importer
    module_function

    def unzip zipname
      output = Dir.tmpdir
      Zip::Archive.open zipname do |archives|
        archives.each do |archive|
          filename = File.join output, archive.name
          FileUtils.mkdir_p File.dirname(filename)
          unless archive.directory?
            File.open filename, 'w+b' do |file|
              file.print archive.read
            end
          end
        end
      end
      File.join output, File.dirname(zipname)
    end

    def import dirname, credentials=nil
      if File.file? dirname
        unless File.extname(dirname) == '.zip'
          raise ArgumentError.new('should be a zip file or a directory')
        end
        dirname = unzip dirname
      end

      Parse.credentials credentials if credentials
      store = Parse::Importer::Store.new dirname
      store.save
    end
  end
end
