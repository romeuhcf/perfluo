module Brain
  def react_to_listen(msg)
    @listen_triggers.each do |trigger|
      if trigger.match?(msg)
        self.instance_exec(msg, &trigger.block)
        break
      end
    end
  end
end

