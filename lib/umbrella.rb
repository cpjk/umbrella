require_relative "user"

module Umbrella

  # Infect the entire connected component containing the given user
  # with the given site version through student-coach relationships.
  def self.infection(start_user, site_version)
    queue = [start_user]
    discovered = {start_user => true} # nodes that have already been enqueued
    infected = {} # nodes that have been infected

    while !queue.empty?
      curr_user = queue.pop
      if !infected[curr_user] # only infect and enqueue neighbours of uninfected nodes
        curr_user.site_version = site_version
        infected[curr_user] = true
        curr_user.edges.each do |edge|
          if !discovered[edge.to_user] # only push undiscovered neighbours
            queue.unshift(edge.to_user)
            discovered[edge.to_user] = true
          end
        end
      end
    end
  end

  # Try to infect up to the given limit of users with the given site version.
  # When the limit is reached, try to minimize the number of student-coach
  # version differences caused due to stopping the infection.
  def self.limited_infection(start_user, site_version, limit, buffer=5)
    queue = [{to: start_user, from: nil}]
    discovered = {start_user => true} # nodes that have already been enqueued
    infected = {} # nodes that have been infected

    while !queue.empty?
      curr = queue.pop
      curr_user = curr[:to]
      if !infected[curr_user] # only infect and enqueue neighbours of uninfected nodes
        if limit - infected.length <= 1 # if the limit will be reached with this user,
          curr_user.site_version = site_version
          infected[curr_user] = true
          # stop the infection and try to minimize the version differences
          limit_infection(curr, infected, limit, buffer, site_version)
          return
        end
        curr_user.site_version = site_version
        infected[curr_user] = true
        curr_user.edges.each do |edge|
          if !discovered[edge.to_user]
            queue.unshift({to: edge.to_user, from: curr_user})
            discovered[edge.to_user] = true
          end
        end
      end
    end
  end

  private

  # Iterate through the current_user's uninfected siblings,
  # and naively infect them if doing so will prevent version differences.
  def self.limit_infection(curr_hash, infected, limit, buffer, site_version)
    uninfected_siblings = curr_hash[:from].edges
                         .map { |edge| edge.to_user }
                         .select { |user| !infected[user] }

    diffs = uninfected_siblings.map do |sib|
      adjacent_users = sib.edges.map { |edge| edge.to_user }
      diffs_if_infect = adjacent_users.select { |user| !infected[user] }.count
      diffs_if_do_not_infect = adjacent_users.select { |user| !!infected[user] }.count
      diff = diffs_if_do_not_infect - diffs_if_infect
      { user: sib, diff: diff }
    end

    diff = diffs.sort_by {|diff_hash| diff_hash[:diff]}
    # # infect all siblings for which no infection will
    # increase the number of student-coach version differences
    diff.each do |diff|
      break if buffer <= 0 || diff[:diff] <= 0
      diff[:user].site_version = site_version
      infected[diff[:user]] = true
    end
  end
end
