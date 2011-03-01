require 'sequel'

class TableMaker
  def initialize(db, table_name, layout)
    @db = db
    @table_name = table_name.to_sym
    @column_info = []
    @column_names = []
    @data = []
    parse_layout(layout)
    create_table
    import_data
  end

  private
    def parse_layout(layout)
      layout.each_line do |line|
        line.chomp!
        line.strip!
        next  if line =~ /^[-+|=]*$/

        parts = line.split(/\|/).collect { |s| s.strip!; s == "" ? nil : s }
        parts.shift

        if @column_info.empty?
          parts.each do |str|
            md = str.match(/(\w+)\((\w+)\)/)
            name = md[1].to_sym
            type = Object.module_eval("::#{md[2]}", __FILE__, __LINE__)
            @column_info << { :name => name, :type => type }
            @column_names << name
          end
        else
          @data << parts
        end
      end
    end

    def create_table
      column_info = @column_info
      @db.create_table(@table_name) do
        primary_key :id
        @columns = column_info
      end
    end

    def import_data
      ds = @db[@table_name]
      ds.import(@column_names, @data)
    end
end
