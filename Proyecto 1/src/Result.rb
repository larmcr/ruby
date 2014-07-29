class Result
	attr_reader :sc, :vr, :wr

	def initialize(sc, vr, wr)
		@sc = sc
		@vr = vr
		@wr = wr
	end
end
