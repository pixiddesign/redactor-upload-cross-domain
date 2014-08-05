require 'sinatra'
require 'rack/cors'
require 'pry'
require 'fileutils'
require 'json'

class RedactorUploadCrossDomain < Sinatra::Base

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', {
        headers: :any,
        methods: [:delete, :head, :get, :options, :patch, :post, :put]
      }
    end
  end

  ASSET_PATH = File.expand_path('../redactor-assets', __FILE__)
  FILE_PATH  = File.join(ASSET_PATH, 'files')
  IMAGE_PATH = File.join(ASSET_PATH, 'images')

  get '/redactor-images' do
    content_type :json
    FileUtils.mkdir_p(IMAGE_PATH)
    images = Dir[File.join(IMAGE_PATH, '*')].map do |file|
      {
        thumb: "#{request.scheme}://#{request.host}:#{request.port}/redactor-images/#{File.basename(file)}",
        image: "#{request.scheme}://#{request.host}:#{request.port}/redactor-images/#{File.basename(file)}",
        title: File.basename(file)
      }
    end
    images.to_json
  end

  get '/redactor-files/:filename' do
    content_type :json
    fullpath = File.join(FILE_PATH, params[:filename])
    send_file(fullpath) if File.file?(fullpath)
    halt 404
  end

  get '/redactor-images/:filename' do
    content_type :json
    fullpath = File.join(IMAGE_PATH, params[:filename])
    send_file(fullpath) if File.file?(fullpath)
    halt 404
  end

  post '/redactor-files' do
    content_type :json
    FileUtils.mkdir_p(FILE_PATH)
    datafile = params[:file]
    fullpath = File.join(FILE_PATH, datafile[:filename])
    FileUtils.copy(datafile[:tempfile], fullpath)
    {
      filelink: "#{request.scheme}://#{request.host}:#{request.port}/redactor-files/#{datafile[:filename]}",
      filename: datafile[:filename]
    }.to_json
  end

  post '/redactor-images' do
    content_type :json
    FileUtils.mkdir_p(IMAGE_PATH)
    datafile = params[:file]
    fullpath = File.join(IMAGE_PATH, datafile[:filename])
    FileUtils.copy(datafile[:tempfile], fullpath)
    {
      filelink: "#{request.scheme}://#{request.host}:#{request.port}/redactor-images/#{datafile[:filename]}",
      filename: datafile[:filename]
    }.to_json
  end

end
