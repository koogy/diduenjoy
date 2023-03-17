
require 'pg'
require 'rubyXL'

class ExcelParser
  def initialize(file)
    @workbook = RubyXL::Parser.parse(file)
  end

  def extract_data

    orders = []
    package_counter = 0
    item_counter = 0

    @workbook.worksheets.each do |worksheet|
      order_name = worksheet.sheet_name
      current_package_id = nil
      current_item_id = nil
      data = { packages: [], items: [] }


      worksheet.each_with_index do |row, index|
        # skip headers and empty rows
        next if row.nil? || index == 0
        package_id, item_id, label, value = row.cells.map(&:value)

        if package_id != current_package_id
          package_counter +=1
          data[:packages] << Package.new(package_counter, worksheet.sheet_id)
          current_package_id = package_id
        end

        if item_id != current_item_id
          item_counter +=1
          item = Item.new(item_counter, nil, nil, nil, package_counter, nil, nil)
          data[:items] << item
          current_item_id = item_id
        end

        case label
        when 'name'
          # If the name is empty, don't add it to the list
          if value.empty?
            data[:items].pop
          else
            data[:items].last.name = value
          end
        when 'price'
          data[:items].last.price = value
        when 'ref'
          data[:items].last.ref = value
        when 'warranty'
          data[:items].last.warranty = value
        when 'duration'
          data[:items].last.duration = value
        end
      end

      orders << { order_name: order_name, data: data }
    end

    orders
    end

end