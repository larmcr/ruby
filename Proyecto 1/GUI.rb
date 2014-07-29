#Graphical User Interface

require 'gtk2'
load "src/Loads.rb"

class GUI < Gtk::Window

	def initialize
		super
		set_title "Proyecto 1"
		signal_connect "destroy" do 
			Gtk.main_quit 
		end
		set_default_size(400, 300)
		set_window_position(Gtk::Window::POS_CENTER)
		setUI
		show_all

		#example
	end

	def setUI
		lblFir = Gtk::Label.new("Primer archivo:")
		lblSec = Gtk::Label.new("Segundo archivo:")
		lblMat = Gtk::Label.new("Match:")
		lblMis = Gtk::Label.new("Mismatch:")
		lblGap = Gtk::Label.new("Gap penalty:")
		lblKi = Gtk::Label.new("K inicial:")
		lblKa = Gtk::Label.new("Aumento de K:")
		lblG = Gtk::Label.new("G:")
		lblH = Gtk::Label.new("H:")

		etyMat = Gtk::Entry.new
		etyMis = Gtk::Entry.new
		etyGap = Gtk::Entry.new
		etyKi = Gtk::Entry.new
		etyKa = Gtk::Entry.new
		etyG = Gtk::Entry.new
		etyH = Gtk::Entry.new

		cbxTypes = Gtk::Combo.new(getTypes)

		cbxOptions = Gtk::Combo.new(getOptions)
		cbxOptions.set_sensitive(false)
		cbxOptions.entry.editable = false
		cbxOptions.entry.signal_connect("changed") do
			selectAlignment(cbxOptions.entry.text, etyMat, etyMis, etyGap, etyKi, etyKa, cbxTypes.entry.text, etyG, etyH)
		end
		
		btnFir = Gtk::FileChooserButton.new("Seleccione el primer archivo", Gtk::FileChooser::ACTION_OPEN)
		btnSec = Gtk::FileChooserButton.new("Seleccione el segundo archivo", Gtk::FileChooser::ACTION_OPEN)
		btnFir.signal_connect("file-set") do
			checkFiles(cbxOptions, btnFir, btnSec)
		end
		btnSec.signal_connect("file-set") do
			checkFiles(cbxOptions, btnFir, btnSec)
		end

		lblFir.set_size_request(115, 30)
		lblSec.set_size_request(115, 30)
		lblMat.set_size_request(50, 30)
		lblMis.set_size_request(75, 30)
		lblGap.set_size_request(100, 30)
		lblKi.set_size_request(55, 30)
		lblKa.set_size_request(100, 30)
		lblG.set_size_request(15, 30)
		lblH.set_size_request(15, 30)

		etyMat.set_size_request(50, 30)
		etyMis.set_size_request(50, 30)
		etyGap.set_size_request(50, 30)
		etyKi.set_size_request(50, 30)
		etyKa.set_size_request(50, 30)
		etyG.set_size_request(50, 30)
		etyH.set_size_request(50, 30)
		
		btnFir.set_size_request(250, 30)
		btnSec.set_size_request(250, 30)

		cbxTypes.set_size_request(60, 33)
		cbxOptions.set_size_request(250, 33)
		
		fixed = Gtk::Fixed.new
		fixed.put(lblFir, 10, 10)
		fixed.put(btnFir, 135, 10)
		fixed.put(lblSec, 10, 50)
		fixed.put(btnSec, 135, 50)
		fixed.put(lblMat, 10, 90)
		fixed.put(etyMat, 60, 90)
		fixed.put(lblMis, 135, 90)
		fixed.put(etyMis, 210, 90)
		fixed.put(lblGap, 200, 130)
		fixed.put(etyGap, 300, 130)
		fixed.put(lblKi, 10, 170)
		fixed.put(etyKi, 70, 170)
		fixed.put(lblKa, 150, 170)
		fixed.put(etyKa, 255, 170)
		fixed.put(cbxTypes, 325, 170)
		fixed.put(lblG, 50, 210)
		fixed.put(etyG, 70, 210)
		fixed.put(lblH, 175, 210)
		fixed.put(etyH, 195, 210)
		fixed.put(cbxOptions, 100, 250)

		add(fixed)
	end

	def checkFiles(cbxOptions, btnFir, btnSec)
		flag = btnFir.filename != nil && btnSec.filename != nil
		if(flag)
			loadSequences(btnFir, btnSec)
		end
		cbxOptions.set_sensitive(flag)
	end

	def getOptions
		options = 
		[
			"Seleccione el alineamiento",
			"Global",
			"Local",
			"Global con K-band",
			"Global usando bloques de gaps",
			"Local usando bloques de gaps"
		]
		return options
	end

	def getTypes
		return ["+", "*"]
	end

	def selectAlignment(opt, etyMat, etyMis, etyGap, etyKi, etyKa, type, etyG, etyH)
		case opt
			when "Global"
				global = Global.new(@v, @w)
				global.setMatch(etyMat.text.to_i, etyMis.text.to_i)
				global.setGap(etyGap.text.to_i)
				global.fillTable
				result = global.getResult(global.vl - 1, global.wl - 1, true)
				matrix = global.getFinalTable
				showTable("Tabla de alineamiento Global", matrix, false, true)
				showScoringResults([result])
			when "Local"
				local = Local.new(@v, @w)
				local.setMatch(etyMat.text.to_i, etyMis.text.to_i)
				local.setGap(etyGap.text.to_i)
				local.fillTable
				results = local.getResults
				matrix = local.getFinalTable
				showTable("Tabla de alineamiento Local", matrix, false, true)
				showResults(results)
			when "Global con K-band"
				banded = Banded.new(@v, @w)
				banded.setMatch(etyMat.text.to_i, etyMis.text.to_i)
				banded.setGap(etyGap.text.to_i)
				banded.setBand(etyKi.text.to_i, etyKa.text.to_i, type)
				banded.fillTable
				result = banded.getResult(banded.vl - 1, banded.wl - 1, true)
				matrix = banded.getFinalTable
				showTable("Tabla de alineamiento K-band", matrix, false, true)
				showScoringResults([result])
				showFinalVals(banded.k, banded.cals)
			when "Global usando bloques de gaps"
				blocksGlobal = BlocksGlobal.new(@v, @w)
				blocksGlobal.setMatch(etyMat.text.to_i, etyMis.text.to_i)
				blocksGlobal.setVariables(etyG.text.to_i, etyH.text.to_i)
				blocksGlobal.fillTables
				results = blocksGlobal.getResultTables
				showTables(blocksGlobal)
				showResults([results])
			when "Local usando bloques de gaps"
				blocksLocal = BlocksLocal.new(@v, @w)
				blocksLocal.setMatch(etyMat.text.to_i, etyMis.text.to_i)
				blocksLocal.setVariables(etyG.text.to_i, etyH.text.to_i)
				blocksLocal.fillTables
				results = blocksLocal.getResults
				showTables(blocksLocal)
				showResults(results)
		end
	end

	def loadSequences(btnFir, btnSec)
		firSeq = getSequence(btnFir.filename)
		secSeq = getSequence(btnSec.filename)
		if(firSeq.length >= secSeq.length)
			@v = firSeq
			@w = secSeq
		else
			@v = secSeq
			@w = firSeq
		end
		@vl = @v.length
		@wl = @w.length
		showSequences
	end

	def showSequences
		table = Gtk::Table.new(2, @vl, true)
		button = Gtk::Button.new($NU_SYMBOL + $SPACE + $ARROW_RIGHT)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
		table.attach(button, 0, 1, 0, 1)
		button = Gtk::Button.new($OMEGA_SYMBOL + $SPACE + $ARROW_RIGHT)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
		table.attach(button, 0, 1, 1, 2)
		i = 1
		while(i < @vl)
			button = Gtk::Button.new(@v[i])
			button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
			table.attach(button, i, i + 1, 0, 1)
			i += 1
		end
		j = 1
		while(j < @wl)
			button = Gtk::Button.new(@w[j])
			button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
			table.attach(button, j, j + 1, 1, 2)
			j += 1
		end
		scroll = Gtk::ScrolledWindow.new
		scroll.border_width = 5
		scroll.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
		window = Gtk::Window.new("Secuencias")
		window.set_size_request(800, 100)
		viewport  = Gtk::Viewport.new(scroll.hadjustment, scroll.vadjustment)
		viewport.add(table)
		scroll.add(viewport)
		window.add(scroll)
		window.show_all
	end

	def getSequence(file)
		File.open(file, "r") do |seq|
			line = seq.gets
			sequence = line.chomp.chars.to_a
			sequence.unshift($EPSILON_SYMBOL)
			return sequence
		end
	end

	def showTable(label, matrix, message, arrows)
		table = Gtk::Table.new(@vl + 1, @wl + 1, true)
		i = 0
		while(i <= @vl)
			j = 0
			while(j <= @wl)
				cell = matrix[i][j]
				score = cell.score
				value = $EMTPY
				infinity = (score == $NEGATIVE_INFINITY)
				if(message)
					if(i == 0 || j == 0)
						value = score
					else
						value = getMessage(cell, arrows)
					end
				else
					value = score != $NEGATIVE_INFINITY ? score.to_s : $NEGATIVE_INFINITY_SYMBOL
				end
				button = Gtk::Button.new(value)
				if (infinity)
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 0))
				end
				if((i == 0 && j > 0) ^ (j == 0 && i > 0))
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
				elsif(cell.solution && i > 0 && j > 0)
					button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
				end
				button.signal_connect("clicked") do
					showTable(label, matrix, !message, arrows)
				end
				table.attach(button, j, j + 1, i, i + 1)
				j += 1
			end
			i += 1
		end
		scroll = Gtk::ScrolledWindow.new
		scroll.border_width = 5
		scroll.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
		window = Gtk::Window.new(label)
		window.set_size_request(500, 500)
		viewport  = Gtk::Viewport.new(scroll.hadjustment, scroll.vadjustment)
		viewport.add(table)
		scroll.add(viewport)
		window.add(scroll)
		window.show_all
	end

	def showTables(ali)
		showTable("Tabla C (" + $ARROW_UP + ")", ali.tableC.getFinalTable, false, false)
		showTable("Tabla B (" + $ARROW_LEFT + ")", ali.tableB.getFinalTable, false, false)
		showTable("Tabla A (" + $ARROW_DIAGONAL + ")", ali.tableA.getFinalTable, false, false)
	end

	def showResults(results)
		len = results.length
		if(len > 0)
			score = results[0].sc
			same = []
			ind = 0
			while(ind < len)
				res = results[ind]
				sc = res.sc
				if(score != sc)
					showScoringResults(same)
					score = sc
					same = []
				end
				same.push(res)
				ind += 1
			end
			if(same.length > 0)
				showScoringResults(same)
			end
		end
	end

	def showScoringResults(results)
		scroll = Gtk::ScrolledWindow.new
		scroll.border_width = 5
		scroll.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
		viewport  = Gtk::Viewport.new(scroll.hadjustment, scroll.vadjustment)
		fixed = Gtk::Fixed.new
		score = results[0].sc.to_s
		d = 0
		results.each do |result|
			length = result.vr.length
			table = Gtk::Table.new(2, length + 1, true)
			button = Gtk::Button.new($NU_SYMBOL + $SPACE + $ARROW_RIGHT)
			button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
			table.attach(button, 0, 1, 0, 1)
			button = Gtk::Button.new($OMEGA_SYMBOL + $SPACE + $ARROW_RIGHT)
			button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
			table.attach(button, 0, 1, 1, 2)
			i = 1
			while(i <= length)
				vr = result.vr[i - 1]
				wr = result.wr[i - 1]
				button = Gtk::Button.new(vr != "_" ? vr : "___")
				button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
				table.attach(button, i, i + 1, 0, 1)
				button = Gtk::Button.new(wr != "_" ? wr : "___")
				button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
				table.attach(button, i, i + 1, 1, 2)
				i += 1
			end
			fixed.put(table, 5, d)
			d += 75
		end
		viewport.add(fixed)
		scroll.add(viewport)
		window = Gtk::Window.new("Alineamiento(s) con scoring: " + score)
		window.set_size_request(500, 250)
		window.add(scroll)
		window.show_all
	end

	def getMessage(cell, arrows)
		message = $EMPTY
		if(arrows)
			if(cell.dA)
				message += $ARROW_DIAGONAL + $SPACE
			end
			if(cell.lB)
				message += $ARROW_LEFT + $SPACE
			end
			if(cell.uC)
				message += $ARROW_UP + $SPACE
			end
		else
			if(cell.dA)
				message += "A" + $SPACE
			end
			if(cell.lB)
				message += "B" + $SPACE
			end
			if(cell.uC)
				message += "C" + $SPACE
			end
		end
		return $SPACE + message
	end

	def showFinalVals(k, c)
		table = Gtk::Table.new(2, 2, true)
		button = Gtk::Button.new("K " + $ARROW_RIGHT)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
		table.attach(button, 0, 1, 0, 1)
		button = Gtk::Button.new("Calculos " + $ARROW_RIGHT)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(65535, 65535, 0))
		table.attach(button, 0, 1, 1, 2)
		button = Gtk::Button.new(k.to_s)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
		table.attach(button, 1, 2, 0, 1)
		button = Gtk::Button.new(c.to_s)
		button.modify_bg(Gtk::STATE_NORMAL, Gdk::Color.new(0, 65535, 65535))
		table.attach(button, 1, 2, 1, 2)
		window = Gtk::Window.new("Valores finales")
		window.set_size_request(250, 100)
		window.add(table)
		window.show_all
	end
end

Gtk.init
	GUI.new
Gtk.main
