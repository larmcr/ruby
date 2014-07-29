#Smith-Waterman

class Local < BaseTable

	def initialize(v, w)
		super(v, w)
		@islands = []
	end

	def fillTable
		fillStart
		fillEnd
	end

	def fillStart
		addCell(0, 0, false, false, false, 0)
		i = 1
		while(i < @vl)
			addCell(i, 0, false, false, false, 0)
			i += 1
		end
		j = 1
		while(j < @wl)
			addCell(0, j, false, false, false, 0)
			j += 1
		end
	end

	def fillEnd
		i = 1
		while (i < @vl)
			j = 1
			while (j < @wl)
				addCellBySymbol(i, j)
				j += 1
			end
			i += 1
		end
	end

	def addCellBySymbol(i, j)
		sv = @v[i]
		sw = @w[j]
		sm = @matrix[i - 1][j - 1].score + match(sv, sw)
		si = @matrix[i][j - 1].score + @gap
		sj = @matrix[i - 1][j].score + @gap
		max = [sm, si, sj, 0].max
		if(max > 0)
			@islands.push([max, i, j])
			addCell(i, j, sm == max, si == max, sj == max, max)
		else
			addCell(i, j, false, false, false, 0)
		end
	end

	def getResults
		results = []
		@islands = quicksort(@islands)
		@islands.each do |island|
			results.push(getResult(island[1], island[2], false))
		end
		return results
	end

end
