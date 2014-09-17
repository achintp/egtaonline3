require 'reduction'

class GamePresenter
end

$run_string = "python parseGame.py input -role -size > output"
$get_script_string = <<-COM
module load python/2.7.5
mkdir working_dir
cp -r script_path/* working_dir

cd working_dir
export PYTHONPATH=$PYTHONPATH:script_path
  		COM

describe ReductionArgumentSetter do
	let(:argument_list) {"-role -size"}
	before(:each) do 
		@arg_setter = ReductionArgumentSetter.new(argument_list)
	end

	describe "#prepare_input" do
		let(:game) {double ("game")}
		let(:local_input_path) {"local_input_path"}
		let(:input_file_name) {"input_file_name"}
		let(:game_presenter) {double "presenter"}
		let(:game_json) {double "game_json"}
		let(:file_path) {"local_input_path/input_file_name"}
		it "prepares the input file" do
			GamePresenter.should_receive(:new).with(game).and_return(game_presenter)
			game_presenter.should_receive(:to_json).and_return(game_json)
			File.stub(:join).with(local_input_path, input_file_name).and_return(file_path)
			FileUtils.stub(:mv).with(game_json.to_s, file_path).and_return(true)
			@arg_setter.prepare_input(game, local_input_path, input_file_name)
		end
	end

	describe '#set_input_file' do
		it 'sets input file name' do
			@arg_setter.set_input_file("input")
			expect(@arg_setter.instance_variable_get(:@input_file)).to eq("input")
		end
	end

	describe '#set_output_file' do
		it 'sets the output file name' do
			@arg_setter.set_output_file("output")
			expect(@arg_setter.instance_variable_get(:@output_file)).to eq("output")
		end
	end

	describe '#script_preparation_commands' do
		let(:working_dir) {"working_dir"}
		let(:script_path) {"script_path"}
		describe '#get_scripts' do			
			it 'prepares the copy scripts command' do
				@arg_setter.set_input_file("input")
				@arg_setter.set_output_file("output")
				res = @arg_setter.get_scripts(:working_dir, :script_path)
				expect(@arg_setter.instance_variable_get(:@work_dir)). to eq(:working_dir)
				expect(res).to eq($get_script_string)
			end
		end
		describe '#run_commands' do
			it 'prepares the command for executing script' do
				@arg_setter.set_input_file("input")
				@arg_setter.set_output_file("output")
				expect(@arg_setter.run_command).to eq($run_string)
			end
		end

		describe '#clean_up' do
			it 'Makes the clean up script' do
				#Add here
			end
		end
	end
end
