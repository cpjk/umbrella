require_relative "user"

def infect(start_user, site_version)
  queue = [start_user]
  discovered = {start_user => true} # nodes that have been enqueued
  infected = {} # nodes that have been infected

  while !queue.empty?
    curr_user = queue.pop
    if !infected[curr_user] # only infect and enqueu neighbours of uninfected nodes
      curr_user.site_version = site_version # set site version
      infected[curr_user] = true
      # only push undiscovered neighbours
      curr_user.edges.each do |edge|
        if !discovered[edge.to_user]
          queue.unshift(edge.to_user)
          discovered[edge.to_user] = true
        end
      end
    end
  end
end
