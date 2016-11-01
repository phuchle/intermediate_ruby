require 'socket'
require 'json'

server = TCPServer.open(2000)

def set_GET_or_POST(status_line, client)
	if status_line.include?("GET")
		verb, path, http_standard = status_line.strip.split(" ")
		make_GET_response(path, client) if File.exist?(path)
	elsif status_line.include?("POST")
		verb, data, http_standard = status_line.strip.split(" ")
		make_POST_response(data, client)
	else
		client.print "HTTP/1.0 404 No File\r\n\r\n"
	end
end	

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

	set_GET_or_POST(status_line, client)

	client.print "Closing the connection. Bye!"
	client.close
 }