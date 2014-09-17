class ReductionArgumentSetter

	#The path to the game-summary json file and 
	#the reduced number for the player has to 
	#be recieved

	def initialize(arg_string)
		@script_name = 'parseGame.py'
		@arg_string = arg_string
	end

	def add_path(path)
		@arg_string = '#{path} ' + @arg_string
	end

	def set_input_file(input_file)
		@input_file = input_file
	end

	def set_output_file(output_file)
		@output_file = output_file
	end

	def prepare_input(game, local_input_path, input_file_name)
    	FileUtils.mv("#{GamePresenter.new(game).to_json()}",File.join("#{local_input_path}","#{input_file_name}"))
  	end

  	def get_scripts(working_dir, script_path)
  		@work_dir = working_dir
  		@get_command = <<-COM
cp -r #{script_path}/* #{working_dir}
  		COM

  		<<-COM
module load python/2.7.5
mkdir #{@work_dir}
#{@get_command}
cd #{@work_dir}
export PYTHONPATH=$PYTHONPATH:#{script_path}
  		COM
  	end

  def run_command
  	"python #{@script_name} #{@input_file} #{@arg_string} > #{@output_file}"
  end

  def clean_up(work_dir, local_dir)
  	@save_out = "cp -r #{work_dir}/#{@output_file} #{local_dir}"
  	<<-COM
#{@save_out}
rm -rf #{work_dir}
  	COM
  end

end