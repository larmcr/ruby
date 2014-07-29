# Parent class
class BaseTable < Base

	attr_reader :matrix, :gap

	def initialize(v, w)
		super(v, w)
		@matrix = Array.new(@vl) { Array.new(@wl) }
	end

	def setGap(gap)
		@gap = gap
	end

	def addCell(i, j, dA, lB, uC, score)
		@matrix[i][j] = Cell.new(dA, lB, uC, score, false)
	end

	def getResult(i, j, global)
		scoring = @matrix[i][j].score
		vr = []
		wr = []
		begin
			cell = @matrix[i][j]
			arrow = cell.getArrow
			if(global)
				cell.setSolution
			end
			if(arrow != Arrow::NONE)
				if(!global)
					cell.setSolution
				end
				if(arrow == Arrow::DA)
					vr.unshift(@v[i])
					wr.unshift(@w[j])
					match = match(@v[i], @w[j])
					i -= 1
					j -= 1
				elsif(arrow == Arrow::LB)
					vr.unshift($GAP_SYMBOL)
					wr.unshift(@w[j])
					j -= 1
				elsif(arrow == Arrow::UC)
					vr.unshift(@v[i])
					wr.unshift($GAP_SYMBOL)
					i -= 1
				end
			end
		end until(arrow == Arrow::NONE)
		return Result.new(scoring, vr, wr)
	end

	def getFinalTable
		table = Array.new(@vl + 1) { Array.new(@wl + 1) }
		table[0][0] = getCell($TABLE_SYMBOL, true)
		j = 1
		@w.each do |ws|
			table[0][j] = getCell(ws, true)
			j += 1
		end
		i = 1
		@v.each do |vs|
			table[i][0] = getCell(vs, true)
			j = 1
			while(j <= @wl)
				table[i][j] = @matrix[i - 1][j - 1]
				j += 1
			end
			i += 1
		end
		return table
	end

	def printTable(sol)
		table = getFinalTable
		widths = Array.new(@wl + 1) { 0 }
		adjustWidths(table, widths)
		printMatrix(table, widths, getBorders(widths), sol)
	end

	def getCell(val, sol)
		return Cell.new(false, false, false, $SPACE + val + $SPACE, sol)
	end

	def adjustWidths(rows, widths)
		rows.each do |row|
			col = 0
			len = widths.length
			while(col < len)
				value = getValue(row, col, false);
				length = value.length
				if(widths[col] < length)
					widths[col] = length;
				end
				col += 1
			end
		end
	end

	def getValue(array, index, sol)
		value = $EMPTY
		if(!sol || (sol && array[index].solution))
			score = array[index].score
			value = score != $NEGATIVE_INFINITY ? score.to_s : $NEGATIVE_INFINITY_SYMBOL
		end
		return value
	end

	def printMatrix(table, widths, horBor, sol)
		print horBor + $NEWLINE
		table.each do |row|
			print getRow(row, widths, sol) + $NEWLINE
			print horBor + $NEWLINE
		end
	end

	def getBorders(widths)
		result = $BORDER_KNOT
		widths.each do |w|
			i = 0
			while(i < w)
				result += $HORIZONTAL_BORDER
				i += 1
			end
			result += $BORDER_KNOT
		end
		return result
	end

	def getRow(row, widths, sol)
		result = $VERTICAL_BORDER
		max = widths.length
		col = 0
		while(col < max)
			result += getPrint(getValue(row, col, sol), widths[col]) + $VERTICAL_BORDER
			col += 1
		end
		return result
	end

	def getPrint(val, len)
		result = $EMPTY
		length = len - val.length
		while length > 0
			result += $SPACE
			length -= 1
		end
		result += val
		return result
	end

	def printArrows(arrows)
		print "+-------+"
		@w.each do |ws|
			print "-------+"
		end
		print "\n|   #   "
		j = 1
		@w.each do |ws|
			print "|   " + ws + "   "
			j += 1
		end
		print "|\n+-------+"
		@w.each do |ws|
			print "-------+"
		end
		print $NEWLINE
		i = 1
		@v.each do |vs|
			print "|   " + vs + "   "
			j = 1
			while(j <= @wl)
				cell = @matrix[i - 1][j - 1]
				print "| "
				if(cell.dA)
					print arrows ? $ARROW_DIAGONAL : "A"
				else
					print $SPACE
				end
				print $SPACE
				if(cell.lB)
					print arrows ? $ARROW_LEFT : "B"
				else
					print $SPACE
				end
				print $SPACE
				if(cell.uC)
					print arrows ? $ARROW_UP : "C"
				else
					print $SPACE
				end
				print $SPACE
				j += 1
			end
			print "|\n+-------+"
			@w.each do |ws|
				print "-------+"
			end
			print $NEWLINE
			i += 1
		end
	end

end

