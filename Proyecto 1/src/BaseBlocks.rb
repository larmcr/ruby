class BaseBlocks < Base

	attr_reader :h, :g, :tableA, :tableB, :tableC

	def initialize(v, w)
		super(v, w)
		createTables(v, w)
	end

	def setVariables(g, h)
		@g = g
		@h = h
	end

	def createTables(v, w)
		@tableA = BaseTable.new(v, w)
		@tableB = BaseTable.new(v, w)
		@tableC = BaseTable.new(v, w)
	end

	def printTables(sol)
		print $NEWLINE
		print "Tabla A:\n"
		@tableA.printTable(sol)
		print $NEWLINE
		print "Tabla B:\n"
		@tableB.printTable(sol)
		print $NEWLINE
		print "Tabla C:\n"
		@tableC.printTable(sol)
	end

	def printTablesArrows
		print $NEWLINE
		print "Tabla A: " + $ARROW_DIAGONAL + $NEWLINE
		@tableA.printArrows(false)
		print $NEWLINE
		print "Tabla B: " + $ARROW_LEFT + $NEWLINE
		@tableB.printArrows(false)
		print $NEWLINE
		print "Tabla C: " + $ARROW_UP + $NEWLINE
		@tableC.printArrows(false)
	end

	def getResultTable(i, j, table, global)
		scoring = table.matrix[i][j].score
		vr = []
		wr = []
		begin
			cell = table.matrix[i][j]
			arrow = cell.getArrow
			if(global)
				cell.setSolution
			end
			if(arrow != Arrow::NONE)
				if(!global)
					cell.setSolution
				end
				if(table == @tableA)
					vr.unshift(@v[i])
					wr.unshift(@w[j])
					i -= 1
					j -= 1
				elsif(table == @tableB)
					vr.unshift($GAP_SYMBOL)
					wr.unshift(@w[j])
					j -= 1
				elsif(table == @tableC)
					vr.unshift(@v[i])
					wr.unshift($GAP_SYMBOL)
					i -= 1
				end
				if(arrow == Arrow::DA)
					table = @tableA
				elsif(arrow == Arrow::LB)
					table = @tableB
				elsif(arrow == Arrow::UC)
					table = @tableC
				end
			end
		end until(arrow == Arrow::NONE)
		return Result.new(scoring, vr, wr)
	end

end
