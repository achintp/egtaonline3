class ReductionPathSetter
  def initialize(game_id,time,local_path,remote_path)
    @game_id = game_id
    @remote_data_path = File.join(remote_path,'egtaonline','reduction',@game_id)
    @local_data_path = File.join(local_path,'reduction',@game_id)
    @scripts_path = File.join(remote_path,'GameAnalysis')
    @time = time
  end

  def script_path
    @scripts_path
  end
  
  def local_input_path
    File.join(@local_data_path, 'in')
  end

  def local_output_path
    File.join(@local_data_path, 'out')
  end

  def local_pbs_path
  	File.join(@local_data_path, 'pbs')
  end

  def input_file_name
  	"#{@game_id}-reduced-#{@time}.json"
  end

  def output_file_name
  	"#{@game_id}-reduced-#{@time}.txt"
  end

  def working_dir
  	"/tmp/${PBS_JOBID}"
  end

  def save_output_path
    File.join(@remote_data_path, 'out')
  end

  def pbs_error_file
    "#{@game_id}-analysis-#{@time}-pbs.e"
  end

  def pbs_output_file
    "#{@game_id}-analysis-#{@time}-pbs.o"
  end

  def pbs_file_name
    "#{@game_id}-wrapper-#{@time}"
  end
end