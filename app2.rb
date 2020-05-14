require('json')
file = File.read('data.json')
parsed_file = JSON.parse(file)


def make_path_arrays(source_index, data_hash, parsed_file)
    
    node_stack = [source_index]
    visited = []
    path = [] 
    
    loop do 
      curr_node = node_stack.pop
        if visited.include?(curr_node) 
            return path.push(visited)
        end 

        visited.push(curr_node)

        array = []
        data_hash[curr_node].each do |transfer| 
            array.push(transfer["receivingAccountId"].to_i)
        end 

 
        node_stack = (node_stack << array).flatten!
    end 
    return path
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
       arrays.push(make_path_arrays(source_index, data_hash, parsed_file))
    end 
    arrays 
    
    finding_fraud(arrays, parsed_file)
end 
    

def finding_fraud(arrays, parsed_file)

   account_array = arrays.flatten(1) #necessary to flatten the nested arrays we have made

    money_hash = {} 
    parsed_file.each do |account|
       money_hash[account["accountId"]] = account["outboundTransferTotals"][0]["quantity"]   
    end 

    final_object = {} #the object we will return with key of account and value of money total
    account_array.uniq.each_with_index do |array, index|
        if array.length < 4
            account_array.delete_at(index)
            break
        end 

        final_sum = array.reduce(0) do |sum, account| #sum money totals by using money_hash as an easy look-up method 
            sum += money_hash[account]
        end 

        if final_sum < 50000
            account_array.delete_at(index)
            break 
        end 

        final_object[array] = final_sum      
    end 

   p final_object

end 

iterate_through_accounts(parsed_file)
      