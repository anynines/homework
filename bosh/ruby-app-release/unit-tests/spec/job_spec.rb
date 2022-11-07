require 'rspec'
require 'json'
require 'bosh/template/test'
require 'yaml'

describe 'ruby app main job:' do

  let(:release) { Bosh::Template::Test::ReleaseDir.new(File.join(File.dirname(__FILE__), '../..')) }
  let(:job) { release.job('rubyweb') }

  describe 'control template' do

    it 'raises error if control script is not put in the right directory inside the VM instance (check the job spec file for typos or misnaming!)' do
      right_dir = true
      begin 
        job.template('bin/ctl')
      rescue
        right_dir = false
      end

      expect(right_dir).to be true
    end

    let(:template) { job.template('bin/ctl') }

    it 'raises error if empty bootstrap is provided' do
      expect {template.render("bootstrap" => "")}.to raise_error 'No bootstrap file provided'
    end

    it 'raises error if bootstrap file is not the correct one' do
      expect {template.render("bootstrap" => "config.ru")}.to raise_error 'Wrong bootstrap file provided'
    end

    #=> NOTE: The following cases specify what should happen in specific lines of the script.
    #=> If the script is changed in a way that shifts its contents, this test will fail immediately even if the correct command is
    #=> present in the script. Overall, there are no changes that actually require the script contents to be shifted. 
    #=> But if this happens, one should not change the test-case! Instead, the script has to be changed so that it "aligns"
    #=> with the test case. 

    it 'raises error if control script is malformed' do 
      tmps = template.render("bootstrap" => "app.rb")
      expect(tmps.lines[0]).to include ("#!/bin/bash")
    end

    it 'raises error if exec command is missing the filename' do
      tmps = template.render("bootstrap" => "app.rb")
      expect(tmps.lines[20]).to include("bundle exec ruby app.rb")
    end
    
    it 'raises error if stop block is not defined' do 
      tmps = template.render("bootstrap" => "app.rb")
      expect(tmps.lines[26]).to include ("stop)")
    end

    it 'raises error if main process is not killed in the stop block' do
      tmps = template.render("bootstrap" => "app.rb")
      match = tmps.lines[29].match(/kill\s-[\d]\s`cat\s\$PIDFILE`/)
      expect(match).to be_truthy
    end

  end

  describe 'config template' do 

    it 'raises error if config template is not put in the right directory inside the VM instance' do
      right_dir = true
      begin 
        job.template('cfg/config.yml')
      rescue
        right_dir = false
      end

      expect(right_dir).to be true
    end

    let(:conf_template) {job.template('cfg/config.yml')}

    it 'raises error if configs are wrong' do
      expect {conf_template.render("port" => 1024)}.to raise_error "Invalid port number"
      expect {conf_template.render("port" => 7999)}.to raise_error "Invalid port number"
      expect {conf_template.render("port" => 8080)}.not_to raise_error 
    end

    it 'raises error if yml is not parsable or bad' do 
      parsable = true
      begin
        yml = YAML.load(conf_template.render("port" => 8080))
      rescue StandardError => e
        puts(e)
        parsable = false
      end
        expect(parsable).to be true
        expect(yml["port"]).to eq(8080)
    end
  end
end
