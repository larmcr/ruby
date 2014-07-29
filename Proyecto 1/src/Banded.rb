#K-Band

class Banded < BaseTable

	attr_reader :k, :cals

	def initialize(v, w)
		super(v, w)
		@cals = 0
	end

	def setBand(k, a, t)
		@k = k
		@a = a
		@t = t
		@m = @vl - 1
		@n = @wl - 1
		@min = @n - @m - @k
	end

	def fillTable
		fillStart
		fillEnd
	end

	def fillStart
		addCell(0, 0, false, false, false, 0)
		i = 1
		while(i < @vl)
			if(isBanded(i, 0))
				@cals += 1
				addCell(i, 0, false, false, true, i * @gap)
			else
				fillInfinityCell(i, 0)
			end
			i += 1
		end
		j = 1
		while(j < @wl)
			if(isBanded(0, j))
				@cals += 1
				addCell(0, j, false, true, false, j * @gap)
			else
				fillInfinityCell(0, j)
			end
			j += 1
		end
	end

	def fillEnd
		i = 1
		while (i < @vl)
			j = 1
			while(j < @wl)
				if(isBanded(i, j))
					@cals += 1
					addCellBySymbol(i, j)
				else
					fillInfinityCell(i, j)
				end
				j += 1
			end
			i += 1
		end
		checkScore(i - 1, j - 1)
	end

	def checkScore(i, j)
		score = @matrix[i][j].score
		if(not(isOptimal(score)))
			if(@t == "*")
				setBand(@k * @a, @a, @t)
			else
				setBand(@k + @a, @a, @t)
			end
			fillTable
		end
	end

	def isOptimal(score)
		kPlusOne = @gap * (2 * (@k + 1) + @m - @n) + (@n - @k - 1) * @mat
		return score >= kPlusOne
	end

	def isBanded(i, j)
		dif = i - j
		return @min <= dif && dif <= @k
	end

	def fillInfinityCell(i, j)
		addCell(i, j, false, false, false, $NEGATIVE_INFINITY)
	end

	def addCellBySymbol(i, j)
		sv = @v[i]
		sw = @w[j]
		sm = @matrix[i - 1][j - 1].score + match(sv, sw)
		si = @matrix[i][j - 1].score + @gap
		sj = @matrix[i - 1][j].score + @gap
		max = [sm, si, sj].max
		addCell(i, j, sm == max, si == max, sj == max, max)
	end

	def printVals
		print "\nValor de 'k' final: " + @k.to_s + $NEWLINE
		print "Cantidad de calculos: " + @cals.to_s + $NEWLINE
	end

end

