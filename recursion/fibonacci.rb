def fibs(number)
	x = 0
	y = 1
	sequence = [x, y]

	while sequence.length < number do
		sequence << z = x + y
		x, y  = y, z
	end
	sequence
end

def fibs_rec(number, sequence = [0,1])
	if sequence.length == number
		sequence
	else
		sequence << sequence.last(2).inject(:+)
		fibs_rec(number, sequence)
	end
end

p fibs(5)
p fibs_rec(5)