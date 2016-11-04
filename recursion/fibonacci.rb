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
	return sequence if sequence.length == number
	sequence << sequence.last(2).inject(:+)
	fibs_rec(number, sequence)
end

p fibs(5)
p fibs_rec(5)