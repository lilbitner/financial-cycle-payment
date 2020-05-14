require('json')
file = File.read('example_data_candidate.json')
parsed_file = JSON.parse(file)


def depth_first_search(source_index, data_hash, parsed_file)

    node_stack = [source_index] #to work off a path 
    visited = [] #to keep track of already visited accounts
    path = [] #tokeep track of correct path 
    
  
    loop do 
        curr_node = node_stack.pop

        if path[0] == curr_node #check that node is source_index 
            path.push(curr_node)
            break
        end  

        if (visited.include?(curr_node) or path.include?(curr_node)) && curr_node != path[0] #repeat of account that is not sourceindex  
            break 
        end 

        if data_hash[curr_node].empty? #to account for a node with no children 
            visited.push(curr_node)
            break 
        end 

#problem is keeping track of siblings that are not correct path 
      
        path.push(curr_node)
        
        array = []
        data_hash[curr_node].each do |transfer| 
            array.push(transfer["receivingAccountId"].to_i)
        end 

    node_stack = (node_stack << array).flatten!
     
    end
end


def finding_fraud(parsed_file, final_arrays, data_hash)

    # money_hash = {} 
    # parsed_file.each do |account|
    #     money_hash[account["accountId"]] = account["outboundTransferTotals"]["quantity"]   #make data_hash instead 
    # end 


    final_object = {}
    final_arrays.each_with_index do |array, index|
        if array.length < 4
            final_arrays.delete_at(index)
        end 

        if array[-1] != array[0]
            final_arrays.delete_at(index)
        end 

        # array.reduce(0) do |sum, account|
        #    sum += money_hash[account]
        # end 

        array.each_with_index do |account, index|
            array.reduce(0) do |sum, account|
               transfer_object = data_hash[account["accountid"]].find do |transfer|
                    transfer["receivingAccountId"] = array[(index+1)]
                end 
            sum += transfer_object["quantity"]
            end 
        end     

        if sum < 50000
            final_arrays.delete_at(index)
        end 

        final_object[array] = sum      
    end 

    final_object

end 

def find_paths(parsed_file)
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
    final_arrays = arrays.flatten!
    finding_fraud(final_arrays, parsed_file, data_hash)
end 

find_paths(parsed_file)





  





















# 1. Mark the current node as visited(initially current node is the root node)
# 2. Check if current node is the goal, If so, then return it.
# 3. Iterate over children nodes of current node, and do the following:
#     1. Check if a child node is not visited.
#     2. If so, then, mark it as visited.
#     3. Go to it's sub tree recursively until you find the goal node(In other words, do the same steps here passing the child node as the current node in the next recursive call).
#     4. If the child node has the goal node in this sub tree, then, return it.
# 3. If goal node is not found, then goal node is not in the tree!




  











