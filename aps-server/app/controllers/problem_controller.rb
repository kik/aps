class ProblemController < ApplicationController
  def index
    @title = "All problems"
    @problems = Problem.find(:all, :order => :id)
  end

  def welcom
    @title = "Top"
  end

  def view
    @problem = Problem.find(params[:id])
    @answer = Answer.new
    @answer.problem_id = @problem.id
    @title = @problem.title
  end
  
  def new
    @title = "Create problem"
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(params[:problem])
    @problem.save!
    redirect_to :action => :index
  end

  def prove
    @answer = Answer.new(params[:answer])
    p @answer
  end
end
