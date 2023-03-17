
require 'pg'
require 'rubyXL'
require_relative 'models/item'
require_relative 'models/package'
require_relative 'excel_parcer'
require_relative 'database'
class App
    file = 'Orders.xlsx'
    parser = ExcelParser.new(file)
    data = parser.extract_data

    data.each do |order|
        puts "Order Name: #{order[:order_name]}"
        puts "Packages:"
        order[:data][:packages].each do |package|
            puts "\tPackage ID: #{package.package_id}"
            puts "\tItems:"
            order[:data][:items].each do |item|
                if item.package_id == package.package_id
                    puts "\t\tName: #{item.name}"
                    puts "\t\tPrice: #{item.price}"
                    puts "\t\tRef: #{item.ref}"
                    puts "\t\tWarranty: #{item.warranty}"
                    puts "\t\tDuration: #{item.duration}"
                    puts ""
                end
            end
        end
    end

    db = Database.new('due','due','a')
    db.insert_data(data)
    db.close
end
