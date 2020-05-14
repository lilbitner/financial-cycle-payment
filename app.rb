require('json')
file = File.read('example_data_candidate.json')
parsed_file = JSON.parse(file)

def depth_first_search(source_index, data_hash, parsed_file)

    node_stack = [source_index] 
    visited = []
    path = []  
    
    loop do 
        curr_node = node_stack.pop
        if path[0] == curr_node  
            path.push(curr_node)
            break
        end  

        if (visited.include?(curr_node) or path.include?(curr_node)) && curr_node != path[0]  
            break 
        end 

        if data_hash[curr_node].empty? 
            visited.push(curr_node)
            break 
        end 
      
        path.push(curr_node)
        
        array = []
        data_hash[curr_node].each do |transfer| 
            array.push(transfer["receivingAccountId"].to_i)
        end 

        node_stack = (node_stack << array).flatten!   
    end
    return path 
end

def finding_fraud(arrays, parsed_file, data_hash)

    account_array = arrays.flatten(1)

    final_object = {}
    account_array.each_with_index do |array, index|
        if array.length < 4
            account_array.delete_at(index)
        end 

        if array[-1] != array[0]
            account_array.delete_at(index)
        end 

        final_sum = array.reduce(0) do |sum, account|
            account_to_check = account 
           sum += find_money_value(account_to_check, data_hash, array)
        end 

        if final_sum < 50000
            account_array.delete_at(index)
        end 

        final_object[array] = final_sum      
    end 
    p final_object
end 

def find_money_value(account_to_check, data_hash, array)
    array.each_with_index do |account, index|
        if account_to_check == account 
          outbound_transfer = array[index + 1] 
          transfer_object = data_hash[account].find do |transfer|
            transfer["receivingAccountId"] = outbound_transfer
          end 
        end
        return transfer_object["quantity"]
    end 
end 
        
def iterate_through_accounts(parsed_file)
    parsed_file.each_with_index do |account, index|
        if account["inboundTransfersTotals"].empty? && account["outboundTransferTotals"].empty? 
          parsed_file.delete_at(index)
        end 
    end 

    data_hash = {} 
    parsed_file.each do |account| 
        data_hash[account["accountId"]] = account["outboundTransferTotals"]
    end 

    arrays = []
    parsed_file.each do |account|
        source_index = account["accountId"] 
        arrays.push(depth_first_search(source_index, data_hash, parsed_file))
    end 

    finding_fraud(arrays, parsed_file, data_hash)
end 

iterate_through_accounts(parsed_file)




  











