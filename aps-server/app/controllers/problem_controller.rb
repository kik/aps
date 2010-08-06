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
    @title = "Result"
    @problem = Problem.find_by_id(params[:answer][:problem_id])
    @answer = Answer.new(params[:answer])
    @success = false
    Dir.mkdir("/tmp/aps") rescue nil
    dirname = nil
    begin
      loop {
        dirname = "/tmp/aps/aps-#{rand(10000)}"
        begin
          Dir.mkdir(dirname)
          break
        rescue
        end
      }
      logger.info "DIR: #{dirname}"
      open(dirname + "/Input.v", "w") {|io|
        io.write @answer.file
      }
      ret = system("cd #{dirname}; coqc Input.v >coqc.out 2>coqc.err")
      @coqc_out = File.read(dirname + "/coqc.out") rescue ""
      @coqc_err = File.read(dirname + "/coqc.err") rescue ""
      raise "FAIL: coqc Input.v" unless ret
      open(dirname + "/Verify.v", "w") {|io|
        io.write @problem.verifier
      }
      ret = system("cd #{dirname}; coqc Verify.v -require Input >coqcv.out 2>coqcv.err")
      @coqcv_out = File.read(dirname + "/coqcv.out") rescue ""
      @coqcv_err = File.read(dirname + "/coqcv.err") rescue ""
      raise "FAIL: coqc Verify.v -require Input" unless ret
      ret = system("cd #{dirname}; coqchk -o -norec Input >coqchk.out 2>coqchk.err")
      @coqchk_out = File.read(dirname + "/coqchk.out") rescue ""
      @coqchk_err = File.read(dirname + "/coqchk.err") rescue ""
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
  end
end
