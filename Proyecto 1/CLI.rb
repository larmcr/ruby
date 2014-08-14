#Command Line Inteface

load "src/Loads.rb"

class CLI

	def initialize
		displayMainMenu
	end

	def displayMainMenu
		begin
			print "\n\t========== Menu ==========\n"
			print "\t1. Cargar secuencias\n"
			print "\t2. Ejecutar alineamientos\n"
			print "\t3. Salir\n"
			print "\t==========================\n"
			print "Opcion: "
			option = gets().chomp
			case option
				when "1"
					selectFiles
				when "2"
					selectAlignment
				when "3"
					print "Programa finalizado\n"
				else
					print "Introduzca 1, 2 o 3\n"
			end
		print $NEWLINE
		end while(option != "3")
	end

	def selectFiles
		loadFiles
		print "\n\t=== Seleccione el primer archivo ===\n"
		displayFiles
		print "\t====================================\n"
		print "Archivo: "
		fir = gets().chomp
		print "\n\t=== Seleccione el segundo archivo ===\n"
		displayFiles
		print "\t=====================================\n"
		print "Archivo: "
		sec = gets().chomp
		firSeq = getSequence(@files[fir.to_i + 1])
		secSeq = getSequence(@files[sec.to_i + 1])
		if(firSeq.length >= secSeq.length)
			@v = firSeq
			@w = secSeq
		else
			@v = secSeq
			@w = firSeq
		end
		print "\nSecuencias cargadas:\n"
		printSequences
	end

	def loadFiles
		@files = Dir.entries(".").sort
	end

	def getSequence(file)
		File.open(file, "r") do |seq|
			line = seq.gets
			sequence = line.chomp.chars.to_a
			sequence.unshift($EPSILON_SYMBOL)
			return sequence
		end
	end

	def selectAlignment
		displayAlignments
		print "Opcion: "
		align = gets().chomp
		case align
			when "1"
				global = Global.new(@v, @w)
				setMatch(global)
				setGap(global)
				global.fillTable
				print "\nTabla de alineamiento Global:\n"
				global.printTable(false)
				res = global.getResult(global.vl - 1, global.wl - 1, true)
				printResult(res)
				print "\nDesea ver el camino de la solucion? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					global.printTable(true)
				end
				print "\nDesea ver las flechas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					global.printArrows(true)
				end
			when "2"
				local = Local.new(@v, @w)
				setMatch(local)
				setGap(local)
				local.fillTable
				print "\nTabla de alineamiento Local:\n"
				local.printTable(false)
				results = local.getResults
				printResults(results)
				print "\nDesea ver las islas generadas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					local.printTable(true)
				end
				print "\nDesea ver las flechas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					local.printArrows(true)
				end
			when "3"
				banded = Banded.new(@v, @w)
				setMatch(banded)
				setGap(banded)
				setBand(banded)
				banded.fillTable
				print "\nTabla de alineamiento K-Band:\n"
				banded.printTable(false)
				banded.printVals
				res = banded.getResult(banded.vl - 1, banded.wl - 1, true)
				printResult(res)
				print "\nDesea ver el camino de la solucion? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					banded.printTable(true)
				end
				print "\nDesea ver las flechas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					banded.printArrows(true)
				end
			when "4"
				blocksGlobal = BlocksGlobal.new(@v, @w)
				setMatch(blocksGlobal)
				setVariables(blocksGlobal)
				blocksGlobal.fillTables
				blocksGlobal.printTables(false)
				res = blocksGlobal.getResultTables
				printResult(res)
				print "\nDesea ver el camino de la solucion? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					blocksGlobal.printTables(true)
				end
				print "\nDesea ver las flechas hacia las tablas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					blocksGlobal.printTablesArrows
				end
			when "5"
				blocksLocal = BlocksLocal.new(@v, @w)
				setMatch(blocksLocal)
				setVariables(blocksLocal)
				blocksLocal.fillTables
				blocksLocal.printTables(false)
				results = blocksLocal.getResults
				printResults(results)
				print "\nDesea ver las islas generadas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					blocksLocal.printTables(true)
				end
				print "\nDesea ver las flechas hacia las tablas? (y/n): "
				yn = gets().chomp
				if(yn == "Y" || yn == "y")
					blocksLocal.printTablesArrows
				end
			else
				print "Opcion no valida\n"
		end
	end

	def displayAlignments
		print "\n\t=== Seleccione el alineamiento ===\n"
		print "\t1. Global\n"
		print "\t2. Local\n"
		print "\t3. Global con K-band\n"
		print "\t4. Global usando bloques de gaps\n"
		print "\t5. Local usando bloques de gaps\n"
		print "\t==================================\n"
	end

	def displayFiles
		cont = 1
		@files.each do |file|
			if(not(file == ".") && not(file == ".."))
				print "\t" + cont.to_s + ". " + file + $NEWLINE
				cont += 1
			end
		end
	end

	def printSequences
		printSequence(@v, 1, $NU_SYMBOL)
		printSequence(@w, 1, $OMEGA_SYMBOL)
	end

	def printSequence(seq, ind, lab)
		print lab + ":" + $SPACE
		len = seq.length
		while(ind < len)
			print seq[ind] + $SPACE
			ind += 1
		end
		print $NEWLINE
	end

	def setMatch(ali)
		print "Introduzca el valor de 'match': "
		mat = gets().chomp.to_i
		print "Introduzca el valor de 'mismatch': "
		mis = gets().chomp.to_i
		ali.setMatch(mat, mis)
	end

	def setGap(ali)
		print "Introduzca el valor de 'gap penalty': "
		gap = gets().chomp.to_i
		ali.setGap(gap)
	end

	def setBand(banded)
		print "Introduzca el valor inicial de 'k': "
		k = gets().chomp.to_i
		print "Introduzca el valor a incrementar de 'k': "
		a = gets().chomp.to_i
		print "Introduzca el tipo de incremento (+/*): "
		t = gets().chomp
		banded.setBand(k, a, t)
	end

	def setVariables(blocks)
		print "Introduzca el valor de 'g': "
		g = gets().chomp.to_i
		print "Introduzca el valor de 'h': "
		h = gets().chomp.to_i
		blocks.setVariables(g, h)
	end

	def printResult(res)
		print "\nScoring: " + res.sc.to_s + $NEWLINE
		print "Alineamiento: \n"
		printSequence(res.vr, 0, $NU_SYMBOL)
		printSequence(res.wr, 0, $OMEGA_SYMBOL)
	end

	def printResults(results)
		len = results.length
		if(len > 0)
			score = results[0].sc
			ind = 0
			flag = true
			while(flag && ind < len)
				res = results[ind]
				sc = res.sc
				if(score == sc)
					printResult(res)
				else
					print "\nDesea ver los resultados con scoring " + sc.to_s + "? (y/n): "
					yn = gets().chomp
					if(yn == "Y" || yn == "y")
						score = sc
						ind -= 1
					else
						flag = false
					end
				end
				ind += 1
			end
		end
	end
end

cli = CLI.new
