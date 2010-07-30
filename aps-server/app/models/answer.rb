class Answer < ActiveRecord::Base
  def file_in= v
    self.file = v.read
  end
end
