class Database
  def initialize(dbname, user, password, host = 'localhost', port = 5432)
    @connection = PG.connect(dbname: dbname, user: user, password: password, host: host, port: port)
  end

  def insert_order(orderid, ordername)
    begin
      @connection.exec("INSERT INTO orders (orderid,odername) VALUES (#{orderid},'#{ordername}')")
    rescue PG::Error => e
      puts "[Error] inserting order: #{e.message}"
    end
  end

  def insert_package(packageid, orderid)
    begin
      @connection.exec("INSERT INTO packages (packageid,orderid) VALUES (#{packageid},#{orderid})")
    rescue PG::Error => e
      puts "[Error] inserting package: #{e.message}"
    end
  end

  def insert_item(item)
    begin
      @connection.exec_params("INSERT INTO items (itemid, name, price, ref, packageid, warranty, duration) VALUES ($1, $2, $3, $4, $5, $6, $7)", [item.itemid, item.name, item.price, item.ref, item.package_id, item.warranty, item.duration])
    rescue PG::Error => e
      puts "[Error] inserting item: #{e.message}"
    end
  end

  def insert_data(orders)
    orders.each_with_index do |order, order_index|
      insert_order(order_index + 1, order[:order_name])

      order[:data][:packages].each do |package|
        insert_package(package.package_id, order_index + 1)
        order[:data][:items].select { |item| item.package_id == package.package_id }.each do |item|
          insert_item(item)
        end
      end
    end
  end

  def close
    @connection.close
  end

end