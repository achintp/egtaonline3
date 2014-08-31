class AnalysisPathFinder
  attr_reader :local_data_path, :scripts_path, :remote_data_path
  def initialize(game_id,analysis_id,local_path,remote_path)
    @game_id = game_id.to_s 
    @analysis_id = analysis_id.to_s 
    @remote_data_path = File.join(remote_path,'egtaonline','analysis',@game_id, @analysis_id )

    @local_data_path = File.join(local_path,'analysis',@game_id, @analysis_id)
    @scripts_path = File.join(remote_path,'GameAnalysis')   
  end

  def dominance_script_path
    @scripts_path
  end

  def pbs_error_file
    "#{@game_id}-analysis-#{@analysis_id}-pbs.e"
  end

  def pbs_output_file
    "#{@game_id}-analysis-#{@analysis_id}-pbs.o"
  end

  def working_dir 
    "/tmp/${PBS_JOBID}"
  end

  def input_file_name
    "#{@game_id}-analysis-#{@analysis_id}.json"
  end

  def output_file_name
    "#{@game_id}-analysis-#{@analysis_id}.txt"
  end

  def reduction_file_name
    "#{@game_id}-reduced-#{@analysis_id}.json"
  end

  def subgame_json_file_name
    "#{@game_id}-subgame-#{@analysis_id}.json"
  end

  def dominance_json_file_name
    "#{@game_id}-dominance-#{@analysis_id}.json"
  end

  def pbs_file_name
    "#{@game_id}-wrapper-#{@analysis_id}"
  end

  def dominance_json_file_name
    "#{@game_id}-dominance-#{@time}.json"
  end
end