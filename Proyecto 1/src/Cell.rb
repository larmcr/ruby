# Cell
class Cell

	attr_reader :dA, :lB, :uC, :score, :solution

	def initialize(dA, lB, uC, score, solution)
		@dA = dA
		@lB = lB
		@uC = uC
		@score = score
		@solution = solution
	end

	def getArrow
		arrow = Arrow::NONE
		if(@dA)
			arrow = Arrow::DA
		elsif(@lB)
			arrow = Arrow::LB
		elsif(@uC)
			arrow = Arrow::UC
		end
		return arrow
	end

	def setSolution
		@solution = true
	end

end

