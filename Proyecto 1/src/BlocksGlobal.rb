class BlocksGlobal < BaseBlocks

	def initialize(v, w)
		super(v, w)
	end

	def fillTables
		fillStart
		fillEnd
	end

	def fillStart
		@tableA.addCell(0, 0, false, false, false, 0)
		@tableB.addCell(0, 0, false, false, false, $NEGATIVE_INFINITY)
		@tableC.addCell(0, 0, false, false, false, $NEGATIVE_INFINITY)
		@tableA.addCell(1, 0, false, false, false, $NEGATIVE_INFINITY)
		@tableB.addCell(1, 0, false, false, false, $NEGATIVE_INFINITY)
		@tableC.addCell(1, 0, true, false, false, -(@h + @g))
		@tableA.addCell(0, 1, false, false, false, $NEGATIVE_INFINITY)
		@tableB.addCell(0, 1, true, false, false, -(@h + @g))
		@tableC.addCell(0, 1, false, false, false, $NEGATIVE_INFINITY)
		i = 2
		while(i < @vl)
			@tableA.addCell(i, 0, false, false, false, $NEGATIVE_INFINITY)
			@tableB.addCell(i, 0, false, false, false, $NEGATIVE_INFINITY)
			@tableC.addCell(i, 0, false, false, true, -(@h + @g * i))
			i += 1
		end
		j = 2
		while(j < @wl)
			@tableA.addCell(0, j, false, false, false, $NEGATIVE_INFINITY)
			@tableB.addCell(0, j, false, true, false, -(@h + @g * j))
			@tableC.addCell(0, j, false, false, false, $NEGATIVE_INFINITY)
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
		sA = @tableA.matrix[i - 1][j - 1].score
		sB = @tableB.matrix[i - 1][j - 1].score
		sC = @tableC.matrix[i - 1][j - 1].score
		max = [sA, sB, sC].max
		score = match(sv, sw) + max
		@tableA.addCell(i, j, sA == max, sB == max, sC == max, score)
	end

	def addCellToTableB(i, j)
		sA = @tableA.matrix[i][j - 1].score - (@h + @g)
		sB = @tableB.matrix[i][j - 1].score - @g
		sC = @tableC.matrix[i][j - 1].score - (@h + @g)
		max = [sA, sB, sC].max
		@tableB.addCell(i, j, sA == max, sB == max, sC == max, max)
	end

	def addCellToTableC(i, j)
		sA = @tableA.matrix[i - 1][j].score - (@h + @g)
		sB = @tableB.matrix[i - 1][j].score - (@h + @g)
		sC = @tableC.matrix[i - 1][j].score - @g
		max = [sA, sB, sC].max
		@tableC.addCell(i, j, sA == max, sB == max, sC == max, max)
	end

	def getResultTables
		i = @vl - 1
		j = @wl - 1
		sA = @tableA.matrix[i][j].score
		sB = @tableB.matrix[i][j].score
		sC = @tableC.matrix[i][j].score
		max = [sA, sB, sC].max
		resultTable = nil
		if(sA == max)
			resultTable = getResultTable(i, j, @tableA, true)
		elsif(sB == max)
			resultTable = getResultTable(i, j, @tableB, true)
		elsif(sC == max)
			resultTable = getResultTable(i, j, @tableC, true)
		end
		return resultTable
	end

end
