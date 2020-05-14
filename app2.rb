require('json')
file = File.read('data.json')
parsed_file = JSON.parse(file)


def make_path_arrays(source_index, data_hash, parsed_file)
    
    node_stack = [source_index] #to work off a path 
    visited = [] #to keep track of already visited accounts
    path = [] #to keep track of correct path
    
    loop do 
      curr_node = node_stack.pop
        if visited.include?(curr_node) #to check if the loop has reached the origin account
            return path.push(visited) #if it has, push visited array into path array
        end 

        visited.push(curr_node)

        array = [] #array of child accounts
        data_hash[curr_node].each do |transfer| 
            array.push(transfer["receivingAccountId"].to_i)
        end 

 
        node_stack = (node_stack << array).flatten!
    end 
    return path #method returns the correct circular payment path
end 

def finding_fraud(arrays, parsed_file)

   account_array = arrays.flatten(1) #necessary to flatten the nested arrays we have made

    money_hash = {} #creates hash/object with key of account-id and value of outbound transfer quantity 
    parsed_file.each do |account|
       money_hash[account["accountId"]] = account["outboundTransferTotals"][0]["quantity"]   
    end 

    final_object = {} 
    account_array.uniq.each_with_index do |array, index|
        if array.length < 3 #if less than 3, does not qualify (the last account is not included) 
            account_array.delete_at(index)
            break
        end 

        final_sum = array.reduce(0) do |sum, account| #sum money totals by using money_hash as an easy look-up method 
            sum += money_hash[account]
        end 

        if final_sum < 50000 #if less than 50000, does not qualify 
            account_array.delete_at(index)
            break 
        end 

        final_object[array] = final_sum #creates hash/object with key of account and value of money total  
    end 

    p final_object #prints final object! 

end 

def iterate_through_accounts(parsed_file)
    parsed_file.each_with_index do |account, index| #removes accounts without outbound & inbound transfers
        if account["inboundTransfersTotals"].empty? && account["outboundTransferTotals"].empty? 
            parsed_file.delete_at(index)
        end 
    end 

    data_hash = {} #creates hash with key of account-id and value of outbound transfer object
    parsed_file.each do |account| 
        data_hash[account["accountId"]] = account["outboundTransferTotals"]
    end 

    arrays = []
    parsed_file.each do |account| #iterate through each account to find all possible paths
        source_index = account["accountId"] 
       arrays.push(make_path_arrays(source_index, data_hash, parsed_file)) #push resulting path array of make_path_arrays method into final array
    end 
    arrays 
    
    finding_fraud(arrays, parsed_file) #now to check if the array of path arrays are shady 
end 

iterate_through_accounts(parsed_file) #call the this method to cycle through all other methods 
      