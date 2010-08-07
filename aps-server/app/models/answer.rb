class Answer < ActiveRecord::Base
  belongs_to :problem
  belongs_to :language
  
  def file_in= v
    self.file = v.read
  end
end
