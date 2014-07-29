#Command Line Inteface
load "Loads.rb"

class CLI

	def initialize
		loadSequences
		displayMainMenu
		#global = Global.new(@v, @w)
		#local = Local.new(@v, @w)
		#blocksGlobal = BlocksGlobal.new(@v, @w)
		#blocksLocal = BlocksLocal.new(@v, @w)
		#banded = Banded.new(@v, @w)
	end

	def loadSequences
		#puts "Escriba el nombre del primer archivo: "
		#file1 = gets()
		#@v = getSequence(file1.chomp)
		@v = getSequence("Seq1.txt")
		#puts "Escriba el nombre del segundo archivo: "
		#file2 = gets()
		#@w = getSequence(file2.chomp)
		@w = getSequence("Seq2.txt")
	end

	def getSequence(file)
		File.open(file, "r") do |seq|
			line = seq.gets
			sequence = line.chomp.chars.to_a
			sequence.unshift($EPSILON_SYMBOL)
			return sequence
		end
	end

	def displayMainMenu
		begin
			print "\n\t============ Menu ============\n"
			print "\t1. Cargar secuencias\n"
			print "\t2. Ejecutar alineamientos\n"
			print "\t3. Salir\n"
			print "\t==============================\n"
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
					print "Seleccione 1, 2 o 3\n"
			end
		print $NEWLINE
		end while(option != "3")
	end

	def selectFiles
		loadFiles
		print "\n\t------------------------------\n"
		print "\tSeleccione el primer archivo:\n"
		displayFiles
		print "\t------------------------------\n"
		print "Archivo: "
		first = gets().chomp
		print "\n\t------------------------------\n"
		print "\tSeleccione el segundo archivo:\n"
		displayFiles
		print "\t------------------------------\n"
		print "Archivo: "
		second = gets().chomp
		@v = getSequence(@files[first.to_i + 1])
		@w = getSequence(@files[second.to_i + 1])
		print "\nSecuencias cargadas:\n"
		printSequences
	end

	def loadFiles
		@files = Dir.entries(".").sort
	end

	def selectAlignment
		displayAlignments
		print "Opcion: "
		align = gets().chomp
		case align
			when "1"
				global = Global.new(@v, @w)
			when "2"
				local = Local.new(@v, @w)
			when "3"
				banded = Banded.new(@v, @w)
			when "4"
				blocksGlobal = BlocksGlobal.new(@v, @w)
			when "5"
				blocksLocal = BlocksLocal.new(@v, @w)
			else
				print "Opcion no valida\n"
		end
	end

	def displayAlignments
		print "\n\t------------------------------\n"
		print "\tSeleccione el alineamiento:\n"
		print "\t1. Global\n"
		print "\t2. Local\n"
		print "\t3. Global con K-band\n"
		print "\t4. Global usando bloques de gaps\n"
		print "\t5. Local usando bloques de gaps\n"
		print "\t------------------------------\n"
	end

	def displayFiles
		cont = 1
		@files.each do |file|
			if(not(file == ".") && not(file == ".."))
				print "\t\t" + cont.to_s + ". " + file + $NEWLINE
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
		length = seq.length
		while(ind < length)
			print seq[ind] + $SPACE
			ind += 1
		end
		print $NEWLINE
	end

end

cli = CLI.new
