class Base

	attr_reader :v, :w, :vl, :wl, :mat, :mis

	def initialize(v, w)
		@v = v
		@w = w
		@vl = v.length
		@wl = w.length
	end

	def setMatch(mat, mis)
		@mat = mat
		@mis = mis
	end

	def match(v, w)
		if(v == w)
			return @mat
		else
			return @mis
		end
	end

	def quicksort(islands)
		pivot = islands.pop
		if(pivot == nil)
			return []
		else
			return quicksort(islands.select{|i| i[0] > pivot[0]}) + [pivot] + quicksort(islands.select{|i| i[0] <= pivot[0]})
		end
	end

end
