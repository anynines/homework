require 'rspec'
require 'json'
require 'bosh/template/test'
require 'yaml'
require_relative 'helpers'

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
      expect {template.render({'bootstrap' => ''})}.to raise_error 'No bootstrap file provided'
    end

    it 'raises error if bootstrap file is not the correct one' do
      expect {template.render({'bootstrap' => 'config.ru'})}.to raise_error 'Wrong bootstrap file provided'
    end

    it 'raises error if control script is malformed' do 
      tmps = template.render({'bootstrap' => 'app.rb'})
      expect(tmps.lines[0]).to include ("#!/bin/bash")
    end
    
    it 'raises error if exec command is malformed' do
      tmps = template.render({'bootstrap' => 'app.rb' })

      exec_line = tmps.each_line do |line|
        line if line.include? 'bundle exec'
      end
      
      expect(exec_line).to include('bundle exec ruby app.rb')
    end

    it 'raises error if stop block is not defined' do 
      tmps = template.render({'bootstrap' => 'app.rb'})
      expect(find_statement(tmps, /^stop\)$/)).not_to eq(-1)
    end

    it 'raises error if main process is not killed inside the stop block' do
      tmps = template.render({'bootstrap' => 'app.rb'})

      stop_block_line = find_statement(tmps, /^stop\)$/)
      kill_statement_line = find_statement(tmps, /kill\s-[\d]\s`cat\s\$PIDFILE`/)
      expect(stop_block_line).to be < kill_statement_line
    end

    it 'raises error if case blocks are not formed correctly' do
      tmps = template.render({'bootstrap' => 'app.rb'})
      expect(check_block_formations(tmps)).to be true 
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
      expect {conf_template.render('port' => 1024)}.to raise_error 'Invalid port number'
      expect {conf_template.render('port' => 7999)}.to raise_error 'Invalid port number'
      expect {conf_template.render('port' => 8080)}.not_to raise_error 
    end

    it 'raises error if yml is not parsable or malformed' do 
      parsable = true
      begin
        yml = YAML.load(conf_template.render('port' => 8080))
      rescue StandardError => e
        parsable = false
      end
        expect(parsable).to be true
        expect(yml['port']).to eq(8080)
    end
  end
end
