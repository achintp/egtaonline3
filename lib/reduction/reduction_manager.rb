require_relative 'reduction_path_setter'
require_relative 'reduction_pbs_formatter'
require_relative 'reduction_argument_setter'

class ReductionManager
	def initialize(game, reduction_arg_setter, pbs_formatter)
		@game = game
		@reduction_arg_setter = reduction_arg_setter
		@pbs_formatter = pbs_formatter
		@time = Time.now.strftime('%Y%m%d%H%M%S%Z')
		@game_id = game.id.to_s

		#For Debugging
		# local_path = '#{Rails.root}/app'
		# remote_path = 'nfs/wellman_ls'

		local_path = Rails.root.join('temp', 'local_path')
		remote_path = Rails.root.join('temp', 'remote_path')

		#For prod
		# local_path = '/mnt/nfs/home/egtaonline'
		# remote_path = '/nfs/wellman_ls'

		@path_setter = ReductionPathSetter.new(@game_id, @time, local_path, remote_path)
	end

	def make_temp_dirs
		FileUtils::mkdir_p "#{@path_setter.local_output_path}", mode: 0770
	    FileUtils::mkdir_p "#{@path_setter.local_input_path}", mode: 0770
	    FileUtils::mkdir_p "#{@path_setter.local_pbs_path}", mode: 0770
	end

	def prepare_input
		@reduction_arg_setter.prepare_input(@game, @path_setter.local_input_path, @path_setter.input_file_name)
	end

	def prepare_scripts
		@reduction_arg_setter.set_input_file(@path_setter.input_file_name)
		@reduction_arg_setter.set_output_file(@path_setter.output_file_name)
		@get_scripts = @reduction_arg_setter.get_scripts(@path_setter.working_dir, @path_setter.script_path)
		@run_command = @reduction_arg_setter.run_command
		@clean_up = @reduction_arg_setter.clean_up(@path_setter.working_dir,@path_setter.save_output_path)
	end


	def write_pbs_file
		pbs_file = @pbs_formatter.prepare_pbs(@path_setter.pbs_error_file,
			@path_setter.pbs_output_file, @get_scripts, @run_command, @clean_up)
		@pbs_formatter.write_pbs(pbs_file, File.join("#{@path_setter.local_pbs_path}", "#{@path_setter.pbs_file_name}"))
	end

	def reduce
		make_temp_dirs
		prepare_input
		prepare_scripts
		write_pbs_file
	end

end