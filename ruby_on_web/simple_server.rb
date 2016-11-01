require 'socket'
require 'byebug'
require 'json'

server = TCPServer.open(2000)
verb, path, data, http_standard = "", "", "", ""

def make_GET_response(path, client)
	file = File.open(path)
		headers = [ 
			"HTTP/1.0 200 OK",
			"Date: #{Time.now.ctime}",
			"Content-Type: text/html",
			"Content-Length: #{file.size}\r\n\r\n"
			].join("\r\n")

		client.print headers
		client.print(file.readlines.join(""))

		file.close
end

def make_POST_response(data, client)
	params = {}
	JSON.parse(data).each { |key, value| params[key] = value }

	username = params["viking"]["username"]
	email = params["viking"]["email"]

	replaces_yield = "<li>Name: #{username}</li>\n      <li>Email: #{email}</li>\n"

	thanks = File.open("thanks.html") { |file| file.readlines }

	client.print(thanks.join("").gsub!("<%= yield %>\n", replaces_yield))
end

loop { 
	client = server.accept
	request = client.gets.split("\r\n\r\n")

	if request.length > 1
		status_line = request.split("\r\n").first
	else
		status_line = request.join("")
	end

	if status_line.include?("GET")
		verb, path, http_standard = status_line.strip.split(" ")
	elsif status_line.include?("POST")
		verb, data, http_standard = status_line.strip.split(" ")
	end

  if verb == "GET" && File.exist?(path) 
		make_GET_response(path, client)
	elsif verb == "POST"
		make_POST_response(data, client)
	else
		client.print "HTTP/1.0 404 No File\r\n\r\n"
	end

	client.print "Closing the connection. Bye!"
	client.close
 }