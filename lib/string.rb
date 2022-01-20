class String
  def constantize
    self.split("::").inject(Module) { |acc, val| acc.const_get(val) }
  end
end