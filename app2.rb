require('json')
file = File.read('data.json')
parsed_file = JSON.parse(file)


def make_path_arrays(source_index, parsed_file)
    
    parsed_file.each_with_index do |account, index|
        if account["inboundTransfersTotals"].empty? && account["outboundTransferTotals"].empty? 
          parsed_file.delete_at(index)
        end 
    end 

    data_hash = {} 
    parsed_file.each do |account| 
        data_hash[account["accountId"]] = account["outboundTransferTotals"]
    end 

    node_stack = [source_index]
    visited = []
    final_array = []
    
  
    loop do 
      curr_node = node_stack.pop
      if visited.include?(curr_node) 
        # visited.push(curr_node)
        return final_array.push(visited)
      end 

      visited.push(curr_node)

      array = []
      data_hash[curr_node].each do |transfer| 
          array.push(transfer["receivingAccountId"].to_i)
      end 

 
        node_stack = (node_stack << array).flatten!
        visited

    end 

    return final_array
end 

# p make_path_arrays(123456, parsed_file)




def find_paths(parsed_file)
    parsed_file.each_with_index do |account, index|
        if account["inboundTransfersTotals"].empty? && account["outboundTransferTotals"].empty? 
            parsed_file.delete_at(index)
        end 
    end 

    arrays = []
    parsed_file.each do |account|
        source_index = account["accountId"] 
       arrays.push(make_path_arrays(source_index, parsed_file))
    end 
    final_arrays = arrays.flatten! 
    finding_fraud(final_arrays, parsed_file)
end 
    
# find_paths(parsed_file)


def finding_fraud(parsed_file, final_arrays)

    money_hash = {} 
    parsed_file.each do |account|
        p money_hash[account["accountId"]] 
        p  account["outboundTransferTotals"][0]["quantity"]   
    end 

    final_object = {}
    final_arrays.uniq.each_with_index do |array, index|
        if array.length < 4
            final_arrays.delete_at(index)
        end 

        array.reduce(0) do |sum, account|
           sum = sum += money_hash[account]
        end 

        if sum < 50000
            final_arrays.delete_at(index)
        end 

        final_object[array] = sum      
    end 

   p final_object

end 

find_paths(parsed_file)

# finding_fraud(parsed_file)
      