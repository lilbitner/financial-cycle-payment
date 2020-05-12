# Plan: 
# 1. Write algorithim to create array of paths (cycle of transfers is determined by it coming back to original account or not having outbound transfer)
# 2. Write algorithim to evaluate the array of paths to determine paths with at least 4 cycles and at least $50,000 money (should money be looked up here or part of original path?) Should return accounts associated, with money involved if pass condition. Flag(boolean to meet criteria) - return array where flag is true 
 

require('json')
file = File.read('example_data_candidate.json')
parsed_file = JSON.parse(file)

# p parsed_file

def depth_first_search(source_index, end_index, parsed_file)
    
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
    
  
  
    loop do
      curr_node = node_stack.shift
      return false if curr_node == nil  
      return node_stack if visited.include?(curr_node)
      visited.push(curr_node) 


    array = []
    data_hash[curr_node].each do |transfer| 
       array.push(transfer["receivingAccountId"].to_i)
    end 

   
    node_stack = node_stack.concat(array)
    p node_stack
    
      
    end

  end



  def find_paths(parsed_file)
    parsed_file.each_with_index do |account, index|
        if account["inboundTransfersTotals"].empty? && account["outboundTransferTotals"].empty? 
          parsed_file.delete_at(index)
        end 
      end 
    parsed_file.each do |account|
        source_index = account["accountId"] 
    end_index = 123475
        depth_first_search(source_index, end_index, parsed_file)
    end 


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


# def make_paths(parsed_file, account_number)

#   object_of_arrays = []

#   array = []

#    data_hash = {} #key is accountId, values are array of outbound transfers

#   parsed_file.each_with_index do |account, index|
#     data_hash[account["accountId"]] = account
#   end

  
#  account = data_hash[account_number]
#     array.push(account["accountId"])
#    number_of_new_arrays =account["outboundTransferTotals"].length * account["inboundTransfersTotals"].length
#    Array * number_of_new_arrays 
#     account["outboundTransferTotals"].each do |transfer| 
#       array.push(transfer["receivingAccountId"]) 
#       account["inboundTransfersTotals"].each do |transfer|
#         array.unshift(transfer["sendingAccountId"])
#         make_paths() 
#     end 
#   end 
# end 
 

# make_paths(parsed_file, parsed_file[0] )


# def find_paths(parsed_file, current_node, target)

#   data_hash = {} #key is accountId, values are array of outbound transfers

#   parsed_file.each_with_index do |account, index|
#     data_hash[account["accountId"]] = account["outboundTransferTotals"]
#   end

#   visited = [] #what nodes have been visited
#   stack = [] #child nodes of current node, keep track of path between start and current 

#    data_hash[current_node] 
#   #  if !visited.include?(current_node)
#     visited.push(current_node)
#   #  end 
#     data_hash[current_node].each do |transfer|
#       # if data_hash[current_node].length > 1  #flag as a branch (have to go back to soonest branch)count =+ 1 
#       stack.push(transfer["receivingAccountId"].to_i) #push to top of stack? #if don't reach somehow remove the last x number of additions to visited. How get correct path? go backwards once find goal node? 
#     end 
#     stack.each do |transfer|
#     if transfer['receivingAccountId'] == target
#           visted.push(transfer['receivingAccountId']) 
#           return visited
#         end 
#         # if !visited.include?(transfer['receivingAccountId'])
#           visited.push(transfer['receivingAccountId']) 
#           current_node = transfer['receivingAccountId']
#           find_paths(parsed_file, account["accountId"], current_node)
#         # end 
#   end 
#   stack
# end 

# find_paths(parsed_file, parsed_file[0]["accountId"], parsed_file[0]["accountId"])










