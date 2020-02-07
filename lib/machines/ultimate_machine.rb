module Intrigue
module Machine
  class UltimateMachine < Intrigue::Machine::Base

    def self.metadata
      {
        :name => "ultimate_machine",
        :pretty_name => "THE ULTIMATE MACHINE",
        :passive => false,
        :user_selectable => false,
        :authors => ["jcran","AnasBenSalah"],
        :description => "This machine runs all ips for a given entity."
      }
    end

    def self.recurse(entity, task_result)
      
      # enumerate what we'll run on 
      allowed_entity_types = ["Domain", "DnsRecord", "IpAddress"]
      return unless allowed_entity_types.include? entity.type_string

      # get the names that apply for us to run
      task_names = get_runnable_tasks_for_type entity.type_string
      task_result.log "Running: #{task_names}"

      # run'm
      task_names.each do |tn|
        start_recursive_task(task_result, tn, entity)
      end

    end


    def self.get_runnable_tasks_for_type(entity_type)

      tasks = Intrigue::TaskFactory.allowed_tasks_for_entity_type entity_type
      result = tasks.sort_by{|x| x.metadata[:name] }.map do |task| 
        
        # return the appropriate thing
        next if task.metadata[:type] == "creation"
        next if task.metadata[:type] == "enrichment"
      
        task.metadata[:name]
      end 

    result.compact
    end


end
end
end
