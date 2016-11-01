require 'socket'
require 'json'

class NotGetOrPost < StandardError ; end
 
host = 'localhost'   
port = 2000                           
path = "./index.html"

user_info = {
	:viking => {}
}

post_headers = []

socket = TCPSocket.open(host,port)

def get_info(user_info)
	puts "Please enter your name:"
	user_info[:viking][:username] = gets.chomp
	puts "Please enter your email:"
	user_info[:viking][:email] = gets.chomp
end


def make_POST_request(user_info, socket)
	serialized_user_info = user_info.to_json

	request = "POST #{serialized_user_info} HTTP/1.0\r\n\r\n"


	post_headers = [
		"From: #{user_info[:viking][:email]}",
		"Content-Length: #{serialized_user_info.size}\r\n\r\n"
	].join("\r\n")
	socket.print(request)
	socket.print(post_headers)
end

def send_request(desired_request, path, socket, user_info)
	if desired_request == "GET"
		request = "GET #{path} HTTP/1.0\r\n\r\n"
		socket.print(request)
	elsif desired_request == "POST"
		get_info(user_info)
		make_POST_request(user_info, socket)
	end
end

def show_response(desired_request, response)
	if desired_request == "GET"
		headers, body = response.split("\r\n\r\n", 2) 
		status_line = headers.split("\r\n").first 

		if status_line.include?("200")
			puts body
		else
			puts status_line
		end
	elsif desired_request == "POST"
		puts response
	end
end

begin
	puts "Would you like to GET or POST?"
	desired_request = gets.chomp

	raise NotGetOrPost unless desired_request == "GET" || desired_request == "POST"
rescue NotGetOrPost
	puts "Enter 'GET' or 'POST'"
	retry 
end

send_request(desired_request, path, socket, user_info)

response = socket.read

show_response(desired_request, response)

