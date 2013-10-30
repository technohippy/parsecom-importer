module Parse
  module Importer
    class Store
      attr_reader :store

      def initialize dirname=nil
        @parse_class_table = {}
        @parse_object_table = {}
        @store = {}
        @relations = []
        load dirname if dirname
      end

      def load dirname
        Dir["#{dirname}/*"].each do |filepath|
          filename = filepath.sub(%r|#{dirname}/|, '')
          if filename =~ /^_Join:(.*):(.*).json$/
            column_name = $1
            parse_class_name = $2
            @relations << [filepath, column_name, parse_class_name]
          elsif filename =~ /^(.*).json$/
            parse_class_name = $1
            parse_class = Parse::Object(parse_class_name)
            rows = []
            results = JSON.parse File.read(filepath)
            results['results'].each do |data|
              rows << data
              @parse_class_table[data['objectId']] = parse_class
            end
            @store[parse_class_name] = rows
          end
        end
      end

      def new_object_id_from_old_one object_id
        @parse_object_table[object_id].objectId
      end

      def save
        create_blank_objects
        update_objects
        add_relations
      end

      def create_blank_objects
        @parse_class_table.each do |old_object_id, parse_class|
          parse_object = parse_class.new
          if parse_class.parse_class_name == '_User'
            parse_object.username = SecureRandom.uuid # temporary username
            parse_object.password = 'password'
          end
          parse_object.save
          @parse_object_table[old_object_id] = parse_object
          puts "#{parse_class.parse_class_name}(#{old_object_id}) has been created."
        end
      end

      def update_objects
        @store.each do |parse_class_name, rows|
          rows.each do |data|
            parse_object = @parse_object_table[data['objectId']]
            data.each do |k, v|
              if v.is_a? Hash
                case v['__type']
                when 'Pointer'
                  v['objectId'] = new_object_id_from_old_one v['objectId']
                when 'File'
                  open v['url'] do |filedata|
                    filepath = Tempfile.open 'temp' do |tempfile|
                      tempfile.write filedata.read
                      tempfile.path
                    end
                    name = File.basename(v['url']).split('-').last
                    parse_file = Parse::ParseFile.new :name => name, :content => filepath
                    parse_file.save
                    data[k] = parse_file
                  end
                end
              end
            end
            data.reject! do |k, v|
              %w(sessionToken bcryptPassword).include? k
            end
            parse_object.update! data
            puts "#{parse_object.parse_class_name}(#{data['objectId']}) has been updated."
          end
        end
      end

      def add_relations
        @relations.each do |filepath, column_name, parse_class_name|
          parse_class = Parse::Object(parse_class_name)
          results = JSON.parse File.read(filepath)
          results['results'].each do |relation|
            object = parse_class.find_by_id new_object_id_from_old_one(relation['owningId'])
            related_object = @parse_object_table[relation['relatedId']]
            object.send "#{column_name}=", Parse::Op::AddRelation.new(related_object.pointer)
            object.save!
            puts "#{relation['owningId']} and #{relation['relatedId']} have been connected."
          end
        end
      end
    end
  end
end
