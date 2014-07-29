class BlocksLocal < BaseBlocks

	def initialize(v, w)
		super(v, w)
		@islands = []
	end

	def fillTables
		fillStart
		fillEnd
	end

	def fillStart
		@tableA.addCell(0, 0, false, false, false, 0)
		@tableB.addCell(0, 0, false, false, false, 0)
		@tableC.addCell(0, 0, false, false, false, 0)
		i = 1
		while(i < @vl)
			@tableA.addCell(i, 0, false, false, false, 0)
			@tableB.addCell(i, 0, false, false, false, 0)
			@tableC.addCell(i, 0, false, false, false, 0)
			i += 1
		end
		j = 1
		while(j < @wl)
			@tableA.addCell(0, j, false, false, false, 0)
			@tableB.addCell(0, j, false, false, false, 0)
			@tableC.addCell(0, j, false, false, false, 0)
			j += 1
		end
	end

	def fillEnd
		i = 1
		while (i < @vl)
			j = 1
			while (j < @wl)
				addCellsBySymbol(i, j)
				j += 1
			end
			i += 1
		end
	end

	def addCellsBySymbol(i, j)
		addCellToTableA(i, j)
		addCellToTableB(i, j)
		addCellToTableC(i, j)
	end

	def addCellToTableA(i, j)
		sv = @v[i]
		sw = @w[j]
		ma = match(sv, sw)
		sA = ma + @tableA.matrix[i - 1][j - 1].score
		sB = ma + @tableB.matrix[i - 1][j - 1].score
		sC = ma + @tableC.matrix[i - 1][j - 1].score
		max = [sA, sB, sC, 0].max
		if(max > 0)
			@islands.push([max, i, j, Arrow::DA])
			@tableA.addCell(i, j, sA == max, sB == max, sC == max, max)
		else
			@tableA.addCell(i, j, false, false, false, 0)
		end
	end

	def addCellToTableB(i, j)
		sA = @tableA.matrix[i][j - 1].score - (@h + @g)
		sB = @tableB.matrix[i][j - 1].score - @g
		sC = @tableC.matrix[i][j - 1].score - (@h + @g)
		max = [sA, sB, sC, 0].max
		if(max > 0)
			@islands.push([max, i, j, Arrow::LB])
			@tableB.addCell(i, j, sA == max, sB == max, sC == max, max)
		else
			@tableB.addCell(i, j, false, false, false, 0)
		end
	end

	def addCellToTableC(i, j)
		sA = @tableA.matrix[i - 1][j].score - (@h + @g)
		sB = @tableB.matrix[i - 1][j].score - (@h + @g)
		sC = @tableC.matrix[i - 1][j].score - @g
		max = [sA, sB, sC, 0].max
		if(max > 0)
			@islands.push([max, i, j, Arrow::UC])
			@tableC.addCell(i, j, sA == max, sB == max, sC == max, max)
		else
			@tableC.addCell(i, j, false, false, false, 0)
		end
	end

	def getResults
		results = []
		@islands = quicksort(@islands)
		@islands.each do |island|
			arrow = island[3]
			table = arrow == Arrow::DA ? @tableA : (arrow == Arrow::LB ? @tableB : @tableC)
			results.push(getResultTable(island[1], island[2], table, false))
		end
		return results
	end

end
