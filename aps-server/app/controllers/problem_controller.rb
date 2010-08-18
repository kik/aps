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
    @answers = Answer.find_all_by_problem_id(@problem.id)
    @title = @problem.title
  end

  def viewa
    @answer = Answer.find(params[:id])
    @problem = Problem.find(@answer.problem_id)
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

  def recent
    @titile = "recent entries"
    @answers = Answer.find(:all, :order => "updated_at DESC", :limit => 100, :include => [:problem, :language])
  end

  private
  def write_file(name, dat)
    open(name, "w") {|io|
      io.write dat
    }
  end

  def execute(dirname, cmd)
    ret = system("cd #{dirname}; #{cmd} >t.out 2>t.err")
    out = File.read(dirname + "/t.out") rescue ""
    err = File.read(dirname + "/t.err") rescue ""
    [ret, out, err]
  end
  
  public

  def prove
    @title = "Result"
    @problem = Problem.find_by_id(params[:answer][:problem_id])
    @answer = Answer.new(params[:answer])
    @answer.size = @answer.file.size
    @success = false
    Dir.mkdir("/tmp/aps") rescue nil
    dirname = nil
    begin
      raise "FAIL: empty name" if @answer.user.blank?
      loop {
        dirname = "/tmp/aps/aps-#{rand(10000)}"
        begin
          Dir.mkdir(dirname)
          break
        rescue
        end
      }
      logger.info "DIR: #{dirname}"

      %w(Pwd Cd Drop ProtectedLoop Load Declare LoadPath Path ML State Debug Extract).each {|w|
        raise "FAIL: forbidden word '#{w}'" if @answer.file[w]
      }
      have_def = !@problem.definitions.blank?
      write_file(dirname+"/Definitions.v", @problem.definitions) if have_def
      write_file(dirname+"/Input.v", @answer.file)
      write_file(dirname+"/Verify.v", @problem.verifier)

      if have_def
        ret, @coqd_out, @coqd_err = execute(dirname, "coqc Definitions.v")
        raise "FAIL: coqc Definitions.v" unless ret
      end

      ret, @coqc_out, @coqc_err = execute(dirname, "coqc Input.v")
      raise "FAIL: coqc Input.v" unless ret

      req_def = ""
      req_def = "-require Definitions" if have_def
      cmd = "coqc Verify.v #{req_def} -require Input"
      ret, @coqcv_out, @coqcv_err = execute(dirname, cmd)
      raise "FAIL: #{cmd}" unless ret

      ret, @coqchk_out, @coqchk_err = execute(dirname, "coqchk -o -norec Input")
      raise "FAIL: coqchk -o -norec Input" unless ret
      raise "FAIL: module check" unless @coqchk_out =~ /^Modules were successfully checked$/
      raise "FAIL: module check" unless @coqchk_out =~ /^CONTEXT SUMMARY$/
      allowed_ax = []
      if @problem.assumption =~ /^\* Axioms:\r?$/
        allowed_ax = $'.split
      end
      used_ax = []
      if @coqchk_out =~ /^\* Axioms:\r?$/
        used_ax = $'.split
      end
      used_ax.each {|ax|
        raise "FAIL: axiom check" unless allowed_ax.member? ax
      }
      @success = true
    rescue
      @error_message = $!.to_s
    ensure
      system("rm -rf #{dirname}") if dirname
    end
    if @success
      @prev_answer = Answer.find_by_problem_id(@problem.id, :conditions => ["language_id = ? AND user = ?", @answer.language_id, @answer.user])
      if @prev_answer
        @prev_answer.file = @answer.file
        @prev_answer.size = @answer.size
        @prev_answer.save!
      else
        @answer.save!
      end
    end
  end
end
